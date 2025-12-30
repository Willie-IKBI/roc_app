import '../../core/utils/result.dart';
import '../models/daily_claim_report.dart';
import '../models/report_models.dart';

abstract class ReportingRepository {
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Result<List<AgentPerformanceReport>>> fetchAgentPerformanceReport();
  Future<Result<List<StatusDistributionReport>>> fetchStatusDistributionReport();
  Future<Result<List<DamageCauseReport>>>
      fetchDamageCauseReport();
  Future<Result<List<GeographicReport>>> fetchGeographicReport({
    String? groupBy,
  });
  Future<Result<List<InsurerPerformanceReport>>> fetchInsurerPerformanceReport();
}


