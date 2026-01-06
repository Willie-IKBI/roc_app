import '../../core/utils/result.dart';
import '../../domain/models/paginated_result.dart';
import '../models/daily_claim_report_row.dart';
import '../models/report_row_models.dart';

abstract class ReportingRemoteDataSource {
  /// Fetch daily reports (aggregated by date)
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [limit] - Maximum number of days (default: 90, max: 365)
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 90,
  });

  /// Fetch paginated agent performance report
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<AgentPerformanceReportRow>>> fetchAgentPerformanceReportPage({
    DateTime? startDate,
    DateTime? endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated status distribution report
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<StatusDistributionReportRow>>> fetchStatusDistributionReportPage({
    DateTime? startDate,
    DateTime? endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated damage cause report
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<DamageCauseReportRow>>> fetchDamageCauseReportPage({
    DateTime? startDate,
    DateTime? endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated geographic report
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [groupBy] - Grouping field: 'province', 'city', or 'suburb' (default: 'province')
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<GeographicReportRow>>> fetchGeographicReportPage({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated insurer performance report
  /// 
  /// [startDate] - Start date (optional, if null shows all data)
  /// [endDate] - End date (optional, if null shows all data)
  /// [cursor] - Optional cursor for pagination (format: "insurer_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<InsurerPerformanceReportRow>>> fetchInsurerPerformanceReportPage({
    DateTime? startDate,
    DateTime? endDate,
    String? cursor,
    int limit = 100,
  });
}


