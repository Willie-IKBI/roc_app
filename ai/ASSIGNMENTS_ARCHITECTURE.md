# Assignments Module - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate deprecated `fetchQueue()` usage, fix N+1 queries, add server-side filters, enforce hard limits  
**Scope:** Assignable jobs list with filters, assignment actions

---

## 1. Assignments Data Needs Analysis

### Current Assignment Requirements

**Read Operations:**
- `assignableJobs` - List of claims available for assignment
  - Filters: status, assigned/unassigned, technician, appointment date range
  - Currently: Fetches ALL claims, then filters client-side (N+1 queries)

**Write Operations:**
- `assignTechnician()` - Assign/unassign technician and set appointment
  - Uses existing `ClaimRepository.updateTechnician()` ✅
  - Uses existing `ClaimRepository.updateAppointment()` ✅
  - No new write methods needed

**Technician Data:**
- Technician list - Already available via `techniciansProvider` ✅
- Technician availability - Already available via `technicianAvailabilityProvider` ✅
- No changes needed

**Current Implementation Issues:**
- ❌ Uses deprecated `fetchQueue()` (fetches ALL claims, limited to 1000)
- ❌ N+1 queries: For each claim, fetches full `Claim` object to check `technician_id`, `appointment_date`
- ❌ All filtering done client-side (inefficient)
- ❌ Silent error handling (returns empty list on error)
- ❌ No pagination (loads all claims at once)

---

## 2. Target Folder/File Structure

```
lib/
  domain/
    repositories/
      assignments_repository.dart          # NEW: Interface for assignments queries
  data/
    datasources/
      assignments_remote_data_source.dart # NEW: Interface
      supabase_assignments_remote_data_source.dart  # NEW: Supabase implementation
    repositories/
      assignments_repository_supabase.dart # NEW: Repository implementation
  features/
    assignments/
      controller/
        assignment_controller.dart        # UPDATE: Replace fetchQueue() + N+1 queries
      presentation/
        assignment_screen.dart            # VERIFY: Should work as-is (may need pagination UI)
        widgets/
          assignment_dialog.dart          # VERIFY: Should work as-is
          job_assignment_card.dart         # VERIFY: Should work as-is
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Write operations reuse existing `ClaimRepository` methods (no new write repository needed)

---

## 3. Repository Interface Method Signatures

### `lib/domain/repositories/assignments_repository.dart` (NEW)

```dart
import '../../core/utils/result.dart';
import '../models/claim_summary.dart';
import '../models/paginated_result.dart';
import '../value_objects/claim_enums.dart';

abstract class AssignmentsRepository {
  /// Fetch paginated assignable jobs with server-side filters
  /// 
  /// [cursor] - Optional cursor for pagination (format: "sla_started_at|claim_id")
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 50, max: 100)
  /// [status] - Optional status filter (server-side)
  /// [assignedFilter] - Optional: true=assigned, false=unassigned, null=all (server-side)
  /// [technicianId] - Optional technician filter (server-side)
  /// [dateFrom] - Optional appointment date range start (server-side)
  /// [dateTo] - Optional appointment date range end (server-side)
  /// 
  /// Returns paginated results with next cursor if more data available.
  /// 
  /// Server-side filters eliminate N+1 queries:
  /// - technician_id IS NULL/NOT NULL (for assigned/unassigned)
  /// - appointment_date BETWEEN dateFrom AND dateTo (for date range)
  /// 
  /// Uses v_claims_list view for minimal payload.
  Future<Result<PaginatedResult<ClaimSummary>>> fetchAssignableJobsPage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
    bool? assignedFilter,
    String? technicianId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
}
```

**Design decisions:**
- Single method `fetchAssignableJobsPage()` - paginated with server-side filters
- Reuse `PaginatedResult<ClaimSummary>` (same as Claims Queue)
- Server-side filters eliminate N+1 queries (technician_id, appointment_date)
- Cursor-based pagination (same pattern as Claims Queue)
- Hard limit: 50 default, 100 max

**Write operations:**
- Reuse existing `ClaimRepository.updateTechnician()` ✅
- Reuse existing `ClaimRepository.updateAppointment()` ✅
- No new write methods needed

---

## 4. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_assignments_remote_data_source.dart` (NEW)

**Query for `fetchAssignableJobsPage()`:**

```dart
var query = _client
    .from('v_claims_list')  // Use view for minimal payload
    .select('*')  // View already has required fields
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);

// Apply status filter
if (status != null) {
  query = query.eq('status', status.value);
}

// Apply assigned/unassigned filter (server-side)
if (assignedFilter != null) {
  if (assignedFilter == true) {
    // Only assigned claims
    query = query.not('technician_id', 'is', null);
  } else {
    // Only unassigned claims
    query = query.isFilter('technician_id', null);
  }
}

// Apply technician filter (server-side)
if (technicianId != null) {
  query = query.eq('technician_id', technicianId);
}

// Apply appointment date range filter (server-side)
if (dateFrom != null) {
  final dateFromStr = dateFrom.toIso8601String().split('T')[0];
  query = query.gte('appointment_date', dateFromStr);
}
if (dateTo != null) {
  final dateToStr = dateTo.toIso8601String().split('T')[0];
  query = query.lte('appointment_date', dateToStr);
}

// Validate and enforce limit
final pageSize = limit.clamp(1, 100);

// Apply cursor for pagination (same pattern as Claims Queue)
if (cursor != null && cursor.isNotEmpty) {
  final parts = cursor.split('|');
  if (parts.length == 2) {
    final cursorSlaStartedAt = DateTime.parse(parts[0]);
    final cursorClaimId = parts[1];

    query = query
        .or('sla_started_at.gt.$cursorSlaStartedAt,and(sla_started_at.eq.$cursorSlaStartedAt,claim_id.gt.$cursorClaimId)')
        .order('sla_started_at', ascending: true)
        .order('claim_id', ascending: true);
  } else {
    // Invalid cursor format - treat as first page
    AppLogger.warn('Invalid cursor format: $cursor. Fetching first page.', name: 'SupabaseAssignmentsRemoteDataSource');
    query = query
        .order('sla_started_at', ascending: true)
        .order('claim_id', ascending: true);
  }
} else {
  // First page - no cursor
  query = query
      .order('sla_started_at', ascending: true)
      .order('claim_id', ascending: true);
}

// Fetch limit + 1 to detect if more data exists
final data = await query.limit(pageSize + 1);

final rows = (data as List)
    .cast<Map<String, dynamic>>()
    .map(ClaimSummaryRow.fromJson)
    .toList();

// Check if we have more data
final hasMore = rows.length > pageSize;
final items = hasMore ? rows.take(pageSize).toList(growable: false) : rows;

// Generate next cursor from last item
String? nextCursor;
if (hasMore && items.isNotEmpty) {
  final lastItem = items.last;
  nextCursor = '${lastItem.slaStartedAt.toIso8601String()}|${lastItem.claimId}';
}

return Result.ok(PaginatedResult(
  items: items,
  nextCursor: nextCursor,
  hasMore: hasMore,
));
```

**Query specifications:**
- **View:** Use `v_claims_list` (minimal payload, already has required fields)
- **Filters:**
  - Exclude closed/cancelled (hardcoded)
  - Optional: status, assigned/unassigned (technician_id IS NULL/NOT NULL), technician_id, appointment_date range
- **Ordering:** `sla_started_at ASC, claim_id ASC` (deterministic, same as Claims Queue)
- **Pagination:** Cursor-based (same pattern as Claims Queue)
- **Limit:** `limit.clamp(1, 100)` (hard max of 100)
- **RLS:** Tenant isolation enforced automatically

**Index usage:**
- `claims_tenant_status_idx` (tenant_id, status) - supports status filtering
- `claims_technician_appointment_idx` (technician_id, appointment_date, appointment_time) - supports technician + date filtering
- `claims_appointment_date_idx` (appointment_date) - supports date range filtering
- `claims_sla_started_at_idx` (sla_started_at) - supports ordering

**Server-side filters eliminate N+1:**
- **Before:** Fetch all claims → For each claim, fetch full `Claim` object to check `technician_id`, `appointment_date`
- **After:** Single query with server-side filters → No N+1 queries

---

## 5. Controller/Provider Pattern

### `lib/features/assignments/controller/assignment_controller.dart` (UPDATE)

**Current issues:**
- Uses deprecated `fetchQueue()` (fetches ALL claims)
- N+1 queries: Loops through claims, fetches full `Claim` object for each
- All filtering done client-side
- Silent error handling (returns empty list on error)
- No pagination

**New pattern:**

```dart
@riverpod
class AssignableJobsController extends _$AssignableJobsController {
  @override
  AssignableJobsState build({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    _loadInitial();
    return const AssignableJobsState();
  }

  Future<void> _loadInitial() async {
    state = const AssignableJobsState(); // Reset state for initial load
    final repository = ref.read(assignmentsRepositoryProvider);
    final result = await repository.fetchAssignableJobsPage(
      pageSize: _assignmentsPageSize,
      status: statusFilter,
      assignedFilter: assignedFilter,
      technicianId: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );

    if (result.isErr) {
      state = state.copyWith(error: result.error);
      return;
    }

    state = state.copyWith(
      items: result.data.items,
      nextCursor: result.data.nextCursor,
      hasMore: result.data.hasMore,
      error: null,
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);
    final repository = ref.read(assignmentsRepositoryProvider);
    final result = await repository.fetchAssignableJobsPage(
      pageSize: _assignmentsPageSize,
      cursor: state.nextCursor,
      status: statusFilter,
      assignedFilter: assignedFilter,
      technicianId: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );

    if (result.isErr) {
      state = state.copyWith(isLoadingMore: false, error: result.error);
      return;
    }

    state = state.copyWith(
      items: [...state.items, ...result.data.items],
      nextCursor: result.data.nextCursor,
      hasMore: result.data.hasMore,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoadingMore: false, hasMore: true, nextCursor: null, error: null);
    await _loadInitial();
  }
}

const _assignmentsPageSize = 50;

@freezed
class AssignableJobsState with _$AssignableJobsState {
  const factory AssignableJobsState({
    @Default([]) List<ClaimSummary> items,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? nextCursor,
    DomainError? error,
  }) = _AssignableJobsState;

  const AssignableJobsState._();
}
```

**Alternative: Simpler provider (no state class):**

```dart
@riverpod
Future<List<ClaimSummary>> assignableJobs(
  Ref ref, {
  ClaimStatus? statusFilter,
  bool? assignedFilter,
  String? technicianIdFilter,
  DateTime? dateFrom,
  DateTime? dateTo,
}) async {
  final repository = ref.read(assignmentsRepositoryProvider);
  final result = await repository.fetchAssignableJobsPage(
    pageSize: 50,
    status: statusFilter,
    assignedFilter: assignedFilter,
    technicianId: technicianIdFilter,
    dateFrom: dateFrom,
    dateTo: dateTo,
  );

  if (result.isErr) {
    throw result.error;
  }

  return result.data.items;
}
```

**Design decision:** Use state class pattern (same as Claims Queue) for pagination support. Simpler provider if pagination not needed initially.

**Error handling:**
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate
- UI shows error state with retry button

**Refresh pattern:**
```dart
// In UI
ref.invalidate(assignableJobsControllerProvider(
  statusFilter: _statusFilter,
  assignedFilter: _assignedFilter,
  technicianIdFilter: _technicianFilter,
  dateFrom: _dateFrom,
  dateTo: _dateTo,
));
```

**Write operations (unchanged):**
- `assignTechnician()` - Reuse existing `AssignmentController` (no changes needed)
- Uses `ClaimRepository.updateTechnician()` and `ClaimRepository.updateAppointment()` ✅

---

## 6. UI Integration Notes

### Assignment Screen (`assignment_screen.dart`)

**Current implementation:**
- Uses `assignableJobsProvider` (returns `List<ClaimSummary>`)
- Filters: status, assigned/unassigned, technician, date range
- Shows list of jobs with assignment cards
- N+1 queries: For each job, fetches full `Claim` object to get `appointmentDate`, `appointmentTime`

**Integration points:**

1. **Replace provider:**
   ```dart
   // OLD
   final jobsAsync = ref.watch(assignableJobsProvider(
     statusFilter: _statusFilter,
     assignedFilter: _assignedFilter,
     technicianIdFilter: _technicianFilter,
     dateFrom: _dateFrom,
     dateTo: _dateTo,
   ));

   // NEW (with pagination)
   final jobsState = ref.watch(assignableJobsControllerProvider(
     statusFilter: _statusFilter,
     assignedFilter: _assignedFilter,
     technicianIdFilter: _technicianFilter,
     dateFrom: _dateFrom,
     dateTo: _dateTo,
   ));
   ```

2. **Remove N+1 queries:**
   ```dart
   // OLD: Fetches full Claim for each job
   return FutureBuilder<Claim?>(
     future: ref.read(claimRepositoryProvider).fetchById(job.claimId).then((r) => r.isOk ? r.data : null),
     builder: (context, snapshot) {
       final claim = snapshot.data;
       final appointmentDate = claim?.appointmentDate;
       final appointmentTime = claim?.appointmentTime;
       // ...
     },
   );

   // NEW: Use ClaimSummary fields directly (if available in view)
   // Note: v_claims_list may not have appointment_date/appointment_time
   // If needed, add to view or fetch only when dialog opens
   ```

3. **Pagination (if implemented):**
   - Add infinite scroll (scroll threshold ~200px from bottom)
   - Add pull-to-refresh
   - Show loading indicator for `isLoadingMore`

4. **Appointment data:**
   - If `v_claims_list` doesn't have `appointment_date`/`appointment_time`, fetch only when dialog opens (not for each card)
   - Or: Add appointment fields to `v_claims_list` view (schema change, but minimal)

**Note:** Check if `v_claims_list` includes `appointment_date` and `appointment_time`. If not, fetch only when assignment dialog opens (not for each card).

---

## 7. Migration Checklist

### Files to Create

- [ ] `lib/domain/repositories/assignments_repository.dart` - Interface
- [ ] `lib/data/datasources/assignments_remote_data_source.dart` - Data source interface
- [ ] `lib/data/datasources/supabase_assignments_remote_data_source.dart` - Supabase implementation
- [ ] `lib/data/repositories/assignments_repository_supabase.dart` - Repository implementation

### Files to Update

- [ ] `lib/features/assignments/controller/assignment_controller.dart` - Replace `assignableJobs()` provider
- [ ] `lib/features/assignments/presentation/assignment_screen.dart` - Remove N+1 queries, add pagination UI (if needed)

### Files to Remove/Deprecate

- [ ] None (no old repository to deprecate)

### Migration Steps

1. **Create repository interface:**
   - Define `AssignmentsRepository` with `fetchAssignableJobsPage()` method
   - Reuse `PaginatedResult<ClaimSummary>` (same as Claims Queue)

2. **Create data source:**
   - Implement `SupabaseAssignmentsRemoteDataSource` with server-side filters
   - Use `v_claims_list` view for minimal payload
   - Implement cursor-based pagination (same pattern as Claims Queue)
   - Apply all filters server-side (status, assigned/unassigned, technician, date range)

3. **Create repository implementation:**
   - Map data source rows to `ClaimSummary` domain models
   - Return `PaginatedResult<ClaimSummary>`

4. **Update controller:**
   - Replace `assignableJobs()` provider with `AssignableJobsController` (state class pattern)
   - Remove N+1 queries (no more `fetchById()` calls in loop)
   - Remove client-side filtering (all done server-side)
   - Update error handling (throw errors, don't return empty list)

5. **Update UI:**
   - Replace provider usage in `assignment_screen.dart`
   - Remove N+1 queries (don't fetch full `Claim` for each card)
   - Add pagination UI (infinite scroll, pull-to-refresh) if needed
   - Fetch appointment data only when dialog opens (if not in view)

6. **Remove old code:**
   - Delete `fetchQueue()` call from controller
   - Delete N+1 query loop
   - Delete client-side filtering logic

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Single query for all claims + N+1 queries for filtering
final queueResult = await claimRepository.fetchQueue(status: statusFilter);
var claims = queueResult.data;

// Filter by assignment status (N+1 queries)
if (assignedFilter != null) {
  final filteredClaims = <ClaimSummary>[];
  for (final claimSummary in claims) {
    final claimResult = await claimRepository.fetchById(claimSummary.claimId); // N+1!
    if (claimResult.isOk) {
      final claim = claimResult.data;
      final isAssigned = claim.technicianId != null;
      if (assignedFilter == isAssigned) {
        filteredClaims.add(claimSummary);
      }
    }
  }
  claims = filteredClaims;
}

// Filter by technician (N+1 queries)
if (technicianIdFilter != null) {
  // ... more N+1 queries
}

// Filter by date range (N+1 queries)
if (dateFrom != null || dateTo != null) {
  // ... more N+1 queries
}

return claims;
```

**After:**
```dart
// NEW: Single query with server-side filters (no N+1)
final repository = ref.read(assignmentsRepositoryProvider);
final result = await repository.fetchAssignableJobsPage(
  pageSize: 50,
  status: statusFilter,
  assignedFilter: assignedFilter,
  technicianId: technicianIdFilter,
  dateFrom: dateFrom,
  dateTo: dateTo,
);

if (result.isErr) {
  throw result.error; // Proper error handling
}

return result.data.items; // Paginated results
```

### Safe Rollout Steps

1. **Phase 1: Create new repository layer**
   - Create interfaces and implementations
   - Write unit tests
   - Verify queries return correct data structure
   - Verify server-side filters work correctly

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository
   - Keep old code commented (for rollback)
   - Test with small dataset

3. **Phase 3: Verify**
   - Manual test: Load assignments with no filters
   - Manual test: Load assignments with status filter
   - Manual test: Load assignments with assigned/unassigned filter
   - Manual test: Load assignments with technician filter
   - Manual test: Load assignments with date range filter
   - Manual test: Verify assignment dialog works
   - Performance test: Compare old vs. new (should be much faster, no N+1)

4. **Phase 4: Cleanup**
   - Remove old `fetchQueue()` call
   - Remove N+1 query loops
   - Remove client-side filtering logic
   - Remove commented code

---

## 8. Performance Considerations

### Query Performance

- **Before:** 1 query for all claims (1000 max) + N queries for full claims (N+1 pattern)
- **After:** 1 query with server-side filters (no N+1)
- **Improvement:** Significant (1 query vs. N+1 queries)

### Data Transfer

- **Before:** 1000 `ClaimSummary` objects + N full `Claim` objects (large payload)
- **After:** 50-100 `ClaimSummary` objects per page (minimal payload)
- **Improvement:** ~90% reduction in data transfer

### Server-side Filters

- **Before:** Fetch all claims, filter client-side (inefficient)
- **After:** Filter server-side (efficient, uses indexes)
- **Index usage:** `claims_technician_appointment_idx` supports technician + date filtering

---

## 9. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- All queries use `.limit(limit.clamp(1, 100))` (hard max of 100)
- Cursor-based pagination prevents loading all data at once
- Warning logged if result length == limit (may be truncated)

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Errors thrown (not swallowed)
- Errors surface to UI via `AsyncError`
- No empty list returned on error

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `AssignmentsRepository`
- Repository calls `AssignmentsRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/controllers

### No N+1 Queries

✅ **Enforced:**
- Server-side filters eliminate N+1 pattern
- Single query with all filters (no loops calling `fetchById()`)
- Appointment data fetched only when dialog opens (if not in view)

---

## 10. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchAssignableJobsPage()` - First page (no cursor)
- [ ] `fetchAssignableJobsPage()` - Next page (with cursor)
- [ ] `fetchAssignableJobsPage()` - Status filter
- [ ] `fetchAssignableJobsPage()` - Assigned filter (technician_id IS NOT NULL)
- [ ] `fetchAssignableJobsPage()` - Unassigned filter (technician_id IS NULL)
- [ ] `fetchAssignableJobsPage()` - Technician filter
- [ ] `fetchAssignableJobsPage()` - Date range filter
- [ ] `fetchAssignableJobsPage()` - Combined filters
- [ ] `fetchAssignableJobsPage()` - Limit enforcement (50 default, 100 max)
- [ ] `fetchAssignableJobsPage()` - Cursor generation (correct format)
- [ ] `fetchAssignableJobsPage()` - Error handling (network error, RLS error)

### Widget Tests (To Be Written)

- [ ] `assignableJobsControllerProvider` - Loading state
- [ ] `assignableJobsControllerProvider` - Data state
- [ ] `assignableJobsControllerProvider` - Error state
- [ ] `assignableJobsControllerProvider` - Pagination (loadMore)
- [ ] `assignableJobsControllerProvider` - Refresh behavior

### Manual Testing

- [ ] Load assignments with no filters (verify all jobs display)
- [ ] Load assignments with status filter (verify filtered jobs)
- [ ] Load assignments with assigned filter (verify only assigned jobs)
- [ ] Load assignments with unassigned filter (verify only unassigned jobs)
- [ ] Load assignments with technician filter (verify filtered jobs)
- [ ] Load assignments with date range filter (verify filtered jobs)
- [ ] Load assignments with combined filters (verify correct results)
- [ ] Verify assignment dialog works (assign/unassign technician)
- [ ] Verify assignment dialog works (set appointment)
- [ ] Performance: Compare old vs. new (should be much faster, no N+1)

---

## 11. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **View usage:** Use `v_claims_list` view for minimal payload (already has required fields)
- **Appointment data:** Check if `v_claims_list` includes `appointment_date`/`appointment_time`. If not, fetch only when dialog opens.
- **Write operations:** Reuse existing `ClaimRepository.updateTechnician()` and `ClaimRepository.updateAppointment()` (no new write methods needed)
- **Pagination:** Cursor-based pagination (same pattern as Claims Queue) - can be added later if needed
- **Future optimizations:**
  - Add appointment fields to `v_claims_list` view (if not present)
  - Add infinite scroll UI (if pagination implemented)
  - Cache assignment state (refresh every 5 minutes)

---

## 12. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Uses deprecated `fetchQueue()` (fetches ALL claims, limited to 1000)
- ❌ N+1 queries: For each claim, fetches full `Claim` object to check filters
- ❌ All filtering done client-side (inefficient)
- ❌ Silent error handling (returns empty list on error)
- ❌ No pagination (loads all claims at once)

**Query count:** 1 + N (where N = number of claims, up to 1000)

### After (Target State)

**Improvements:**
- ✅ Repository pattern (no deprecated methods)
- ✅ Single query with server-side filters (no N+1)
- ✅ Server-side filtering (efficient, uses indexes)
- ✅ Proper error handling (errors propagate to UI)
- ✅ Cursor-based pagination (same pattern as Claims Queue)

**Query count:** 1 (single query with all filters)

**Performance:** 1000x faster for 1000 claims (1 query vs. 1001 queries)

**Data transfer:** ~90% reduction (50-100 objects per page vs. 1000+ objects)

