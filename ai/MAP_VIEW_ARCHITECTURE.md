# Map View - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate direct Supabase calls, add bounds-based fetching, enforce hard limits  
**Scope:** Map markers loading with optional bounds filtering and caching

---

## 1. Target Folder/File Structure

```
lib/
  domain/
    models/
      map_bounds.dart                    # NEW: Geographic bounds model
      claim_map_marker.dart              # NEW: Move from controller to domain
    repositories/
      map_view_repository.dart           # NEW: Interface for map queries
  data/
    datasources/
      map_view_remote_data_source.dart   # NEW: Interface
      supabase_map_view_remote_data_source.dart  # NEW: Supabase implementation
    repositories/
      map_view_repository_supabase.dart  # NEW: Repository implementation
  features/
    claims/
      controller/
        map_view_controller.dart         # UPDATE: Replace direct Supabase call
      presentation/
        map_view_screen.dart             # VERIFY: Should work as-is
        widgets/
          interactive_claims_map_widget.dart  # VERIFY: Uses ClaimMapMarker, should work
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- `ClaimMapMarker` moved to domain (shared model)
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Minimal changes to UI (reuse existing `ClaimMapMarker` model)

---

## 2. Repository Interface Method Signatures

### `lib/domain/repositories/map_view_repository.dart` (NEW)

```dart
import '../models/claim_map_marker.dart';
import '../models/map_bounds.dart';
import '../../core/utils/result.dart';
import '../value_objects/claim_enums.dart';

abstract class MapViewRepository {
  /// Fetch claims for map display
  /// 
  /// [bounds] - Optional geographic bounds (north, south, east, west)
  ///            If null, fetches all claims (initial load)
  /// [dateRange] - Optional date range filter (startDate, endDate)
  ///               If null, fetches all dates
  /// [status] - Optional status filter (null = all except closed/cancelled)
  /// [technicianId] - Optional technician filter
  /// [technicianAssignmentFilter] - Optional: true=assigned, false=unassigned, null=all
  /// [limit] - Maximum number of markers (default: 500, max: 1000)
  /// 
  /// Returns list of ClaimMapMarker (minimal payload for map pins)
  /// 
  /// Strategy:
  /// - Initial load: bounds=null, fetches up to limit claims (ordered by priority/SLA)
  /// - Bounds refine: bounds provided, fetches claims within bounds (up to limit)
  /// - Caching: Repository layer doesn't cache (controller handles caching)
  Future<Result<List<ClaimMapMarker>>> fetchMapClaims({
    MapBounds? bounds,
    DateRange? dateRange,
    ClaimStatus? status,
    String? technicianId,
    bool? technicianAssignmentFilter,
    int limit = 500,
  });
}
```

**Design decisions:**
- Single method `fetchMapClaims()` - handles all filter combinations
- Optional bounds (null = initial load, all claims)
- Optional date range (for future use)
- Hard limit: 500 default, 1000 max (prevents abuse)
- Minimal payload: Only fields needed for map markers
- No caching in repository (controller handles caching)

**Note:** `DateRange` model may need to be created if not exists.

---

## 3. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_map_view_remote_data_source.dart` (NEW)

**Query for `fetchMapClaims()`:**

```sql
-- Minimal payload query (only fields needed for map markers)
SELECT 
  c.id,
  c.claim_number,
  c.status,
  c.technician_id,
  -- Address coordinates (required for map)
  addr.lat,
  addr.lng,
  addr.street,
  addr.suburb,
  addr.city,
  addr.province,
  -- Technician name (for marker tooltip)
  p.full_name as technician_name,
  -- Client name (for marker tooltip)
  cl.first_name,
  cl.last_name
FROM claims c
JOIN addresses addr ON addr.id = c.address_id
LEFT JOIN profiles p ON p.id = c.technician_id
LEFT JOIN clients cl ON cl.id = c.client_id
WHERE addr.lat IS NOT NULL 
  AND addr.lng IS NOT NULL
  AND c.status NOT IN ('closed', 'cancelled')
  -- Optional filters
  AND (:status IS NULL OR c.status = :status)
  AND (:technician_id IS NULL OR c.technician_id = :technician_id)
  AND (
    :technician_assignment IS NULL OR
    (:technician_assignment = true AND c.technician_id IS NOT NULL) OR
    (:technician_assignment = false AND c.technician_id IS NULL)
  )
  -- Optional bounds filter (geographic bounding box)
  AND (
    :bounds IS NULL OR
    (addr.lat BETWEEN :bounds_south AND :bounds_north AND
     addr.lng BETWEEN :bounds_west AND :bounds_east)
  )
  -- Optional date range filter
  AND (
    :date_range IS NULL OR
    (c.created_at >= :start_date AND c.created_at <= :end_date)
  )
ORDER BY c.priority DESC, c.sla_started_at ASC, c.id ASC
LIMIT :limit;
```

**Supabase PostgREST equivalent:**

```dart
var query = _client
    .from('claims')
    .select('''
      id,
      claim_number,
      status,
      technician_id,
      address:addresses!claims_address_id_fkey(
        lat,
        lng,
        street,
        suburb,
        city,
        province
      ),
      technician:profiles!claims_technician_id_fkey(
        full_name
      ),
      client:clients!claims_client_id_fkey(
        first_name,
        last_name
      )
    ''')
    // Exclude closed/cancelled
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    // Require valid coordinates
    .not('address.lat', 'is', null)
    .not('address.lng', 'is', null);

// Apply status filter
if (status != null) {
  query = query.eq('status', status.value);
}

// Apply technician filter
if (technicianId != null) {
  query = query.eq('technician_id', technicianId);
}

// Apply technician assignment filter
if (technicianAssignmentFilter != null) {
  if (technicianAssignmentFilter == true) {
    query = query.not('technician_id', 'is', null);
  } else {
    query = query.isFilter('technician_id', null);
  }
}

// Apply bounds filter (geographic bounding box)
if (bounds != null) {
  // PostgREST doesn't support BETWEEN directly, use gte/lte
  query = query
      .gte('address.lat', bounds.south)
      .lte('address.lat', bounds.north)
      .gte('address.lng', bounds.west)
      .lte('address.lng', bounds.east);
}

// Apply date range filter (if provided)
if (dateRange != null) {
  query = query
      .gte('created_at', dateRange.startDate.toIso8601String())
      .lte('created_at', dateRange.endDate.toIso8601String());
}

// Validate and enforce limit
final pageSize = limit.clamp(1, 1000);

// Ordering: priority DESC (urgent first), then SLA (oldest first), then id (deterministic)
final data = await query
    .order('priority', ascending: false)
    .order('sla_started_at', ascending: true)
    .order('id', ascending: true)
    .limit(pageSize);
```

**Query specifications:**
- **Table:** `claims` with joins to `addresses`, `profiles` (technician), `clients`
- **Filters:**
  - Exclude closed/cancelled (hardcoded)
  - Require valid coordinates (`lat IS NOT NULL AND lng IS NOT NULL`)
  - Optional: status, technician_id, technician assignment, bounds, date range
- **Ordering:** `priority DESC, sla_started_at ASC, id ASC` (deterministic, uses existing indexes)
- **Limit:** `limit.clamp(1, 1000)` (hard max of 1000 markers)
- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)

**Index usage:**
- `addresses_geo_idx` (tenant_id, lat, lng) - supports bounds filtering (if tenant_id included in index)
- `claims_tenant_status_idx` (tenant_id, status) - supports status filtering
- `claims_agent_idx` (tenant_id, agent_id) - may help with technician filtering
- Note: Bounds filtering on `addresses.lat/lng` may not use index efficiently (PostGIS would be better, but not available)

**Bounds filtering strategy:**
- **Initial load:** `bounds = null` → Fetch all claims (up to limit, ordered by priority/SLA)
- **Bounds refine:** `bounds` provided → Fetch claims within bounding box (up to limit)
- **Performance:** Bounds filter may be slow without spatial index (PostGIS). Consider:
  - Acceptable for initial implementation (most tenants won't have 1000+ claims)
  - Future optimization: Add PostGIS extension + spatial index if needed

---

## 4. Domain Models

### `lib/domain/models/map_bounds.dart` (NEW)

```dart
/// Geographic bounding box for map queries
@freezed
class MapBounds with _$MapBounds {
  const factory MapBounds({
    required double north,  // Maximum latitude
    required double south,  // Minimum latitude
    required double east,   // Maximum longitude
    required double west,   // Minimum longitude
  }) = _MapBounds;

  const MapBounds._();

  /// Check if bounds are valid (north > south, east > west)
  bool get isValid => north > south && east > west;

  /// Check if a point is within bounds
  bool contains(double lat, double lng) {
    return lat >= south && lat <= north && lng >= west && lng <= east;
  }
}
```

### `lib/domain/models/claim_map_marker.dart` (NEW - Move from controller)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/claim_enums.dart';

part 'claim_map_marker.freezed.dart';

/// Minimal claim data for map marker display
@freezed
class ClaimMapMarker with _$ClaimMapMarker {
  const factory ClaimMapMarker({
    required String claimId,
    required String claimNumber,
    required ClaimStatus status,
    required double latitude,
    required double longitude,
    String? technicianId,
    String? technicianName,
    String? clientName,
    String? address,
  }) = _ClaimMapMarker;

  const ClaimMapMarker._();

  bool get hasTechnician => technicianId != null && technicianName != null;
}
```

**Rationale:**
- Move `ClaimMapMarker` from controller to domain (shared model)
- Create `MapBounds` for geographic filtering
- Keep model minimal (only fields needed for map pins)

---

## 5. Controller/Provider Pattern

### `lib/features/claims/controller/map_view_controller.dart` (UPDATE)

**Current issues:**
- Direct Supabase call in `claimMapMarkers()` provider
- No bounds filtering
- No caching
- Silent error handling (returns empty list on error)

**New pattern:**

```dart
@riverpod
class MapViewController extends _$MapViewController {
  // Cache key: combination of bounds + filters
  // Cache value: List<ClaimMapMarker>
  final _cache = <String, List<ClaimMapMarker>>{};
  
  @override
  Future<List<ClaimMapMarker>> build({
    MapBounds? bounds,
    DateRange? dateRange,
    ClaimStatus? statusFilter,
    String? technicianId,
    bool? technicianAssignmentFilter,
  }) async {
    // Generate cache key
    final cacheKey = _generateCacheKey(
      bounds: bounds,
      dateRange: dateRange,
      statusFilter: statusFilter,
      technicianId: technicianId,
      technicianAssignmentFilter: technicianAssignmentFilter,
    );

    // Check cache first
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Fetch from repository
    final repository = ref.watch(mapViewRepositoryProvider);
    final result = await repository.fetchMapClaims(
      bounds: bounds,
      dateRange: dateRange,
      status: statusFilter,
      technicianId: technicianId,
      technicianAssignmentFilter: technicianAssignmentFilter,
      limit: 500,
    );

    if (result.isErr) {
      // Surface error to UI - AsyncValue will be AsyncError
      throw result.error;
    }

    // Cache result
    _cache[cacheKey] = result.data;
    return result.data;
  }

  /// Refresh (clear cache and reload)
  Future<void> refresh() async {
    _cache.clear();
    ref.invalidateSelf();
  }

  /// Update bounds (debounced in UI)
  Future<void> updateBounds(MapBounds? bounds) async {
    // Invalidate to trigger rebuild with new bounds
    ref.invalidateSelf();
  }

  String _generateCacheKey({
    MapBounds? bounds,
    DateRange? dateRange,
    ClaimStatus? statusFilter,
    String? technicianId,
    bool? technicianAssignmentFilter,
  }) {
    // Generate deterministic cache key from all parameters
    return '${bounds?.north}_${bounds?.south}_${bounds?.east}_${bounds?.west}_'
           '${dateRange?.startDate}_${dateRange?.endDate}_'
           '${statusFilter?.value}_${technicianId}_${technicianAssignmentFilter}';
  }
}
```

**Alternative: Simpler provider (no caching in controller):**

```dart
@riverpod
Future<List<ClaimMapMarker>> claimMapMarkers(
  Ref ref, {
  MapBounds? bounds,
  DateRange? dateRange,
  ClaimStatus? statusFilter,
  String? technicianId,
  bool? technicianAssignmentFilter,
}) async {
  final repository = ref.watch(mapViewRepositoryProvider);
  final result = await repository.fetchMapClaims(
    bounds: bounds,
    dateRange: dateRange,
    status: statusFilter,
    technicianId: technicianId,
    technicianAssignmentFilter: technicianAssignmentFilter,
    limit: 500,
  );

  if (result.isErr) {
    throw result.error;
  }

  return result.data;
}
```

**Design decision:** Use simpler provider (no caching). Riverpod's built-in caching + `keepAlive` handles caching. Bounds updates are debounced in UI.

**Debouncing strategy (in UI):**
- Debounce bounds changes (500ms delay)
- Only fetch when bounds stabilize (user stops panning/zooming)
- Initial load: bounds=null (fetch all claims)

**Error handling:**
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate
- UI shows error state with retry button

---

## 6. UI Integration Notes

### Web Map Widget (`InteractiveClaimsMapWidget`)

**Current implementation:**
- Uses `js_interop` for Google Maps API
- Receives `List<ClaimMapMarker>` as prop
- Updates markers when list changes (`didUpdateWidget`)
- No bounds change detection currently

**Integration points:**

1. **Initial load:**
   ```dart
   // In MapViewScreen
   final markersAsync = ref.watch(claimMapMarkersProvider(
     bounds: null, // Initial load: all claims
     statusFilter: _statusFilter,
     technicianId: _technicianFilter,
     technicianAssignmentFilter: _technicianAssignmentFilter,
   ));
   ```

2. **Bounds change detection (future enhancement):**
   ```dart
   // In InteractiveClaimsMapWidget (if bounds callback added)
   void onBoundsChanged(MapBounds newBounds) {
     // Debounce bounds updates (500ms)
     _boundsDebounceTimer?.cancel();
     _boundsDebounceTimer = Timer(const Duration(milliseconds: 500), () {
       widget.onBoundsChanged?.call(newBounds);
     });
   }
   ```

3. **When to fetch:**
   - **Initial load:** `bounds = null` → Fetch all claims (up to 500)
   - **Bounds change:** Debounce 500ms → Fetch claims within new bounds
   - **Filter change:** Immediate fetch (no debounce needed)
   - **Refresh:** Call `ref.invalidate(claimMapMarkersProvider(...))`

4. **When to reuse cached results:**
   - Riverpod automatically caches by provider parameters
   - Same parameters = cached result (no refetch)
   - Different parameters = new fetch
   - Manual refresh: `ref.invalidate()` clears cache

**Current widget compatibility:**
- `InteractiveClaimsMapWidget` already uses `List<ClaimMapMarker>`
- No changes needed to widget (works with new provider)
- Bounds filtering can be added later (optional enhancement)

---

## 7. Migration Checklist

### Files to Create

- [ ] `lib/domain/models/map_bounds.dart` - Geographic bounds model
- [ ] `lib/domain/models/claim_map_marker.dart` - Move from controller to domain
- [ ] `lib/domain/repositories/map_view_repository.dart` - Interface
- [ ] `lib/data/datasources/map_view_remote_data_source.dart` - Data source interface
- [ ] `lib/data/datasources/supabase_map_view_remote_data_source.dart` - Supabase implementation
- [ ] `lib/data/repositories/map_view_repository_supabase.dart` - Repository implementation

### Files to Update

- [ ] `lib/features/claims/controller/map_view_controller.dart` - Replace direct Supabase call
- [ ] `lib/features/claims/presentation/map_view_screen.dart` - Verify no changes needed (should work as-is)

### Files to Remove/Deprecate

- [ ] None (no old repository to deprecate)

### Migration Steps

1. **Create domain models:**
   - Create `MapBounds` model (freezed)
   - Move `ClaimMapMarker` from controller to domain (freezed)
   - Run `build_runner` to generate freezed code

2. **Create repository interface:**
   - Define `MapViewRepository` with `fetchMapClaims()` method
   - Define `MapViewRemoteDataSource` interface

3. **Implement data source:**
   - Implement `SupabaseMapViewRemoteDataSource` with single query (all joins)
   - Enforce `.limit(500)` with warning log if truncated
   - Apply all filters (status, technician, bounds, date range)

4. **Create repository implementation:**
   - Map data source rows to `ClaimMapMarker` domain models
   - Filter out invalid coordinates (lat/lng null or invalid)
   - Return `Result<List<ClaimMapMarker>>`

5. **Update controller:**
   - Remove direct Supabase call from `claimMapMarkers()` provider
   - Use `mapViewRepository.fetchMapClaims()`
   - Update error handling (throw errors, don't return empty list)
   - Remove `ClaimMapMarker` class definition (now in domain)

6. **Update UI (if needed):**
   - Verify `map_view_screen.dart` works with new provider (should work as-is)
   - Update imports if `ClaimMapMarker` moved to domain
   - Add bounds change detection (optional, future enhancement)

7. **Remove old code:**
   - Delete direct Supabase query from controller
   - Delete `ClaimMapMarker` class from controller (moved to domain)

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Direct Supabase call in provider
final client = ref.watch(supabaseClientProvider);
final response = await client
    .from('claims')
    .select('...')
    .neq('status', ClaimStatus.closed.value)
    .limit(500);
// ... process response, return markers
catch (err) {
  return []; // Silent failure
}
```

**After:**
```dart
// NEW: Repository call
final repository = ref.watch(mapViewRepositoryProvider);
final result = await repository.fetchMapClaims(
  bounds: bounds,
  status: statusFilter,
  technicianId: technicianId,
  technicianAssignmentFilter: technicianAssignmentFilter,
  limit: 500,
);

if (result.isErr) {
  throw result.error; // Proper error handling
}

return result.data; // List<ClaimMapMarker>
```

### Safe Rollout Steps

1. **Phase 1: Create new repository layer**
   - Create interfaces and implementations
   - Write unit tests
   - Verify query returns correct data structure

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository
   - Keep old code commented (for rollback)
   - Test with small dataset

3. **Phase 3: Verify**
   - Manual test: Load map with no filters
   - Manual test: Load map with status filter
   - Manual test: Load map with technician filter
   - Manual test: Verify markers display correctly
   - Performance test: Compare old vs. new (should be similar)

4. **Phase 4: Cleanup**
   - Remove old direct Supabase call
   - Remove commented code

---

## 8. Bounds Filtering Strategy

### Initial Load vs. Bounds Refine

**Initial load (bounds = null):**
- Fetch all claims (up to 500, ordered by priority/SLA)
- Reasonable for most tenants (500 claims = manageable)
- User sees overview of all claims

**Bounds refine (bounds provided):**
- Fetch claims within bounding box (up to 500)
- Useful for large tenants (1000+ claims)
- Reduces markers when user zooms in

**Debouncing:**
- Debounce bounds changes: 500ms delay
- Only fetch when bounds stabilize (user stops panning/zooming)
- Prevents hammering database during map interaction

**Caching:**
- Riverpod caches by provider parameters
- Same bounds + filters = cached result
- Different bounds = new fetch
- Manual refresh: `ref.invalidate()` clears cache

### Implementation Notes

**Bounds filtering (optional, future enhancement):**
- Current implementation: `bounds = null` always (fetch all claims)
- Future: Add bounds change callback to `InteractiveClaimsMapWidget`
- Future: Debounce bounds updates in UI
- Future: Pass bounds to provider when map bounds change

**For now:** Keep `bounds = null` (fetch all claims). Add bounds filtering later if needed.

---

## 9. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- All queries use `.limit(limit.clamp(1, 1000))` (hard max of 1000 markers)
- Default limit: 500 (reasonable for map view)
- Warning logged if result length == limit (may be truncated)

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Errors thrown (not swallowed)
- Errors surface to UI via `AsyncError`
- No empty list returned on error

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `MapViewRepository`
- Repository calls `MapViewRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/controllers

---

## 10. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchMapClaims()` - Initial load (bounds=null)
- [ ] `fetchMapClaims()` - With bounds filter
- [ ] `fetchMapClaims()` - With status filter
- [ ] `fetchMapClaims()` - With technician filter
- [ ] `fetchMapClaims()` - With technician assignment filter
- [ ] `fetchMapClaims()` - Combined filters
- [ ] `fetchMapClaims()` - Limit enforcement (500 default, 1000 max)
- [ ] `fetchMapClaims()` - Invalid coordinates filtered out
- [ ] `fetchMapClaims()` - Error handling (network error, RLS error)
- [ ] Data transformation: Supabase response → ClaimMapMarker

### Widget Tests (To Be Written)

- [ ] `claimMapMarkers()` provider - Loading state
- [ ] `claimMapMarkers()` provider - Data state
- [ ] `claimMapMarkers()` provider - Error state
- [ ] `claimMapMarkers()` provider - Cache behavior (same params = cached)

### Manual Testing

- [ ] Load map with no filters (verify all claims display)
- [ ] Load map with status filter (verify filtered markers)
- [ ] Load map with technician filter (verify filtered markers)
- [ ] Load map with 500+ claims (verify limit enforced, warning logged)
- [ ] Verify markers display correctly on map
- [ ] Verify marker click navigates to claim detail
- [ ] Verify error handling (network error shows error state)
- [ ] Performance: Compare old vs. new (should be similar)

---

## 11. Performance Considerations

### Query Performance

- **Index usage:** `addresses_geo_idx` may help, but bounds filtering on lat/lng may not use index efficiently
- **Join performance:** 3 joins (addresses, profiles, clients) - monitor query time
- **Limit:** 500 markers per query (reasonable for map view, prevents browser memory issues)

### Bounds Filtering Performance

- **Current:** No bounds filtering (fetches all claims, up to 500)
- **Future:** Bounds filtering may be slow without spatial index (PostGIS)
- **Recommendation:** Acceptable for initial implementation. Add PostGIS + spatial index if needed later.

### Data Transfer

- **Minimal payload:** Only fields needed for map markers (id, claim_number, status, lat/lng, technician name, client name, address)
- **No full claim objects:** Much smaller than fetching full `Claim` objects
- **Single query:** All data in one round-trip (efficient)

---

## 12. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **Bounds filtering:** Optional feature (can be added later). For now, `bounds = null` always.
- **Caching:** Riverpod handles caching automatically. No manual cache needed in controller.
- **Debouncing:** Implement in UI when bounds change detection is added (future enhancement).
- **js_interop:** Existing widget uses `js_interop` - no changes needed to widget code.
- **Future enhancements:**
  - Add bounds change detection to `InteractiveClaimsMapWidget`
  - Add PostGIS extension + spatial index for efficient bounds filtering
  - Add date range filter UI (if needed)
  - Add clustering for dense marker areas (if needed)

---

## 13. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Direct Supabase call in controller
- ❌ Silent error handling (returns empty list on error)
- ❌ No bounds filtering
- ❌ No caching strategy
- ✅ Has limit (500 markers)

**Query:** Direct Supabase call with joins

### After (Target State)

**Improvements:**
- ✅ Repository pattern (no direct Supabase calls)
- ✅ Proper error handling (errors propagate to UI)
- ✅ Optional bounds filtering (for future use)
- ✅ Riverpod caching (automatic by provider parameters)
- ✅ Hard limit enforced (500 default, 1000 max)

**Query:** Repository → Data source → Supabase (single query with all joins)

**Performance:** Similar (same query, same joins, same limit)

