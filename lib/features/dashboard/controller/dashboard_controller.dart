import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/dashboard_repository_supabase.dart';
import '../../../core/logging/logger.dart';
import '../domain/dashboard_state.dart';

part 'dashboard_controller.g.dart';

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

    // Fetch summary first (required)
    final summaryResult = await repository.fetchDashboardSummary();
    if (summaryResult.isErr) {
      // Summary failure → Throw error (dashboard unusable without counts)
      throw summaryResult.error;
    }

    // Fetch lists in parallel (optional, can fail gracefully)
    final recentResult = await repository.fetchRecentClaims(limit: 5);
    final overdueResult = await repository.fetchOverdueClaims(limit: 50);
    final followUpResult = await repository.fetchNeedsFollowUp(limit: 5);

    // Log errors for list queries (graceful degradation)
    if (recentResult.isErr) {
      AppLogger.error(
        'Failed to fetch recent claims: ${recentResult.error.message}',
        name: 'DashboardController',
        error: recentResult.error,
      );
    }
    if (overdueResult.isErr) {
      AppLogger.error(
        'Failed to fetch overdue claims: ${overdueResult.error.message}',
        name: 'DashboardController',
        error: overdueResult.error,
      );
    }
    if (followUpResult.isErr) {
      AppLogger.error(
        'Failed to fetch follow-up claims: ${followUpResult.error.message}',
        name: 'DashboardController',
        error: followUpResult.error,
      );
    }

    final summary = summaryResult.data;

    return DashboardState(
      claims: [], // Not used in new implementation
      statusCounts: summary.statusCounts,
      priorityCounts: summary.priorityCounts,
      overdueClaims: overdueResult.isOk ? overdueResult.data : [],
      needsFollowUp: followUpResult.isOk ? followUpResult.data : [],
      recentClaims: recentResult.isOk ? recentResult.data : [],
      dueSoonCount: summary.dueSoonCount,
    );
  }
}

