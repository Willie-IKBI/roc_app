# Reporting Module - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate hardcoded large limits (limit(10000)), add date range requirements, standardize pagination  
**Scope:** All reporting queries with pagination and date range enforcement

---

## 1. Reporting Screens/Exports and Data Needs

### Current Reporting Requirements

**Report Types:**

1. **Daily Reports** (`fetchDailyReports`)
   - **Data:** Daily aggregates (claims_captured, avg_minutes_to_first_contact, compliant_claims, contacted_claims)
   - **Date Range:** ✅ Required (startDate, endDate)
   - **Current Limit:** 90 days
   - **Expected Max Rows:** ~90 (one per day)
   - **Status:** ✅ Already has date range and limit

2. **Agent Performance Report** (`fetchAgentPerformanceReport`)
   - **Data:** Per-agent aggregates (claims_handled, claims_closed, avg_first_contact, SLA_compliance, resolution_time, contact_success)
   - **Date Range:** ❌ Not required (fetches ALL claims)
   - **Current Limit:** 10000 claims (fallback query)
   - **Expected Max Rows:** ~50-200 (one per agent)
   - **Status:** ⚠️ Needs date range requirement + pagination

3. **Status Distribution Report** (`fetchStatusDistributionReport`)
   - **Data:** Per-status aggregates (count, percentage, avg_time_in_status, stuck_claims)
   - **Date Range:** ❌ Not required (fetches ALL claims)
   - **Current Limit:** 10000 claims (fallback query)
   - **Expected Max Rows:** ~10 (one per status)
   - **Status:** ⚠️ Needs date range requirement + pagination

4. **Damage Cause Report** (`fetchDamageCauseReport`)
   - **Data:** Per-damage_cause aggregates (count, percentage, avg_resolution_time)
   - **Date Range:** ❌ Not required (fetches ALL claims)
   - **Current Limit:** 10000 claims (fallback query)
   - **Expected Max Rows:** ~10-20 (one per damage cause)
   - **Status:** ⚠️ Needs date range requirement + pagination

5. **Geographic Report** (`fetchGeographicReport`)
   - **Data:** Per-location aggregates (province/city/suburb, claim_count, percentage, avg_coordinates)
   - **Date Range:** ❌ Not required (fetches ALL claims)
   - **Current Limit:** 10000 claims (fallback query)
   - **Expected Max Rows:** ~50-200 (one per location)
   - **Status:** ⚠️ Needs date range requirement + pagination

6. **Insurer Performance Report** (`fetchInsurerPerformanceReport`)
   - **Data:** Per-insurer aggregates (total_claims, closed_claims, status_breakdown, damage_cause_breakdown, avg_resolution_time)
   - **Date Range:** ❌ Not required (fetches ALL claims)
   - **Current Limit:** 1000 insurers (with nested claims)
   - **Expected Max Rows:** ~20-100 (one per insurer)
   - **Status:** ⚠️ Needs date range requirement + pagination

7. **Insurer Damage Cause Breakdown** (`fetchInsurerDamageCauseBreakdown`)
   - **Data:** Per-insurer + damage_cause aggregates
   - **Date Range:** ❌ Not required
   - **Current Limit:** 1000 insurers (with nested claims)
   - **Expected Max Rows:** ~100-500 (insurer × damage_cause combinations)
   - **Status:** ⚠️ Needs date range requirement + pagination

8. **Insurer Status Breakdown** (`fetchInsurerStatusBreakdown`)
   - **Data:** Per-insurer + status aggregates
   - **Date Range:** ❌ Not required
   - **Current Limit:** 1000 insurers (with nested claims)
   - **Expected Max Rows:** ~100-500 (insurer × status combinations)
   - **Status:** ⚠️ Needs date range requirement + pagination

**Current Implementation Issues:**
- ❌ Hardcoded `.limit(10000)` in fallback queries (lines 78, 98, 213, 282, 356)
- ❌ No date range requirements for most reports (could exceed 500 rows)
- ❌ No pagination (all data fetched at once)
- ❌ Direct Supabase calls in some UI widgets (e.g., `insurer_performance_report.dart`)
- ✅ Daily reports already have date range and limit (90 days)

---

## 2. Target Folder/File Structure

```
lib/
  domain/
    repositories/
      reporting_repository.dart          # UPDATE: Add pagination + date range params
  data/
    datasources/
      reporting_remote_data_source.dart  # UPDATE: Add pagination + date range params
      supabase_reporting_remote_data_source.dart  # UPDATE: Replace limit(10000) with pagination
    repositories/
      reporting_repository_supabase.dart # UPDATE: Add pagination support
  features/
    reporting/
      controller/
        reporting_controller.dart        # UPDATE: Add date range UI + pagination state
      presentation/
        reporting_screen.dart            # UPDATE: Add date range picker
        widgets/
          *.dart                         # UPDATE: Remove direct Supabase calls
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Reuse existing reporting models (minimal changes)

---

## 3. Repository Interface Method Signatures

### `lib/domain/repositories/reporting_repository.dart` (UPDATE)

```dart
import '../../core/utils/result.dart';
import '../models/daily_claim_report.dart';
import '../models/paginated_result.dart';
import '../models/report_models.dart';

/// Report type enum
enum ReportType {
  daily,
  agentPerformance,
  statusDistribution,
  damageCause,
  geographic,
  insurerPerformance,
  insurerDamageCauseBreakdown,
  insurerStatusBreakdown,
}

/// Report filters
@freezed
class ReportFilters with _$ReportFilters {
  const factory ReportFilters({
    required DateTime startDate,  // Required for all reports
    required DateTime endDate,    // Required for all reports
    String? groupBy,              // For geographic report (province/city/suburb)
  }) = _ReportFilters;
}

abstract class ReportingRepository {
  /// Fetch paginated report data
  /// 
  /// [reportType] - Type of report to fetch
  /// [filters] - Date range (required) + optional filters
  /// [cursor] - Optional cursor for pagination (format: "claim_id" or "insurer_id|damage_cause" etc.)
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  /// 
  /// Date range is REQUIRED for all reports (prevents unbounded queries).
  /// Reports that could exceed 500 rows MUST use pagination.
  Future<Result<PaginatedResult<ReportRow>>> fetchReportPage({
    required ReportType reportType,
    required ReportFilters filters,
    String? cursor,
    int limit = 100,
  });

  /// Fetch daily reports (aggregated by date)
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [limit] - Maximum number of days (default: 90, max: 365)
  /// 
  /// Returns list of daily reports (one per day)
  /// 
  /// Note: Daily reports are small (one row per day), so no pagination needed.
  /// But date range is still required.
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 90,
  });
}
```

**Design decisions:**
- Single method `fetchReportPage()` - handles all report types with pagination
- Date range REQUIRED for all reports (prevents unbounded queries)
- Cursor-based pagination (same pattern as Claims Queue)
- Hard limit: 100 default, 500 max per page
- `fetchDailyReports()` - Separate method (small dataset, no pagination needed, but date range required)

**Report row types:**
- Use union type or base class for `ReportRow` (or return `dynamic` and cast in repository)
- Or: Separate methods per report type (simpler, more type-safe)

**Alternative: Separate methods per report type (more type-safe):**

```dart
abstract class ReportingRepository {
  // Daily reports (small, no pagination)
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 90,
  });

  // Agent performance (paginated)
  Future<Result<PaginatedResult<AgentPerformanceReport>>> fetchAgentPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  // Status distribution (paginated)
  Future<Result<PaginatedResult<StatusDistributionReport>>> fetchStatusDistributionReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  // Damage cause (paginated)
  Future<Result<PaginatedResult<DamageCauseReport>>> fetchDamageCauseReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  // Geographic (paginated)
  Future<Result<PaginatedResult<GeographicReport>>> fetchGeographicReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? groupBy,  // province/city/suburb
    String? cursor,
    int limit = 100,
  });

  // Insurer performance (paginated)
  Future<Result<PaginatedResult<InsurerPerformanceReport>>> fetchInsurerPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });
}
```

**Design decision:** Use separate methods per report type (more type-safe, clearer API).

---

## 4. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_reporting_remote_data_source.dart` (UPDATE)

**Query Pattern: Replace `limit(10000)` with pagination + date range**

**Example: Agent Performance Report (paginated)**

```dart
// OLD: Unbounded query
final claimsResponse = await _client
    .from('claims')
    .select('id, agent_id, sla_started_at, status, closed_at')
    .not('agent_id', 'is', null)
    .limit(10000);  // ❌ Hardcoded large limit

// NEW: Paginated with date range
final pageSize = limit.clamp(1, 500);
final startDateStr = startDate.toIso8601String();
final endDateStr = endDate.toIso8601String();

var query = _client
    .from('claims')
    .select('id, agent_id, sla_started_at, status, closed_at')
    .not('agent_id', 'is', null)
    .gte('created_at', startDateStr)  // Date range required
    .lte('created_at', endDateStr);    // Date range required

// Apply cursor for pagination
if (cursor != null && cursor.isNotEmpty) {
  query = query.gt('id', cursor).order('id', ascending: true);
} else {
  query = query.order('id', ascending: true);
}

// Fetch limit + 1 to detect if more data exists
final data = await query.limit(pageSize + 1);

// Check if we have more data
final hasMore = data.length > pageSize;
final items = hasMore ? data.take(pageSize).toList() : data;

// Generate next cursor from last item
String? nextCursor;
if (hasMore && items.isNotEmpty) {
  final lastItem = items.last;
  nextCursor = lastItem['id'] as String;
}

// Aggregate by agent (client-side, same as current)
// ... aggregation logic ...

return Result.ok(PaginatedResult(
  items: aggregatedRows,
  nextCursor: nextCursor,
  hasMore: hasMore,
));
```

**Query specifications for all reports:**

1. **Agent Performance Report:**
   - **Table:** `claims` (with joins to `contact_attempts`, `profiles`)
   - **Filters:** `agent_id IS NOT NULL`, `created_at BETWEEN startDate AND endDate` (required)
   - **Ordering:** `id ASC` (deterministic cursor)
   - **Limit:** `limit.clamp(1, 500)` (hard max of 500)
   - **Pagination:** Cursor-based (using `claim_id`)

2. **Status Distribution Report:**
   - **Table:** `claims`
   - **Filters:** `created_at BETWEEN startDate AND endDate` (required)
   - **Ordering:** `id ASC` (deterministic cursor)
   - **Limit:** `limit.clamp(1, 500)`
   - **Pagination:** Cursor-based (using `claim_id`)

3. **Damage Cause Report:**
   - **Table:** `claims`
   - **Filters:** `created_at BETWEEN startDate AND endDate` (required)
   - **Ordering:** `id ASC` (deterministic cursor)
   - **Limit:** `limit.clamp(1, 500)`
   - **Pagination:** Cursor-based (using `claim_id`)

4. **Geographic Report:**
   - **Table:** `claims` (with join to `addresses`)
   - **Filters:** `created_at BETWEEN startDate AND endDate` (required)
   - **Ordering:** `id ASC` (deterministic cursor)
   - **Limit:** `limit.clamp(1, 500)`
   - **Pagination:** Cursor-based (using `claim_id`)

5. **Insurer Performance Report:**
   - **Table:** `insurers` (with nested `claims`)
   - **Filters:** `claims.created_at BETWEEN startDate AND endDate` (required)
   - **Ordering:** `insurer_id ASC` (deterministic cursor)
   - **Limit:** `limit.clamp(1, 500)` (for insurers, not claims)
   - **Pagination:** Cursor-based (using `insurer_id`)

6. **Daily Reports:**
   - **View:** `v_claims_reporting`
   - **Filters:** `claim_date BETWEEN startDate AND endDate` (required)
   - **Ordering:** `claim_date DESC`
   - **Limit:** `limit.clamp(1, 365)` (max 1 year)
   - **Pagination:** None (small dataset, one row per day)

**Query specifications:**
- **Date range:** REQUIRED for all reports (prevents unbounded queries)
- **Ordering:** Always specified (deterministic cursor)
- **Limits:** Hard limits enforced (100 default, 500 max for paginated reports, 90-365 for daily)
- **RLS:** Tenant isolation enforced automatically

**Index usage:**
- `claims_tenant_status_idx` (tenant_id, status) - supports status filtering
- `claims_created_at_idx` (created_at) - supports date range filtering
- `claims_agent_idx` (tenant_id, agent_id) - supports agent filtering

---

## 5. Controller/Provider Pattern

### `lib/features/reporting/controller/reporting_controller.dart` (UPDATE)

**Current issues:**
- No date range UI (only window presets: last7, last14, last30)
- No pagination support
- Direct Supabase calls in some widgets

**New pattern:**

```dart
@riverpod
class ReportingController extends _$ReportingController {
  @override
  Future<ReportingState> build() async {
    final window = ref.watch(reportingWindowControllerProvider);
    return _load(window);
  }

  Future<void> changeWindow(ReportingWindow window) async {
    state = const AsyncLoading();
    ref.read(reportingWindowControllerProvider.notifier).setWindow(window);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final window = ref.read(reportingWindowControllerProvider);
    state = await AsyncValue.guard(() => _load(window));
  }

  Future<ReportingState> _load(ReportingWindow window) async {
    final repository = ref.read(reportingRepositoryProvider);
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: window.days - 1));
    final endDate = today.add(const Duration(days: 1));
    
    // Date range is now required (enforced in repository)
    final result = await repository.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
      limit: 90,
    );
    
    if (result.isErr) {
      throw result.error;
    }
    
    final reports = result.data;
    return _aggregate(reports, window);
  }
}
```

**New providers for paginated reports:**

```dart
@riverpod
class AgentPerformanceReportController extends _$AgentPerformanceReportController {
  @override
  ReportPageState build({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    _loadInitial();
    return const ReportPageState();
  }

  Future<void> _loadInitial() async {
    state = const ReportPageState();
    final repository = ref.read(reportingRepositoryProvider);
    final result = await repository.fetchAgentPerformanceReportPage(
      startDate: startDate,
      endDate: endDate,
      limit: 100,
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
    // ... pagination logic
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoadingMore: false, hasMore: true, nextCursor: null, error: null);
    await _loadInitial();
  }
}

@freezed
class ReportPageState with _$ReportPageState {
  const factory ReportPageState({
    @Default([]) List<ReportRow> items,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    String? nextCursor,
    DomainError? error,
  }) = _ReportPageState;
}
```

**Error handling:**
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate
- UI shows error state with retry button

---

## 6. UI Integration Notes

### Reporting Screen (`reporting_screen.dart`)

**Current implementation:**
- Uses window presets (last7, last14, last30)
- No custom date range picker
- No pagination UI

**Integration points:**

1. **Add date range picker:**
   - Add start/end date inputs
   - Default to window presets (last7, last14, last30)
   - Allow custom date range selection
   - Enforce max range (e.g., 1 year)

2. **Add pagination UI (for large reports):**
   - Infinite scroll (scroll threshold ~200px from bottom)
   - Pull-to-refresh
   - Show loading indicator for `isLoadingMore`
   - Show "Load more" button if needed

3. **Remove direct Supabase calls:**
   - Update `insurer_performance_report.dart` to use repository provider
   - Update `agent_performance_report.dart` to use repository provider
   - Remove direct `SupabaseClient` usage

**Widget updates:**
- `insurer_performance_report.dart` - Remove direct repository instantiation, use provider
- `agent_performance_report.dart` - Remove direct repository instantiation, use provider
- Other report widgets - Verify no direct Supabase calls

---

## 7. Migration Checklist

### Files to Update

- [ ] `lib/domain/repositories/reporting_repository.dart` - Add date range params + pagination methods
- [ ] `lib/data/datasources/reporting_remote_data_source.dart` - Add date range params + pagination methods
- [ ] `lib/data/datasources/supabase_reporting_remote_data_source.dart` - Replace `limit(10000)` with pagination + date range
- [ ] `lib/data/repositories/reporting_repository_supabase.dart` - Add pagination support
- [ ] `lib/features/reporting/controller/reporting_controller.dart` - Add date range UI support
- [ ] `lib/features/reporting/presentation/reporting_screen.dart` - Add date range picker
- [ ] `lib/features/reporting/presentation/widgets/insurer_performance_report.dart` - Remove direct Supabase calls
- [ ] `lib/features/reporting/presentation/widgets/agent_performance_report.dart` - Remove direct Supabase calls
- [ ] Other report widgets - Verify no direct Supabase calls

### Migration Steps

1. **Update repository interface:**
   - Add date range parameters to all report methods
   - Add pagination methods for large reports
   - Keep `fetchDailyReports()` separate (small dataset)

2. **Update data source:**
   - Replace all `limit(10000)` with pagination logic
   - Add date range filters to all queries
   - Implement cursor-based pagination (same pattern as Claims Queue)
   - Enforce hard limits (100 default, 500 max)

3. **Update repository implementation:**
   - Map data source results to domain models
   - Return `PaginatedResult` for paginated reports
   - Return `List` for daily reports (small dataset)

4. **Update controller:**
   - Add date range state management
   - Add pagination state for large reports
   - Update error handling (throw errors, don't swallow)

5. **Update UI:**
   - Add date range picker to reporting screen
   - Add pagination UI for large reports (infinite scroll or "Load more")
   - Remove direct Supabase calls from widgets
   - Use repository providers instead

6. **Remove old code:**
   - Delete `limit(10000)` queries
   - Delete direct Supabase calls in widgets
   - Delete fallback query methods (or update with pagination)

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Unbounded query with hardcoded limit
final claimsResponse = await _client
    .from('claims')
    .select('id, agent_id, sla_started_at, status, closed_at')
    .not('agent_id', 'is', null)
    .limit(10000);  // ❌ Hardcoded large limit
```

**After:**
```dart
// NEW: Paginated with date range requirement
final result = await repository.fetchAgentPerformanceReportPage(
  startDate: startDate,  // Required
  endDate: endDate,      // Required
  cursor: cursor,
  limit: 100,             // Default, max 500
);

if (result.isErr) {
  throw result.error; // Proper error handling
}

return result.data; // PaginatedResult<AgentPerformanceReport>
```

### Safe Rollout Steps

1. **Phase 1: Update repository layer**
   - Add date range parameters to all methods
   - Replace `limit(10000)` with pagination logic
   - Enforce hard limits (100 default, 500 max)
   - Write unit tests

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository methods
   - Add date range UI (default to window presets)
   - Keep old code commented (for rollback)
   - Test with small date ranges

3. **Phase 3: Verify**
   - Manual test: Load each report type with date range
   - Manual test: Verify pagination works (if needed)
   - Manual test: Verify date range enforcement (error if missing)
   - Performance test: Compare old vs. new (should be faster with date range)

4. **Phase 4: Cleanup**
   - Remove old `limit(10000)` queries
   - Remove direct Supabase calls in widgets
   - Remove commented code

---

## 8. Performance Considerations

### Query Performance

- **Date range filtering:** Reduces query size significantly (from all-time to date range)
- **Pagination:** Prevents loading all data at once (100-500 rows per page)
- **Index usage:** `claims_created_at_idx` supports date range filtering

### Data Transfer

- **Before:** 10000+ rows per report (large payload)
- **After:** 100-500 rows per page (much smaller)
- **Improvement:** ~95% reduction in data transfer (with date range)

### Aggregation Performance

- **Client-side aggregation:** Acceptable for 100-500 rows per page
- **Future optimization:** Move aggregation to server-side (stored functions or views)

---

## 9. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- Date range REQUIRED for all reports (prevents unbounded queries)
- Hard limits: 100 default, 500 max per page
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
- All queries go through `ReportingRepository`
- Repository calls `ReportingRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/widgets

### No Hardcoded Large Limits

✅ **Enforced:**
- No `limit(10000)` anywhere
- All limits are configurable (100 default, 500 max)
- Date range required (prevents need for large limits)

---

## 10. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchAgentPerformanceReportPage()` - First page with date range
- [ ] `fetchAgentPerformanceReportPage()` - Next page (with cursor)
- [ ] `fetchAgentPerformanceReportPage()` - Date range enforcement (error if missing)
- [ ] `fetchStatusDistributionReportPage()` - Pagination
- [ ] `fetchDamageCauseReportPage()` - Pagination
- [ ] `fetchGeographicReportPage()` - Pagination with groupBy
- [ ] `fetchInsurerPerformanceReportPage()` - Pagination
- [ ] `fetchDailyReports()` - Date range enforcement
- [ ] Limit enforcement (100 default, 500 max)
- [ ] Error handling (network error, RLS error, missing date range)

### Widget Tests (To Be Written)

- [ ] Report providers - Loading state
- [ ] Report providers - Data state
- [ ] Report providers - Error state
- [ ] Report providers - Pagination (loadMore)
- [ ] Date range picker - Validation

### Manual Testing

- [ ] Load each report type with date range
- [ ] Verify date range enforcement (error if missing)
- [ ] Verify pagination works (if report exceeds 100 rows)
- [ ] Verify date range picker works
- [ ] Verify window presets work (last7, last14, last30)
- [ ] Verify custom date range works
- [ ] Performance: Compare old vs. new (should be faster with date range)

---

## 11. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **Date range:** REQUIRED for all reports (prevents unbounded queries)
- **Pagination:** Cursor-based (same pattern as Claims Queue)
- **Daily reports:** Small dataset (one row per day), no pagination needed, but date range required
- **Future optimizations:**
  - Move aggregation to server-side (stored functions or views)
  - Add materialized views for common reports (refresh periodically)
  - Cache report results (refresh every 5 minutes)
  - Add CSV export (paged fetch + stream)

---

## 12. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Hardcoded `limit(10000)` in fallback queries
- ❌ No date range requirements (unbounded queries)
- ❌ No pagination (all data fetched at once)
- ❌ Direct Supabase calls in some widgets

**Query:** Unbounded or hardcoded large limits (10000)

### After (Target State)

**Improvements:**
- ✅ Date range REQUIRED for all reports (prevents unbounded queries)
- ✅ Cursor-based pagination (100 default, 500 max per page)
- ✅ No hardcoded large limits
- ✅ All queries through repository (no direct Supabase calls)

**Query:** Paginated with date range (100-500 rows per page)

**Performance:** Faster (date range reduces query size, pagination reduces data transfer)

**Data transfer:** ~95% reduction (100-500 rows per page vs. 10000+ rows)

