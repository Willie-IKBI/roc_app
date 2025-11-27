import '../../core/utils/result.dart';
import '../models/daily_claim_report.dart';

abstract class ReportingRepository {
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  });
}


