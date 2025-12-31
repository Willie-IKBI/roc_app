import '../../domain/models/paginated_result.dart';
import '../models/claim_summary_row.dart';

/// Interface for assignments remote data source
/// 
/// Provides methods to fetch assignable jobs data from remote storage (Supabase)
abstract class AssignmentsRemoteDataSource {
  /// Fetch paginated assignable jobs with server-side filters
  /// 
  /// Returns paginated results with next cursor if more data available.
  /// Uses v_claims_list view for minimal payload.
  /// 
  /// Enforces:
  /// - Hard limit: limit.clamp(1, 100) per page
  /// - Deterministic ordering: sla_started_at ASC, claim_id ASC
  /// - Cursor-based pagination (same pattern as Claims Queue)
  /// - Server-side filters: status, assigned/unassigned, technician, date range
  Future<PaginatedResult<ClaimSummaryRow>> fetchAssignableJobsPage({
    String? cursor,
    int limit = 50,
    String? status,
    bool? assignedFilter,
    String? technicianId,
    String? dateFrom,
    String? dateTo,
  });
}

