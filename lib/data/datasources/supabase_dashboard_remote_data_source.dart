import 'package:supabase_flutter/supabase_flutter.dart' show CountOption, PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import '../../domain/value_objects/claim_enums.dart';
import 'dashboard_remote_data_source.dart';

class SupabaseDashboardRemoteDataSource implements DashboardRemoteDataSource {
  SupabaseDashboardRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Map<String, dynamic>> fetchDashboardSummary() async {
    try {
      // Helper to build base query for active claims (not closed/cancelled)
      Future<int> _countActiveClaims() => _client
          .from('v_claims_list')
          .select('id')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .count(CountOption.exact)
          .then((response) => response.count);

      // Helper to count by status
      Future<MapEntry<ClaimStatus, int>> _countByStatus(ClaimStatus status) => _client
          .from('v_claims_list')
          .select('id')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .eq('status', status.value)
          .count(CountOption.exact)
          .then((response) => MapEntry(status, response.count));

      // Helper to count by priority
      Future<MapEntry<PriorityLevel, int>> _countByPriority(PriorityLevel priority) => _client
          .from('v_claims_list')
          .select('id')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .eq('priority', priority.value)
          .count(CountOption.exact)
          .then((response) => MapEntry(priority, response.count));

      // Run count queries in parallel for efficiency
      final results = await Future.wait([
        // Total active claims count
        _countActiveClaims(),

        // Status counts (one query per status)
        ...ClaimStatus.values
            .where((s) => s != ClaimStatus.closed && s != ClaimStatus.cancelled)
            .map(_countByStatus),

        // Priority counts (one query per priority)
        ...PriorityLevel.values.map(_countByPriority),
      ]);

      // Extract results
      final totalActiveClaims = results[0] as int;
      final statusCountsEntries = results.skip(1).take(ClaimStatus.values.length - 2).cast<MapEntry<ClaimStatus, int>>();
      final priorityCountsEntries = results.skip(1 + ClaimStatus.values.length - 2).cast<MapEntry<PriorityLevel, int>>();

      final statusCounts = Map<ClaimStatus, int>.fromEntries(statusCountsEntries);
      final priorityCounts = Map<PriorityLevel, int>.fromEntries(priorityCountsEntries);

      // For overdue/due soon/follow-up counts, use count-only queries with time-based filters
      // Priority thresholds: urgent=2h, high=4h, normal=8h, low=24h
      final now = DateTime.now();
      final priorityThresholds = <PriorityLevel, Duration>{
        PriorityLevel.urgent: const Duration(hours: 2),
        PriorityLevel.high: const Duration(hours: 4),
        PriorityLevel.normal: const Duration(hours: 8),
        PriorityLevel.low: const Duration(hours: 24),
      };

      // Build count queries for overdue/due soon/follow-up in parallel
      final slaCountQueries = <Future<int>>[];

      // Overdue counts (one query per priority: elapsed > threshold)
      // sla_started_at < (now - threshold) means elapsed > threshold
      for (final priority in PriorityLevel.values) {
        final threshold = priorityThresholds[priority] ?? const Duration(hours: 8);
        final thresholdTime = now.subtract(threshold);
        slaCountQueries.add(
          _client
              .from('v_claims_list')
              .select('id')
              .neq('status', ClaimStatus.closed.value)
              .neq('status', ClaimStatus.cancelled.value)
              .eq('priority', priority.value)
              .not('sla_started_at', 'is', null)
              .lt('sla_started_at', thresholdTime.toIso8601String())
              .count(CountOption.exact)
              .then((response) => response.count),
        );
      }

      // Due soon counts (one query per priority: elapsed >= 50% threshold AND <= threshold)
      // (now - threshold) <= sla_started_at <= (now - 50% threshold)
      for (final priority in PriorityLevel.values) {
        final threshold = priorityThresholds[priority] ?? const Duration(hours: 8);
        final thresholdTime = now.subtract(threshold);
        final halfThresholdTime = now.subtract(threshold * 0.5);
        slaCountQueries.add(
          _client
              .from('v_claims_list')
              .select('id')
              .neq('status', ClaimStatus.closed.value)
              .neq('status', ClaimStatus.cancelled.value)
              .eq('priority', priority.value)
              .not('sla_started_at', 'is', null)
              .gte('sla_started_at', thresholdTime.toIso8601String())
              .lte('sla_started_at', halfThresholdTime.toIso8601String())
              .count(CountOption.exact)
              .then((response) => response.count),
        );
      }

      // Follow-up count (no contact in last 4 hours)
      final fourHoursAgo = now.subtract(const Duration(hours: 4));
      slaCountQueries.add(
        _client
            .from('v_claims_list')
            .select('id')
            .neq('status', ClaimStatus.closed.value)
            .neq('status', ClaimStatus.cancelled.value)
            .or('latest_contact_attempt_at.is.null,latest_contact_attempt_at.lt.${fourHoursAgo.toIso8601String()}')
            .count(CountOption.exact)
            .then((response) => response.count),
      );

      final slaCounts = await Future.wait(slaCountQueries);

      // Sum overdue counts (first PriorityLevel.values.length results)
      final overdueCount = slaCounts
          .take(PriorityLevel.values.length)
          .fold<int>(0, (sum, count) => sum + count);

      // Sum due soon counts (next PriorityLevel.values.length results)
      final dueSoonCount = slaCounts
          .skip(PriorityLevel.values.length)
          .take(PriorityLevel.values.length)
          .fold<int>(0, (sum, count) => sum + count);

      // Follow-up count (last result)
      final followUpCount = slaCounts.last;

      return {
        'totalActiveClaims': totalActiveClaims,
        'statusCounts': statusCounts,
        'priorityCounts': priorityCounts,
        'overdueCount': overdueCount,
        'dueSoonCount': dueSoonCount,
        'followUpCount': followUpCount,
      };
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch dashboard summary: ${e.message}',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching dashboard summary: $e',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentClaims({
    int limit = 5,
  }) async {
    try {
      final pageSize = limit.clamp(1, 50);

      final data = await _client
          .from('v_claims_list')
          .select('*')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .order('sla_started_at', ascending: false) // Most recent first
          .order('claim_id', ascending: true) // Tie-breaker
          .limit(pageSize);

      final rows = data as List<dynamic>;
      return rows.map((row) => row as Map<String, dynamic>).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch recent claims: ${e.message}',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching recent claims: $e',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchOverdueClaims({
    int limit = 50,
  }) async {
    try {
      final pageSize = limit.clamp(1, 100);

      // Fetch claims ordered by priority and SLA (overdue filtering done client-side)
      final data = await _client
          .from('v_claims_list')
          .select('*')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .order('priority', ascending: false) // Urgent first
          .order('sla_started_at', ascending: true) // Oldest SLA first
          .order('claim_id', ascending: true) // Tie-breaker
          .limit(pageSize);

      final rows = data as List<dynamic>;
      return rows.map((row) => row as Map<String, dynamic>).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch overdue claims: ${e.message}',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching overdue claims: $e',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNeedsFollowUp({
    int limit = 5,
  }) async {
    try {
      final pageSize = limit.clamp(1, 50);

      // Fetch claims ordered by SLA (follow-up filtering done client-side)
      final data = await _client
          .from('v_claims_list')
          .select('*')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          .order('sla_started_at', ascending: true) // Oldest SLA first
          .order('claim_id', ascending: true) // Tie-breaker
          .limit(pageSize);

      final rows = data as List<dynamic>;
      return rows.map((row) => row as Map<String, dynamic>).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch follow-up claims: ${e.message}',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching follow-up claims: $e',
        name: 'SupabaseDashboardRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

