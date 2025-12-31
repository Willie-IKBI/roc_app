import '../../core/utils/result.dart';
import '../../domain/models/paginated_result.dart';
import '../models/daily_claim_report_row.dart';
import '../models/report_row_models.dart';

abstract class ReportingRemoteDataSource {
  /// Fetch daily reports (aggregated by date)
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [limit] - Maximum number of days (default: 90, max: 365)
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 90,
  });

  /// Fetch paginated agent performance report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<AgentPerformanceReportRow>>> fetchAgentPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated status distribution report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<StatusDistributionReportRow>>> fetchStatusDistributionReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated damage cause report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<DamageCauseReportRow>>> fetchDamageCauseReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated geographic report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [groupBy] - Grouping field: 'province', 'city', or 'suburb' (default: 'province')
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<GeographicReportRow>>> fetchGeographicReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? groupBy,
    String? cursor,
    int limit = 100,
  });

  /// Fetch paginated insurer performance report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [cursor] - Optional cursor for pagination (format: "insurer_id")
  /// [limit] - Page size (default: 100, max: 500)
  Future<Result<PaginatedResult<InsurerPerformanceReportRow>>> fetchInsurerPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });
}


