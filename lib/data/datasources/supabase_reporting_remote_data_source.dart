import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/daily_claim_report_row.dart';
import 'reporting_remote_data_source.dart';

class SupabaseReportingRemoteDataSource implements ReportingRemoteDataSource {
  SupabaseReportingRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _client.from('v_claims_reporting').select(
        'claim_date, claims_captured, avg_minutes_to_first_contact, compliant_claims, contacted_claims',
      );

      if (startDate != null) {
        query = query.gte('claim_date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('claim_date', endDate.toIso8601String());
      }

      final response = await query.order('claim_date', ascending: false).limit(90);

      final rows = (response as List<dynamic>)
          .map(
            (row) => DailyClaimReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}


