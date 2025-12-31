import '../../core/utils/result.dart';
import '../models/daily_claim_report.dart';
import '../models/paginated_result.dart';
import '../models/report_models.dart';

abstract class ReportingRepository {
  /// Fetch daily reports (aggregated by date)
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [limit] - Maximum number of days (default: 90, max: 365)
  /// 
  /// Returns list of daily reports (one per day)
  /// 
  /// Note: Daily reports are small (one row per day), so no pagination needed.
  /// But date range is still required.
  Future<Result<List<DailyClaimReport>>> fetchDailyReports({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 90,
  });

  /// Fetch paginated agent performance report
  /// 
  /// [startDate] - Start date (required)
  /// [endDate] - End date (required)
  /// [cursor] - Optional cursor for pagination (format: "claim_id")
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<AgentPerformanceReport>>> fetchAgentPerformanceReportPage({
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
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<StatusDistributionReport>>> fetchStatusDistributionReportPage({
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
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<DamageCauseReport>>> fetchDamageCauseReportPage({
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
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<GeographicReport>>> fetchGeographicReportPage({
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
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 100, max: 500)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<InsurerPerformanceReport>>> fetchInsurerPerformanceReportPage({
    required DateTime startDate,
    required DateTime endDate,
    String? cursor,
    int limit = 100,
  });
}


