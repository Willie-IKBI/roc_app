import '../../core/utils/result.dart';
import '../models/daily_claim_report_row.dart';
import '../models/report_row_models.dart';

abstract class ReportingRemoteDataSource {
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Result<List<AgentPerformanceReportRow>>> fetchAgentPerformanceReport();
  Future<Result<List<StatusDistributionReportRow>>> fetchStatusDistributionReport();
  Future<Result<List<DamageCauseReportRow>>> fetchDamageCauseReport();
  Future<Result<List<GeographicReportRow>>> fetchGeographicReport({
    String? groupBy, // 'province', 'city', 'suburb'
  });
  Future<Result<List<InsurerPerformanceReportRow>>> fetchInsurerPerformanceReport();
  Future<Result<List<InsurerDamageCauseRow>>> fetchInsurerDamageCauseBreakdown();
  Future<Result<List<InsurerStatusBreakdownRow>>> fetchInsurerStatusBreakdown();
}


