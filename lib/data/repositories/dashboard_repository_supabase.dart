import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/claim_summary.dart';
import '../../domain/models/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../datasources/supabase_dashboard_remote_data_source.dart';
import '../models/claim_summary_row.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseDashboardRemoteDataSource(client);
  return DashboardRepositorySupabase(dataSource);
});

class DashboardRepositorySupabase implements DashboardRepository {
  DashboardRepositorySupabase(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<Result<DashboardSummary>> fetchDashboardSummary() async {
    try {
      final data = await _remote.fetchDashboardSummary();

      // Data source now returns pre-calculated counts (no rows to process)
      final totalActiveClaims = data['totalActiveClaims'] as int;
      final statusCounts = data['statusCounts'] as Map<ClaimStatus, int>;
      final priorityCounts = data['priorityCounts'] as Map<PriorityLevel, int>;
      final overdueCount = data['overdueCount'] as int;
      final dueSoonCount = data['dueSoonCount'] as int;
      final followUpCount = data['followUpCount'] as int;

      return Result.ok(
        DashboardSummary(
          totalActiveClaims: totalActiveClaims,
          statusCounts: statusCounts,
          priorityCounts: priorityCounts,
          overdueCount: overdueCount,
          dueSoonCount: dueSoonCount,
          followUpCount: followUpCount,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch dashboard summary: $e',
        name: 'DashboardRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch dashboard summary: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Dashboard summary data');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  @override
  Future<Result<List<ClaimSummary>>> fetchRecentClaims({
    int limit = 5,
  }) async {
    try {
      final rows = await _remote.fetchRecentClaims(limit: limit);
      final claims = rows.map((row) => ClaimSummaryRow.fromJson(row).toDomain()).toList();
      return Result.ok(claims);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch recent claims: $e',
        name: 'DashboardRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      DomainError error;
      if (e is PostgrestException) {
        error = NetworkError(e);
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  @override
  Future<Result<List<ClaimSummary>>> fetchOverdueClaims({
    int limit = 50,
  }) async {
    try {
      final rows = await _remote.fetchOverdueClaims(limit: limit);
      final claims = rows.map((row) => ClaimSummaryRow.fromJson(row).toDomain()).toList();

      // Filter overdue client-side (using priority thresholds)
      final now = DateTime.now();
      final priorityThresholds = <PriorityLevel, Duration>{
        PriorityLevel.urgent: const Duration(hours: 2),
        PriorityLevel.high: const Duration(hours: 4),
        PriorityLevel.normal: const Duration(hours: 8),
        PriorityLevel.low: const Duration(hours: 24),
      };

      final overdueClaims = claims.where((claim) {
        final threshold = priorityThresholds[claim.priority] ?? const Duration(hours: 8);
        return claim.elapsed > threshold;
      }).toList();

      return Result.ok(overdueClaims);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch overdue claims: $e',
        name: 'DashboardRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      DomainError error;
      if (e is PostgrestException) {
        error = NetworkError(e);
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  @override
  Future<Result<List<ClaimSummary>>> fetchNeedsFollowUp({
    int limit = 5,
  }) async {
    try {
      final rows = await _remote.fetchNeedsFollowUp(limit: limit);
      final claims = rows.map((row) => ClaimSummaryRow.fromJson(row).toDomain()).toList();

      // Filter follow-up client-side (no contact in last 4 hours)
      final now = DateTime.now();
      final followUpClaims = claims.where((claim) {
        final latestContact = claim.latestContactAt;
        return latestContact == null ||
            now.difference(latestContact) >= const Duration(hours: 4);
      }).take(limit).toList();

      return Result.ok(followUpClaims);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch follow-up claims: $e',
        name: 'DashboardRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      DomainError error;
      if (e is PostgrestException) {
        error = NetworkError(e);
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }
}

