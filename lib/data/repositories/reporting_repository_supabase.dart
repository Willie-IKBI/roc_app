import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/daily_claim_report.dart';
import '../../domain/models/paginated_result.dart';
import '../../domain/models/report_models.dart';
import '../../domain/repositories/reporting_repository.dart';
import '../clients/supabase_client.dart';
import '../datasources/reporting_remote_data_source.dart';
import '../datasources/supabase_reporting_remote_data_source.dart';

final reportingRepositoryProvider = Provider<ReportingRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final remote = SupabaseReportingRemoteDataSource(client);
  return ReportingRepositorySupabase(remote);
});

class ReportingRepositorySupabase implements ReportingRepository {
  ReportingRepositorySupabase(this._remote);

  final ReportingRemoteDataSource _remote;

  @override
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 90,
  }) async {
    final result = await _remote.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );

    if (result.isErr) {
      return Result.err(result.error);
    }

    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<PaginatedResult<AgentPerformanceReport>>> fetchAgentPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  }) async {
    final result = await _remote.fetchAgentPerformanceReportPage(
      startDate: startDate,
      endDate: endDate,
      cursor: cursor,
      limit: limit,
    );
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      PaginatedResult(
        items: result.data.items.map((row) => row.toDomain()).toList(growable: false),
        nextCursor: result.data.nextCursor,
        hasMore: result.data.hasMore,
      ),
    );
  }

  @override
  Future<Result<PaginatedResult<StatusDistributionReport>>> fetchStatusDistributionReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  }) async {
    final result = await _remote.fetchStatusDistributionReportPage(
      startDate: startDate,
      endDate: endDate,
      cursor: cursor,
      limit: limit,
    );
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      PaginatedResult(
        items: result.data.items.map((row) => row.toDomain()).toList(growable: false),
        nextCursor: result.data.nextCursor,
        hasMore: result.data.hasMore,
      ),
    );
  }

  @override
  Future<Result<PaginatedResult<DamageCauseReport>>> fetchDamageCauseReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  }) async {
    final result = await _remote.fetchDamageCauseReportPage(
      startDate: startDate,
      endDate: endDate,
      cursor: cursor,
      limit: limit,
    );
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      PaginatedResult(
        items: result.data.items.map((row) => row.toDomain()).toList(growable: false),
        nextCursor: result.data.nextCursor,
        hasMore: result.data.hasMore,
      ),
    );
  }

  @override
  Future<Result<PaginatedResult<GeographicReport>>> fetchGeographicReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? groupBy,
    String? cursor,
    int limit = 100,
  }) async {
    final result = await _remote.fetchGeographicReportPage(
      startDate: startDate,
      endDate: endDate,
      groupBy: groupBy,
      cursor: cursor,
      limit: limit,
    );
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      PaginatedResult(
        items: result.data.items.map((row) => row.toDomain()).toList(growable: false),
        nextCursor: result.data.nextCursor,
        hasMore: result.data.hasMore,
      ),
    );
  }

  @override
  Future<Result<PaginatedResult<InsurerPerformanceReport>>> fetchInsurerPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  }) async {
    final result = await _remote.fetchInsurerPerformanceReportPage(
      startDate: startDate,
      endDate: endDate,
      cursor: cursor,
      limit: limit,
    );
    if (result.isErr) {
      return Result.err(result.error);
    }
    
    // Note: Breakdowns are not included in paginated results
    // They would need separate paginated methods if needed
    return Result.ok(
      PaginatedResult(
        items: result.data.items.map((row) => row.toDomain()).toList(growable: false),
        nextCursor: result.data.nextCursor,
        hasMore: result.data.hasMore,
      ),
    );
  }
}


