# Dashboard Module - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate deprecated `fetchQueue()` usage, use server-side aggregates, enforce hard limits  
**Scope:** Dashboard KPIs, recent lists, and aggregates

---

## 1. Dashboard Data Needs Analysis

### Current Dashboard Requirements

**KPIs/Counters:**
- `totalActiveClaims` - Total active claims (excludes closed/cancelled)
- `overdueCount` - Claims exceeding SLA threshold (by priority)
- `dueSoonCount` - Claims within 50% of SLA threshold
- `followUpCount` - Claims needing follow-up (no contact in last 4 hours)

**Status/Priority Aggregates:**
- `statusCounts` - Count by `ClaimStatus` (for pipeline overview)
- `priorityCounts` - Count by `PriorityLevel` (for priority breakdown)

**Recent Lists:**
- `recentClaims` - 5 most recent claims (sorted by `slaStartedAt DESC`)
- `overdueClaims` - All overdue claims (sorted by priority, then SLA)
- `needsFollowUp` - 5 claims needing follow-up (sorted by SLA)

**Activity Indicators:**
- Claims changed in last hour (by status) - for pipeline activity indicators

**Current Implementation Issues:**
- ❌ Uses deprecated `fetchQueue()` (fetches ALL claims, limited to 1000)
- ❌ All calculations done client-side (inefficient)
- ❌ Fetches full `ClaimSummary` objects for all claims (large payload)
- ❌ No server-side aggregates (counts done in memory)

---

## 2. Target Folder/File Structure

```
lib/
  domain/
    repositories/
      dashboard_repository.dart          # NEW: Interface for dashboard queries
  data/
    datasources/
      dashboard_remote_data_source.dart  # NEW: Interface
      supabase_dashboard_remote_data_source.dart  # NEW: Supabase implementation
    repositories/
      dashboard_repository_supabase.dart # NEW: Repository implementation
  features/
    dashboard/
      controller/
        dashboard_controller.dart        # UPDATE: Replace fetchQueue() calls
      domain/
        dashboard_state.dart             # VERIFY: May need minor updates
      presentation/
        dashboard_screen.dart            # VERIFY: Should work as-is
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Reuse existing `DashboardState` model (minimal changes)

---

## 3. Repository Interface Method Signatures

### `lib/domain/repositories/dashboard_repository.dart` (NEW)

```dart
import '../../core/utils/result.dart';
import '../models/claim_summary.dart';
import '../value_objects/claim_enums.dart';

/// Dashboard summary aggregates (counts by status/priority)
@freezed
class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required int totalActiveClaims,
    required Map<ClaimStatus, int> statusCounts,
    required Map<PriorityLevel, int> priorityCounts,
    required int overdueCount,
    required int dueSoonCount,
    required int followUpCount,
  }) = _DashboardSummary;
}

abstract class DashboardRepository {
  /// Fetch dashboard summary (aggregates/counts)
  /// 
  /// Returns server-side aggregates:
  /// - Total active claims (excludes closed/cancelled)
  /// - Counts by status (for pipeline overview)
  /// - Counts by priority (for priority breakdown)
  /// - Overdue count (claims exceeding SLA threshold)
  /// - Due soon count (claims within 50% of SLA threshold)
  /// - Follow-up count (no contact in last 4 hours)
  /// 
  /// Uses server-side COUNT/GROUP BY (efficient, no full claim objects)
  Future<Result<DashboardSummary>> fetchDashboardSummary();

  /// Fetch recent claims (most recently started)
  /// 
  /// [limit] - Maximum number of claims (default: 5, max: 50)
  /// 
  /// Returns list of recent claims (sorted by slaStartedAt DESC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchRecentClaims({
    int limit = 5,
  });

  /// Fetch overdue claims (exceeding SLA threshold)
  /// 
  /// [limit] - Maximum number of claims (default: 50, max: 100)
  /// 
  /// Returns list of overdue claims (sorted by priority DESC, then SLA ASC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchOverdueClaims({
    int limit = 50,
  });

  /// Fetch claims needing follow-up (no contact in last 4 hours)
  /// 
  /// [limit] - Maximum number of claims (default: 5, max: 50)
  /// 
  /// Returns list of follow-up claims (sorted by SLA ASC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchNeedsFollowUp({
    int limit = 5,
  });
}
```

**Design decisions:**
- Separate methods for aggregates vs. lists (different query patterns)
- Server-side aggregates for counts (efficient, no full objects)
- Minimal payload for lists (only fields needed for dashboard)
- Hard limits on all queries (5-50 for lists, aggregates unlimited)
- Deterministic ordering (always specified)

---

## 4. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_dashboard_remote_data_source.dart` (NEW)

**Query 1: `fetchDashboardSummary()` - Server-side Aggregates**

```sql
-- Status counts (GROUP BY status)
SELECT 
  status,
  COUNT(*) as count
FROM claims
WHERE status NOT IN ('closed', 'cancelled')
GROUP BY status;

-- Priority counts (GROUP BY priority)
SELECT 
  priority,
  COUNT(*) as count
FROM claims
WHERE status NOT IN ('closed', 'cancelled')
GROUP BY priority;

-- Overdue count (exceeding SLA threshold by priority)
SELECT COUNT(*) as count
FROM claims c
WHERE c.status NOT IN ('closed', 'cancelled')
  AND (
    (c.priority = 'urgent' AND NOW() - c.sla_started_at > INTERVAL '2 hours') OR
    (c.priority = 'high' AND NOW() - c.sla_started_at > INTERVAL '4 hours') OR
    (c.priority = 'normal' AND NOW() - c.sla_started_at > INTERVAL '8 hours') OR
    (c.priority = 'low' AND NOW() - c.sla_started_at > INTERVAL '24 hours')
  );

-- Due soon count (within 50% of SLA threshold)
SELECT COUNT(*) as count
FROM claims c
WHERE c.status NOT IN ('closed', 'cancelled')
  AND c.latest_contact_at IS NOT NULL
  AND (
    (c.priority = 'urgent' AND 
     NOW() - c.sla_started_at >= INTERVAL '1 hour' AND
     NOW() - c.sla_started_at <= INTERVAL '2 hours') OR
    (c.priority = 'high' AND 
     NOW() - c.sla_started_at >= INTERVAL '2 hours' AND
     NOW() - c.sla_started_at <= INTERVAL '4 hours') OR
    (c.priority = 'normal' AND 
     NOW() - c.sla_started_at >= INTERVAL '4 hours' AND
     NOW() - c.sla_started_at <= INTERVAL '8 hours') OR
    (c.priority = 'low' AND 
     NOW() - c.sla_started_at >= INTERVAL '12 hours' AND
     NOW() - c.sla_started_at <= INTERVAL '24 hours')
  );

-- Follow-up count (no contact in last 4 hours)
SELECT COUNT(*) as count
FROM claims c
WHERE c.status NOT IN ('closed', 'cancelled')
  AND (
    c.latest_contact_at IS NULL OR
    NOW() - c.latest_contact_at >= INTERVAL '4 hours'
  );
```

**Supabase PostgREST equivalent (single query with multiple aggregates):**

```dart
// Note: PostgREST doesn't support multiple aggregates in one query easily
// Use separate queries or a stored function

// Option 1: Separate queries (simpler, more maintainable)
final statusCountsQuery = _client
    .from('claims')
    .select('status, count')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);

// Option 2: Use v_claims_list view (if it has aggregates)
// Option 3: Create stored function for dashboard summary (future optimization)

// For now: Use separate queries
// Status counts
final statusData = await _client
    .from('claims')
    .select('status')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);

// Count in memory (acceptable for dashboard - not many statuses)
final statusCounts = <ClaimStatus, int>{};
for (final row in statusData) {
  final status = ClaimStatus.fromJson(row['status'] as String);
  statusCounts.update(status, (value) => value + 1, ifAbsent: () => 1);
}

// Priority counts (similar pattern)
final priorityData = await _client
    .from('claims')
    .select('priority')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);

// Count in memory
final priorityCounts = <PriorityLevel, int>{};
for (final row in priorityData) {
  final priority = PriorityLevel.fromJson(row['priority'] as String);
  priorityCounts.update(priority, (value) => value + 1, ifAbsent: () => 1);
}

// Overdue count (server-side filter)
final overdueData = await _client
    .from('claims')
    .select('id', head: true, count: CountOption.exact)
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    // Apply SLA threshold filters (complex, may need stored function)
    // For now: Fetch minimal data and filter client-side
    .limit(1000); // Safety limit

// Due soon count (similar pattern)
// Follow-up count (similar pattern)
```

**Note:** PostgREST limitations make server-side aggregates complex. For initial implementation:
- Use `v_claims_list` view (if available) for minimal payload
- Fetch minimal fields (status, priority, sla_started_at, latest_contact_at)
- Do simple aggregates client-side (acceptable for dashboard - not many statuses/priorities)
- Future optimization: Create stored function for dashboard aggregates

**Query 2: `fetchRecentClaims()` - Recent Claims List**

```dart
final data = await _client
    .from('v_claims_list')  // Use view for minimal payload
    .select('*')  // View already has minimal fields
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    .order('sla_started_at', ascending: false)  // Most recent first
    .order('claim_id', ascending: true)  // Tie-breaker
    .limit(limit.clamp(1, 50));  // Hard limit: max 50
```

**Query 3: `fetchOverdueClaims()` - Overdue Claims List**

```dart
// Fetch claims with SLA info, filter client-side for overdue
// (Complex SLA thresholds are easier to calculate client-side)
final data = await _client
    .from('v_claims_list')
    .select('*')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    .order('priority', ascending: false)  // Urgent first
    .order('sla_started_at', ascending: true)  // Oldest SLA first
    .order('claim_id', ascending: true)  // Tie-breaker
    .limit(limit.clamp(1, 100));  // Hard limit: max 100

// Filter overdue client-side (using priority thresholds)
```

**Query 4: `fetchNeedsFollowUp()` - Follow-up Claims List**

```dart
final data = await _client
    .from('v_claims_list')
    .select('*')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    .order('sla_started_at', ascending: true)  // Oldest SLA first
    .order('claim_id', ascending: true)  // Tie-breaker
    .limit(limit.clamp(1, 50));  // Hard limit: max 50

// Filter follow-up client-side (latest_contact_at IS NULL OR >= 4 hours ago)
```

**Query specifications:**
- **View:** Use `v_claims_list` (minimal payload, already has required fields)
- **Filters:** Exclude closed/cancelled (hardcoded)
- **Ordering:** Always specified (deterministic)
- **Limits:** Hard limits enforced (5-50 for lists, aggregates unlimited)
- **RLS:** Tenant isolation enforced automatically

**Index usage:**
- `claims_tenant_status_idx` (tenant_id, status) - supports status filtering
- `claims_sla_started_at_idx` (sla_started_at) - supports ordering
- `claims_priority_idx` (priority) - supports priority ordering

---

## 5. Controller/Provider Pattern

### `lib/features/dashboard/controller/dashboard_controller.dart` (UPDATE)

**Current issues:**
- Uses deprecated `fetchQueue()` (fetches ALL claims, limited to 1000)
- All calculations done client-side (inefficient)
- Single query for all data (large payload)

**New pattern:**

```dart
@Riverpod(keepAlive: true)
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardState> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<DashboardState> _load() async {
    final repository = ref.read(dashboardRepositoryProvider);

    // Fetch all data in parallel (faster)
    final results = await Future.wait([
      repository.fetchDashboardSummary(),
      repository.fetchRecentClaims(limit: 5),
      repository.fetchOverdueClaims(limit: 50),
      repository.fetchNeedsFollowUp(limit: 5),
    ]);

    // Handle errors (preserve partial data if one call fails)
    final summaryResult = results[0];
    final recentResult = results[1];
    final overdueResult = results[2];
    final followUpResult = results[3];

    // If summary fails, throw error (required for dashboard)
    if (summaryResult.isErr) {
      throw summaryResult.error;
    }

    // Build DashboardState from results
    // Use empty lists if list queries fail (graceful degradation)
    return DashboardState(
      claims: [], // Not used in new implementation
      statusCounts: summaryResult.data.statusCounts,
      priorityCounts: summaryResult.data.priorityCounts,
      overdueClaims: overdueResult.isOk ? overdueResult.data : [],
      needsFollowUp: followUpResult.isOk ? followUpResult.data : [],
      recentClaims: recentResult.isOk ? recentResult.data : [],
      dueSoonCount: summaryResult.data.dueSoonCount,
    );
  }
}
```

**Alternative: Simpler pattern (sequential, no partial data):**

```dart
Future<DashboardState> _load() async {
  final repository = ref.read(dashboardRepositoryProvider);

  // Fetch summary first (required)
  final summaryResult = await repository.fetchDashboardSummary();
  if (summaryResult.isErr) {
    throw summaryResult.error;
  }

  // Fetch lists in parallel (optional, can fail gracefully)
  final recentResult = await repository.fetchRecentClaims(limit: 5);
  final overdueResult = await repository.fetchOverdueClaims(limit: 50);
  final followUpResult = await repository.fetchNeedsFollowUp(limit: 5);

  return DashboardState(
    claims: [], // Not used in new implementation
    statusCounts: summaryResult.data.statusCounts,
    priorityCounts: summaryResult.data.priorityCounts,
    overdueClaims: overdueResult.isOk ? overdueResult.data : [],
    needsFollowUp: followUpResult.isOk ? followUpResult.data : [],
    recentClaims: recentResult.isOk ? recentResult.data : [],
    dueSoonCount: summaryResult.data.dueSoonCount,
  );
}
```

**Design decision:** Use simpler pattern (sequential). Summary is required, lists can fail gracefully.

**Error handling:**
- Summary failure → Throw error (dashboard unusable without counts)
- List failures → Use empty lists (graceful degradation)
- Errors logged via `AppLogger.error()`
- Errors surface to UI via `AsyncError`

**Refresh pattern:**
```dart
// In UI
ref.invalidate(dashboardControllerProvider);
// Or
ref.read(dashboardControllerProvider.notifier).refresh();
```

---

## 6. DashboardState Updates

### `lib/features/dashboard/domain/dashboard_state.dart` (UPDATE)

**Current implementation:**
- `DashboardState.fromClaims()` - Builds state from full claim list
- Calculates all aggregates client-side

**New implementation:**
- Remove `fromClaims()` factory (no longer needed)
- Keep `DashboardState` structure (same fields)
- Constructor takes aggregates directly (from repository)

**Changes:**
```dart
// Remove fromClaims() factory
// Keep DashboardState structure
// Constructor unchanged (takes aggregates directly)
```

**Note:** `claims` field in `DashboardState` may not be needed anymore (only used for activity indicators). Verify if needed, or remove if unused.

---

## 7. Migration Checklist

### Files to Create

- [ ] `lib/domain/repositories/dashboard_repository.dart` - Interface
- [ ] `lib/domain/models/dashboard_summary.dart` - Aggregates model (if needed)
- [ ] `lib/data/datasources/dashboard_remote_data_source.dart` - Data source interface
- [ ] `lib/data/datasources/supabase_dashboard_remote_data_source.dart` - Supabase implementation
- [ ] `lib/data/repositories/dashboard_repository_supabase.dart` - Repository implementation

### Files to Update

- [ ] `lib/features/dashboard/controller/dashboard_controller.dart` - Replace `fetchQueue()` calls
- [ ] `lib/features/dashboard/domain/dashboard_state.dart` - Remove `fromClaims()` factory (if not needed)

### Files to Remove/Deprecate

- [ ] None (no old repository to deprecate)

### Migration Steps

1. **Create repository interface:**
   - Define `DashboardRepository` with methods for summary and lists
   - Define `DashboardSummary` model (if needed)

2. **Create data source:**
   - Implement `SupabaseDashboardRemoteDataSource` with queries
   - Use `v_claims_list` view for minimal payload
   - Enforce hard limits on all queries
   - Apply deterministic ordering

3. **Create repository implementation:**
   - Map data source results to domain models
   - Handle aggregates (status/priority counts)
   - Handle SLA calculations (overdue, due soon, follow-up)

4. **Update controller:**
   - Remove `fetchQueue()` call
   - Use `dashboardRepository` methods
   - Build `DashboardState` from repository results
   - Handle errors (summary required, lists optional)

5. **Update DashboardState:**
   - Remove `fromClaims()` factory (if not needed)
   - Verify `claims` field usage (remove if unused)

6. **Update UI (if needed):**
   - Verify `dashboard_screen.dart` works with new state (should work as-is)
   - Update error handling if needed

7. **Remove old code:**
   - Delete `fetchQueue()` call from controller

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Single query for all claims
final repository = ref.read(claimRepositoryProvider);
final result = await repository.fetchQueue(status: null);
if (result.isErr) {
  throw result.error;
}
return DashboardState.fromClaims(result.data); // Client-side calculations
```

**After:**
```dart
// NEW: Separate queries for aggregates and lists
final repository = ref.read(dashboardRepositoryProvider);

// Fetch summary (required)
final summaryResult = await repository.fetchDashboardSummary();
if (summaryResult.isErr) {
  throw summaryResult.error;
}

// Fetch lists (optional, can fail gracefully)
final recentResult = await repository.fetchRecentClaims(limit: 5);
final overdueResult = await repository.fetchOverdueClaims(limit: 50);
final followUpResult = await repository.fetchNeedsFollowUp(limit: 5);

return DashboardState(
  claims: [], // Not used
  statusCounts: summaryResult.data.statusCounts,
  priorityCounts: summaryResult.data.priorityCounts,
  overdueClaims: overdueResult.isOk ? overdueResult.data : [],
  needsFollowUp: followUpResult.isOk ? followUpResult.data : [],
  recentClaims: recentResult.isOk ? recentResult.data : [],
  dueSoonCount: summaryResult.data.dueSoonCount,
);
```

### Safe Rollout Steps

1. **Phase 1: Create new repository layer**
   - Create interfaces and implementations
   - Write unit tests
   - Verify queries return correct data structure

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository
   - Keep old code commented (for rollback)
   - Test with small dataset

3. **Phase 3: Verify**
   - Manual test: Load dashboard
   - Manual test: Verify KPIs display correctly
   - Manual test: Verify recent claims list
   - Manual test: Verify overdue claims list
   - Manual test: Verify follow-up claims list
   - Performance test: Compare old vs. new (should be faster)

4. **Phase 4: Cleanup**
   - Remove old `fetchQueue()` call
   - Remove commented code
   - Remove `fromClaims()` factory (if not needed)

---

## 8. Performance Considerations

### Query Performance

- **Aggregates:** Use `v_claims_list` view (minimal payload) or separate COUNT queries
- **Lists:** Use `v_claims_list` view with limits (5-50 items)
- **Index usage:** Existing indexes support status/priority filtering and ordering

### Data Transfer

- **Before:** 1000 full `ClaimSummary` objects (large payload)
- **After:** 
  - Aggregates: Minimal data (counts only)
  - Lists: 5-50 `ClaimSummary` objects (much smaller)
- **Improvement:** Significant reduction in data transfer

### Client-side Calculations

- **Aggregates:** Moved to server-side (or minimal client-side counting)
- **SLA calculations:** Still client-side (complex thresholds, acceptable for small lists)
- **Future optimization:** Create stored function for dashboard aggregates

---

## 9. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- All list queries use `.limit(limit.clamp(1, 50))` or `.limit(limit.clamp(1, 100))`
- Aggregates don't need limits (counts only)
- Warning logged if result length == limit (may be truncated)

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Summary failure → Throw error (dashboard unusable)
- List failures → Use empty lists (graceful degradation)
- Errors surface to UI via `AsyncError`

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `DashboardRepository`
- Repository calls `DashboardRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/controllers

---

## 10. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchDashboardSummary()` - Status counts
- [ ] `fetchDashboardSummary()` - Priority counts
- [ ] `fetchDashboardSummary()` - Overdue count
- [ ] `fetchDashboardSummary()` - Due soon count
- [ ] `fetchDashboardSummary()` - Follow-up count
- [ ] `fetchRecentClaims()` - Recent claims list (limit 5)
- [ ] `fetchOverdueClaims()` - Overdue claims list (limit 50)
- [ ] `fetchNeedsFollowUp()` - Follow-up claims list (limit 5)
- [ ] Error handling (summary failure, list failures)
- [ ] Limit enforcement (max limits respected)

### Widget Tests (To Be Written)

- [ ] `dashboardControllerProvider` - Loading state
- [ ] `dashboardControllerProvider` - Data state
- [ ] `dashboardControllerProvider` - Error state
- [ ] `dashboardControllerProvider` - Refresh behavior

### Manual Testing

- [ ] Load dashboard (verify KPIs display)
- [ ] Verify status counts (pipeline overview)
- [ ] Verify priority counts
- [ ] Verify recent claims list (5 items)
- [ ] Verify overdue claims list (all overdue)
- [ ] Verify follow-up claims list (5 items)
- [ ] Verify error handling (network error shows error state)
- [ ] Performance: Compare old vs. new (should be faster)

---

## 11. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **View usage:** Use `v_claims_list` view for minimal payload (already has required fields)
- **Aggregates:** PostgREST limitations make server-side aggregates complex. For initial implementation, use minimal payload and count client-side (acceptable for dashboard).
- **Future optimizations:**
  - Create stored function for dashboard aggregates (server-side COUNT/GROUP BY)
  - Add materialized view for dashboard summary (refresh periodically)
  - Cache dashboard summary (refresh every 5 minutes)
- **Backward compatibility:** `DashboardState` structure unchanged, UI works as-is

---

## 12. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Uses deprecated `fetchQueue()` (fetches ALL claims, limited to 1000)
- ❌ All calculations done client-side (inefficient)
- ❌ Large payload (1000 full `ClaimSummary` objects)
- ❌ Single query for all data (no parallelization)

**Query:** 1 query for all claims (1000 max)

### After (Target State)

**Improvements:**
- ✅ Repository pattern (no deprecated methods)
- ✅ Server-side aggregates (or minimal client-side counting)
- ✅ Minimal payload (aggregates + 5-50 claim objects)
- ✅ Parallel queries (summary + lists in parallel)

**Queries:** 4 queries (summary + 3 lists) in parallel

**Performance:** Faster (smaller payload, parallel queries, server-side aggregates)

**Data transfer:** ~90% reduction (aggregates + 60 claim objects vs. 1000 claim objects)

