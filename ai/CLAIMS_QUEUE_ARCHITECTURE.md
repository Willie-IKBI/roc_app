# Claims Queue / Claims List - Paginated Architecture

**Status:** Build Plan  
**Target:** Add pagination to claims queue, eliminate unbounded queries  
**Scope:** Claims list with server-side pagination, client-side filtering

---

## 1. Folder/File Structure

```
lib/
  domain/
    models/
      paginated_result.dart          # NEW: Generic pagination wrapper
    repositories/
      claim_repository.dart          # UPDATE: Add paginated methods
  data/
    datasources/
      claim_remote_data_source.dart  # UPDATE: Add paginated methods
      supabase_claim_remote_data_source.dart  # UPDATE: Implement pagination
  features/
    claims/
      controller/
        queue_controller.dart        # UPDATE: Replace with paginated controller
```

**Rationale:**
- Reuse existing claim repository/data source structure
- Add generic `PaginatedResult` model for reusability
- Update controller to manage paginated state

---

## 2. Repository Interface Method Signatures

### `lib/domain/repositories/claim_repository.dart` (UPDATE)

```dart
import '../models/claim_summary.dart';
import '../models/paginated_result.dart';
import '../../core/utils/result.dart';
import '../value_objects/claim_enums.dart';

abstract class ClaimRepository {
  // ... existing methods ...

  /// Fetch paginated claims queue
  /// 
  /// [cursor] - Optional cursor for pagination (format: "sla_started_at|claim_id")
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 50, max: 100)
  /// [status] - Optional status filter (server-side)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<ClaimSummary>>> fetchQueuePage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
  });
}
```

**Design decisions:**
- Cursor-based pagination (more reliable than offset for real-time data)
- Default page size 50 (reasonable for mobile/web)
- Max limit 100 (prevent abuse)
- Status filter server-side (already supported)
- Other filters remain client-side (priority, insurer, search) - can optimize later

---

## 3. Data Source Supabase Queries

### `lib/data/datasources/claim_remote_data_source.dart` (UPDATE)

```dart
abstract class ClaimRemoteDataSource {
  // ... existing methods ...

  /// Fetch paginated claims from v_claims_list view
  /// 
  /// Cursor format: "sla_started_at_iso8601|claim_id"
  /// Example: "2025-01-15T10:30:00Z|550e8400-e29b-41d4-a716-446655440000"
  /// 
  /// Returns rows + next cursor (null if no more data)
  Future<Result<PaginatedResult<ClaimSummaryRow>>> fetchQueuePage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
  });
}
```

### `lib/data/datasources/supabase_claim_remote_data_source.dart` (UPDATE)

```dart
@override
Future<Result<PaginatedResult<ClaimSummaryRow>>> fetchQueuePage({
  String? cursor,
  int limit = 50,
  ClaimStatus? status,
}) async {
  try {
    // Validate limit
    final pageSize = limit.clamp(1, 100);
    
    // Build query
    var query = _client
        .from('v_claims_list')
        .select('*');
    
    // Apply status filter (server-side)
    if (status != null) {
      query = query.eq('status', status.value);
    }
    
    // Apply cursor (pagination)
    // Cursor condition: (sla_started_at > cursor_sla) OR 
    //                   (sla_started_at = cursor_sla AND claim_id > cursor_id)
    // 
    // PostgREST supports OR via .or() method with filter syntax:
    //   .or('sla_started_at.gt.cursor_sla,sla_started_at.eq.cursor_sla.claim_id.gt.cursor_id')
    // 
    // However, this is complex. Simpler approach: use gt() on sla_started_at,
    // then filter out exact matches where claim_id <= cursor_id in application code.
    // OR use PostgREST filter string directly.
    
    if (cursor != null) {
      final parts = cursor.split('|');
      if (parts.length == 2) {
        final cursorSlaStartedAt = DateTime.parse(parts[0]);
        final cursorClaimId = parts[1];
        
        // PostgREST filter: (sla_started_at > cursor) OR 
        //                  (sla_started_at = cursor AND claim_id > cursor_id)
        // Format: "column1.gt.value1,column1.eq.value1.column2.gt.value2"
        // Note: PostgREST OR syntax may vary. If this doesn't work, use simpler approach:
        //   .gt('sla_started_at', cursorSlaStartedAt) and filter in app code
        //   OR use raw filter string: "sla_started_at.gt.$cursorSlaStartedAt,sla_started_at.eq.$cursorSlaStartedAt.claim_id.gt.$cursorClaimId"
        query = query
            .or('sla_started_at.gt.$cursorSlaStartedAt,sla_started_at.eq.$cursorSlaStartedAt.claim_id.gt.$cursorClaimId')
            .order('sla_started_at', ascending: true)
            .order('claim_id', ascending: true);
      } else {
        // Invalid cursor format - treat as first page
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
    
    // Generate next cursor from last item (even if no more data, for consistency)
    String? nextCursor;
    if (items.isNotEmpty) {
      final lastItem = items.last;
      nextCursor = '${lastItem.slaStartedAt.toIso8601String()}|${lastItem.claimId}';
    }
    
    return Result.ok(PaginatedResult(
      items: items,
      nextCursor: nextCursor,
      hasMore: hasMore,
    ));
  } on PostgrestException catch (err) {
    AppLogger.error(
      'Failed to fetch claims queue page (cursor: $cursor, status: $status)',
      name: 'SupabaseClaimRemoteDataSource',
      error: err,
    );
    return Result.err(mapPostgrestException(err));
  } catch (err, stackTrace) {
    AppLogger.error(
      'Unexpected error fetching claims queue page',
      name: 'SupabaseClaimRemoteDataSource',
      error: err,
      stackTrace: stackTrace,
    );
    return Result.err(UnknownError(err));
  }
}
```

**Query specifications:**
- **View:** `v_claims_list` (already exists, includes all needed fields)
- **Ordering:** `sla_started_at ASC, claim_id ASC` (consistent, uses index `claims_sla_idx`)
- **Pagination:** Cursor-based using `sla_started_at` + `claim_id` (tie-breaker)
- **Limit:** `limit + 1` to detect `hasMore` (fetch 51, return 50 if hasMore=true)
- **Filtering:** Status filter via `.eq('status', status.value)` (uses index `claims_tenant_status_idx`)

**Cursor format:**
- `"ISO8601_TIMESTAMP|UUID"`
- Example: `"2025-01-15T10:30:00.000Z|550e8400-e29b-41d4-a716-446655440000"`
- Parsed to extract `sla_started_at` and `claim_id` for cursor condition

**Alternative cursor approach (if PostgREST OR doesn't work):**
If the `.or()` filter syntax doesn't work as expected, use a simpler approach:
```dart
// Fetch with gt() on sla_started_at only, then filter in app code
query = query
    .gt('sla_started_at', cursorSlaStartedAt)
    .order('sla_started_at', ascending: true)
    .order('claim_id', ascending: true);

// After fetching, filter out items where sla_started_at == cursor and claim_id <= cursor_id
final filtered = rows.where((row) {
  if (row.slaStartedAt.isAtSameMomentAs(cursorSlaStartedAt)) {
    return row.claimId.compareTo(cursorClaimId) > 0;
  }
  return true;
}).toList();
```
This is less efficient (fetches more data) but more reliable.

**Index usage:**
- `claims_tenant_status_idx` (tenant_id, status) - supports status filtering
- `claims_sla_idx` (tenant_id, sla_started_at) - supports ordering
- RLS enforces tenant_id automatically (no explicit filter needed)

---

## 4. Paginated Result Model

### `lib/domain/models/paginated_result.dart` (NEW)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result.freezed.dart';

/// Generic paginated result wrapper
/// 
/// [T] - Item type
/// [items] - Current page items
/// [nextCursor] - Cursor for next page (null if no more data)
/// [hasMore] - Whether more data is available
@freezed
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> items,
    String? nextCursor,
    @Default(false) bool hasMore,
  }) = _PaginatedResult<T>;
}
```

**Usage:**
```dart
PaginatedResult<ClaimSummary>(
  items: [...],
  nextCursor: "2025-01-15T10:30:00Z|uuid",
  hasMore: true,
)
```

---

## 5. Riverpod Provider/Controller Pattern

### `lib/features/claims/controller/queue_controller.dart` (REPLACE)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/utils/result.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../../data/repositories/claim_repository_supabase.dart';

part 'queue_controller.g.dart';
part 'queue_controller.freezed.dart';

/// State for paginated claims queue
@freezed
class ClaimsQueueState with _$ClaimsQueueState {
  const factory ClaimsQueueState({
    @Default([]) List<ClaimSummary> items,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? nextCursor,
    DomainError? error,
    ClaimStatus? statusFilter,
  }) = _ClaimsQueueState;
}

@riverpod
class ClaimsQueueController extends _$ClaimsQueueController {
  @override
  Future<ClaimsQueueState> build({ClaimStatus? status}) async {
    // Initial load
    return await _loadFirstPage(status: status);
  }

  /// Load first page (reset pagination)
  Future<ClaimsQueueState> _loadFirstPage({ClaimStatus? status}) async {
    state = AsyncValue.data(
      state.valueOrNull?.copyWith(
        isLoading: true,
        error: null,
        statusFilter: status,
        items: [], // Clear items on first page load
      ) ?? ClaimsQueueState(isLoading: true, statusFilter: status),
    );

    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.fetchQueuePage(
      cursor: null, // First page
      limit: 50,
      status: status,
    );

    if (result.isErr) {
      return ClaimsQueueState(
        items: [],
        isLoading: false,
        error: result.error,
        statusFilter: status,
      );
    }

    final page = result.data;
    return ClaimsQueueState(
      items: page.items,
      isLoading: false,
      hasMore: page.hasMore,
      nextCursor: page.nextCursor,
      statusFilter: status,
    );
  }

  /// Load next page (append to existing items)
  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || 
        current.isLoadingMore || 
        !current.hasMore || 
        current.nextCursor == null) {
      return; // Already loading, no more data, or no cursor
    }

    // Update state: loading more
    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true, error: null),
    );

    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.fetchQueuePage(
      cursor: current.nextCursor,
      limit: 50,
      status: current.statusFilter,
    );

    if (result.isErr) {
      // Update state: error (but keep existing items)
      state = AsyncValue.data(
        current.copyWith(
          isLoadingMore: false,
          error: result.error,
        ),
      );
      return;
    }

    final page = result.data;
    // Update state: append new items
    state = AsyncValue.data(
      current.copyWith(
        items: [...current.items, ...page.items],
        isLoadingMore: false,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
        error: null,
      ),
    );
  }

  /// Refresh (reload first page)
  Future<void> refresh() async {
    final current = state.valueOrNull;
    final newState = await _loadFirstPage(status: current?.statusFilter);
    state = AsyncValue.data(newState);
  }

  /// Update status filter (reload first page)
  Future<void> setStatusFilter(ClaimStatus? status) async {
    final newState = await _loadFirstPage(status: status);
    state = AsyncValue.data(newState);
  }
}
```

**State management:**
- `items` - Accumulated list (all pages loaded so far)
- `isLoading` - Initial load in progress
- `isLoadingMore` - Next page load in progress
- `hasMore` - Whether more data available
- `nextCursor` - Cursor for next page
- `error` - Current error (null if no error)
- `statusFilter` - Current status filter

**Pattern:**
- `AsyncNotifier` with `ClaimsQueueState` (not `List<ClaimSummary>`)
- Errors stored in state (don't throw, preserve existing items)
- `loadNextPage()` appends to existing items
- `refresh()` resets to first page

---

## 6. UI Integration Notes

### Scroll Threshold for Next Page

```dart
// In ClaimsQueueScreen
final scrollController = ScrollController();

@override
void initState() {
  super.initState();
  scrollController.addListener(_onScroll);
}

void _onScroll() {
  // Load next page when user scrolls within 200px of bottom
  if (scrollController.position.pixels >= 
      scrollController.position.maxScrollExtent - 200) {
    final controller = ref.read(claimsQueueControllerProvider().notifier);
    controller.loadNextPage();
  }
}

@override
void dispose() {
  scrollController.dispose();
  super.dispose();
}
```

**Threshold:** 200px from bottom (adjust based on UX testing)

### Refresh Handling

```dart
RefreshIndicator(
  onRefresh: () async {
    await ref.read(claimsQueueControllerProvider().notifier).refresh();
  },
  child: ListView.builder(
    controller: scrollController,
    itemCount: state.items.length + (state.hasMore ? 1 : 0),
    itemBuilder: (context, index) {
      if (index >= state.items.length) {
        // Loading more indicator
        return const Center(child: CircularProgressIndicator());
      }
      return _ClaimCard(claim: state.items[index]);
    },
  ),
)
```

**Refresh behavior:**
- Pull-to-refresh calls `refresh()`
- Resets to first page (clears accumulated items)
- Shows loading state during refresh

### Error Display

```dart
if (state.error != null) {
  // Show error banner/snackbar
  // Don't hide existing items (user can still see data)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Failed to load: ${state.error}'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () => controller.loadNextPage(),
      ),
    ),
  );
}
```

**Error handling:**
- Errors don't clear existing items
- Show error message (banner/snackbar)
- Provide retry action
- Separate error state for initial load vs. load more

### Loading States

```dart
if (state.isLoading) {
  return const Center(child: CircularProgressIndicator());
}

// Show items + loading more indicator at bottom
ListView.builder(
  itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == state.items.length && state.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _ClaimCard(claim: state.items[index]);
  },
)
```

---

## 7. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- All queries use `.limit(pageSize + 1)` (max 101 items per query)
- Page size clamped to 1-100 range
- Cursor-based pagination prevents offset explosion

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Errors stored in state (`error` field)
- Errors surface to UI (snackbar/banner)
- No empty list returned on error (preserve existing items)

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `ClaimRepository`
- Repository calls `ClaimRemoteDataSource`
- UI only calls controller methods
- No `supabaseClientProvider` in UI/controllers

---

## 8. Migration Checklist

### Files to Create

- [ ] `lib/domain/models/paginated_result.dart` - Generic pagination model
- [ ] `lib/domain/models/paginated_result.freezed.dart` - Generated (run build_runner)

### Files to Update

- [ ] `lib/domain/repositories/claim_repository.dart` - Add `fetchQueuePage()` method
- [ ] `lib/data/datasources/claim_remote_data_source.dart` - Add `fetchQueuePage()` method
- [ ] `lib/data/datasources/supabase_claim_remote_data_source.dart` - Implement pagination query
- [ ] `lib/data/repositories/claim_repository_supabase.dart` - Implement `fetchQueuePage()`
- [ ] `lib/features/claims/controller/queue_controller.dart` - Replace with paginated controller
- [ ] `lib/features/claims/presentation/claims_queue_screen.dart` - Update UI for pagination

### Files to Deprecate

- [ ] `lib/data/datasources/supabase_claim_remote_data_source.dart` - Remove old `fetchQueue()` method (or keep for backward compatibility during migration)

### Migration Steps

1. **Create `PaginatedResult` model:**
   ```bash
   # Create file, run build_runner
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Update repository interface:**
   - Add `fetchQueuePage()` method signature
   - Keep `fetchQueue()` for backward compatibility (mark as deprecated)

3. **Implement data source:**
   - Add `fetchQueuePage()` with cursor-based query
   - Test cursor parsing/generation

4. **Update controller:**
   - Replace `AsyncNotifier<List<ClaimSummary>>` with `AsyncNotifier<ClaimsQueueState>`
   - Add `loadNextPage()`, `refresh()`, `setStatusFilter()` methods

5. **Update UI:**
   - Add `ScrollController` with threshold listener
   - Update `ListView` to `ListView.builder` with dynamic item count
   - Add loading more indicator
   - Update error handling (show snackbar, don't clear items)

6. **Update tests:**
   - Unit test: `fetchQueuePage()` with cursor
   - Unit test: `loadNextPage()` appends items
   - Unit test: `refresh()` resets state
   - Widget test: Scroll threshold triggers load

7. **Remove old method:**
   - After migration complete, remove `fetchQueue()` (or keep for dashboard if needed)

### Testing Checklist

- [ ] Unit test: First page load (no cursor)
- [ ] Unit test: Next page load (with cursor)
- [ ] Unit test: Last page (hasMore = false)
- [ ] Unit test: Status filter applied
- [ ] Unit test: Invalid cursor handled (treats as first page)
- [ ] Unit test: Error handling (preserves existing items)
- [ ] Widget test: Scroll threshold triggers load
- [ ] Widget test: Refresh resets to first page
- [ ] Manual test: Load 200+ claims (verify pagination works)
- [ ] Manual test: Filter by status (verify server-side filter)
- [ ] Manual test: Client-side filters still work (priority, insurer, search)

---

## 9. Performance Considerations

### Query Performance

- **Index usage:** `claims_sla_idx` (tenant_id, sla_started_at) supports ordering
- **View performance:** `v_claims_list` includes lateral joins (may be slower than direct table query)
- **Recommendation:** Monitor query performance, consider materialized view if slow

### Client-Side Filtering

- **Current:** Priority, insurer, search filtered client-side (after pagination)
- **Impact:** User may need to load multiple pages to find item
- **Future optimization:** Move filters to server-side if needed

### Page Size

- **Default:** 50 items per page
- **Rationale:** Balance between network requests and scroll performance
- **Adjustment:** Can be made configurable per tenant if needed

---

## 10. Notes

- **Cursor format:** ISO8601 timestamp + UUID (ensures unique, sortable cursor)
- **Ordering:** `sla_started_at ASC, claim_id ASC` (consistent, uses index)
- **RLS:** Tenant isolation enforced automatically (no explicit tenant_id filter needed)
- **Backward compatibility:** Keep `fetchQueue()` for dashboard/other features during migration
- **Future enhancements:** Add date range filter, priority filter (server-side), search (full-text)

