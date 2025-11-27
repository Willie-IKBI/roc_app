import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/daily_claim_report.dart';
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
}


