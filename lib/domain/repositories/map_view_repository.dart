import '../models/claim_map_marker.dart';
import '../models/map_bounds.dart';
import '../../core/utils/result.dart';
import '../value_objects/claim_enums.dart';

/// Date range for filtering claims by creation date
class DateRange {
  const DateRange({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}

abstract class MapViewRepository {
  /// Fetch claims for map display
  /// 
  /// [bounds] - Optional geographic bounds (north, south, east, west)
  ///            If null, fetches all claims (initial load)
  /// [dateRange] - Optional date range filter (startDate, endDate)
  ///               If null, fetches all dates
  /// [status] - Optional status filter (null = all except closed/cancelled)
  /// [technicianId] - Optional technician filter
  /// [technicianAssignmentFilter] - Optional: true=assigned, false=unassigned, null=all
  /// [limit] - Maximum number of markers (default: 500, max: 1000)
  /// 
  /// Returns list of ClaimMapMarker (minimal payload for map pins)
  /// 
  /// Strategy:
  /// - Initial load: bounds=null, fetches up to limit claims (ordered by priority/SLA)
  /// - Bounds refine: bounds provided, fetches claims within bounds (up to limit)
  /// - Caching: Repository layer doesn't cache (controller handles caching)
  Future<Result<List<ClaimMapMarker>>> fetchMapClaims({
    MapBounds? bounds,
    DateRange? dateRange,
    ClaimStatus? status,
    String? technicianId,
    bool? technicianAssignmentFilter,
    int limit = 500,
  });
}

