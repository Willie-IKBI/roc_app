import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/domain_error.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';

part 'queue_controller.g.dart';
part 'queue_controller.freezed.dart';

/// State for paginated claims queue
@freezed
abstract class ClaimsQueueState with _$ClaimsQueueState {
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
    final currentState = state.asData?.value ?? ClaimsQueueState();
    state = AsyncValue.data(
      currentState.copyWith(
        isLoading: true,
        error: null,
        statusFilter: status,
        items: [], // Clear items on first page load
      ),
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
    final current = state.asData?.value;
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
    final current = state.asData?.value;
    final newState = await _loadFirstPage(status: current?.statusFilter);
    state = AsyncValue.data(newState);
  }

  /// Update status filter (reload first page)
  Future<void> setStatusFilter(ClaimStatus? status) async {
    final newState = await _loadFirstPage(status: status);
    state = AsyncValue.data(newState);
  }
}
