import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/daily_claim_report.dart';
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
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await _remote.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
    );

    if (result.isErr) {
      return Result.err(result.error);
    }

    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<List<AgentPerformanceReport>>> fetchAgentPerformanceReport() async {
    final result = await _remote.fetchAgentPerformanceReport();
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<List<StatusDistributionReport>>> fetchStatusDistributionReport() async {
    final result = await _remote.fetchStatusDistributionReport();
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<List<DamageCauseReport>>> fetchDamageCauseReport() async {
    final result = await _remote.fetchDamageCauseReport();
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<List<GeographicReport>>> fetchGeographicReport({
    String? groupBy,
  }) async {
    final result = await _remote.fetchGeographicReport(groupBy: groupBy);
    if (result.isErr) {
      return Result.err(result.error);
    }
    return Result.ok(
      result.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<List<InsurerPerformanceReport>>> fetchInsurerPerformanceReport() async {
    // Fetch main report
    final mainResult = await _remote.fetchInsurerPerformanceReport();
    if (mainResult.isErr) {
      return Result.err(mainResult.error);
    }

    // Fetch breakdowns
    final damageCauseResult = await _remote.fetchInsurerDamageCauseBreakdown();
    final statusResult = await _remote.fetchInsurerStatusBreakdown();

    final damageCauseBreakdown = damageCauseResult.isOk
        ? damageCauseResult.data.map((row) => row.toDomain()).toList()
        : <InsurerDamageCauseBreakdown>[];

    final statusBreakdown = statusResult.isOk
        ? statusResult.data.map((row) => row.toDomain()).toList()
        : <InsurerStatusBreakdown>[];

    // Group breakdowns by insurer ID
    final damageCauseByInsurer = <String, List<InsurerDamageCauseBreakdown>>{};
    for (final breakdown in damageCauseBreakdown) {
      damageCauseByInsurer.putIfAbsent(breakdown.insurerId, () => []).add(breakdown);
    }

    final statusByInsurer = <String, List<InsurerStatusBreakdown>>{};
    for (final breakdown in statusBreakdown) {
      statusByInsurer.putIfAbsent(breakdown.insurerId, () => []).add(breakdown);
    }

    // Combine main report with breakdowns
    final reports = mainResult.data.map((row) {
      return row.toDomain(
        damageCauseBreakdown: damageCauseByInsurer[row.insurerId] ?? [],
        statusBreakdown: statusByInsurer[row.insurerId] ?? [],
      );
    }).toList(growable: false);

    return Result.ok(reports);
  }
}


