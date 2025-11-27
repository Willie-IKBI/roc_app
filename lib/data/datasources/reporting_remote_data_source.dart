import '../../core/utils/result.dart';
import '../models/daily_claim_report_row.dart';

abstract class ReportingRemoteDataSource {
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  });
}


