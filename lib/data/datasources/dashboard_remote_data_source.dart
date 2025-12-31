/// Interface for dashboard remote data source
/// 
/// Provides methods to fetch dashboard data from remote storage (Supabase)
abstract class DashboardRemoteDataSource {
  /// Fetch dashboard summary aggregates
  /// 
  /// Returns raw data from Supabase for aggregates calculation
  /// Includes: status counts, priority counts, overdue/due soon/follow-up counts
  Future<Map<String, dynamic>> fetchDashboardSummary();

  /// Fetch recent claims list
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Minimal payload: Only fields needed for dashboard display
  Future<List<Map<String, dynamic>>> fetchRecentClaims({
    int limit = 5,
  });

  /// Fetch overdue claims list
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Minimal payload: Only fields needed for dashboard display
  Future<List<Map<String, dynamic>>> fetchOverdueClaims({
    int limit = 50,
  });

  /// Fetch claims needing follow-up list
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Minimal payload: Only fields needed for dashboard display
  Future<List<Map<String, dynamic>>> fetchNeedsFollowUp({
    int limit = 5,
  });
}

