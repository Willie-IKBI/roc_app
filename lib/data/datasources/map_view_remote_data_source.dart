/// Interface for map view remote data source
/// 
/// Provides methods to fetch map marker data from remote storage (Supabase)
abstract class MapViewRemoteDataSource {
  /// Fetch claims for map display with minimal payload
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Includes: claims, addresses, profiles (technician), clients
  /// 
  /// Enforces:
  /// - Hard limit: limit.clamp(1, 1000) markers
  /// - Deterministic ordering: priority DESC, sla_started_at ASC, id ASC
  /// - Filters: status, technician, bounds, date range
  /// - Excludes closed/cancelled claims
  /// - Requires valid coordinates (lat/lng not null)
  Future<List<Map<String, dynamic>>> fetchMapClaims({
    Map<String, dynamic>? bounds,
    Map<String, dynamic>? dateRange,
    String? status,
    String? technicianId,
    bool? technicianAssignmentFilter,
    int limit = 500,
  });
}

