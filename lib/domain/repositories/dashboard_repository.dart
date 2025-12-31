import '../../core/utils/result.dart';
import '../models/claim_summary.dart';
import '../models/dashboard_summary.dart';
import '../value_objects/claim_enums.dart';

abstract class DashboardRepository {
  /// Fetch dashboard summary (aggregates/counts)
  /// 
  /// Returns server-side aggregates:
  /// - Total active claims (excludes closed/cancelled)
  /// - Counts by status (for pipeline overview)
  /// - Counts by priority (for priority breakdown)
  /// - Overdue count (claims exceeding SLA threshold)
  /// - Due soon count (claims within 50% of SLA threshold)
  /// - Follow-up count (no contact in last 4 hours)
  /// 
  /// Uses server-side COUNT/GROUP BY (efficient, no full claim objects)
  Future<Result<DashboardSummary>> fetchDashboardSummary();

  /// Fetch recent claims (most recently started)
  /// 
  /// [limit] - Maximum number of claims (default: 5, max: 50)
  /// 
  /// Returns list of recent claims (sorted by slaStartedAt DESC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchRecentClaims({
    int limit = 5,
  });

  /// Fetch overdue claims (exceeding SLA threshold)
  /// 
  /// [limit] - Maximum number of claims (default: 50, max: 100)
  /// 
  /// Returns list of overdue claims (sorted by priority DESC, then SLA ASC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchOverdueClaims({
    int limit = 50,
  });

  /// Fetch claims needing follow-up (no contact in last 4 hours)
  /// 
  /// [limit] - Maximum number of claims (default: 5, max: 50)
  /// 
  /// Returns list of follow-up claims (sorted by SLA ASC)
  /// Minimal payload: Only fields needed for dashboard display
  Future<Result<List<ClaimSummary>>> fetchNeedsFollowUp({
    int limit = 5,
  });
}

