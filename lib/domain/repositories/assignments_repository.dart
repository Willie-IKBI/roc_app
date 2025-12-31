import '../../core/utils/result.dart';
import '../models/claim_summary.dart';
import '../models/paginated_result.dart';
import '../value_objects/claim_enums.dart';

abstract class AssignmentsRepository {
  /// Fetch paginated assignable jobs with server-side filters
  /// 
  /// [cursor] - Optional cursor for pagination (format: "sla_started_at|claim_id")
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 50, max: 100)
  /// [status] - Optional status filter (server-side)
  /// [assignedFilter] - Optional: true=assigned, false=unassigned, null=all (server-side)
  /// [technicianId] - Optional technician filter (server-side)
  /// [dateFrom] - Optional appointment date range start (server-side)
  /// [dateTo] - Optional appointment date range end (server-side)
  /// 
  /// Returns paginated results with next cursor if more data available.
  /// 
  /// Server-side filters eliminate N+1 queries:
  /// - technician_id IS NULL/NOT NULL (for assigned/unassigned)
  /// - appointment_date BETWEEN dateFrom AND dateTo (for date range)
  /// 
  /// Uses v_claims_list view for minimal payload.
  Future<Result<PaginatedResult<ClaimSummary>>> fetchAssignableJobsPage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
    bool? assignedFilter,
    String? technicianId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
}

