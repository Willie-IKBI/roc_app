import '../../core/utils/result.dart';
import '../models/claim.dart';
import '../models/claim_draft.dart';
import '../models/claim_summary.dart';
import '../models/contact_attempt_input.dart';
import '../models/paginated_result.dart';
import '../value_objects/claim_enums.dart';

abstract class ClaimRepository {
  /// Fetch paginated claims queue
  /// 
  /// [cursor] - Optional cursor for pagination (format: "sla_started_at|claim_id")
  ///            If null, fetches first page.
  /// [limit] - Page size (default: 50, max: 100)
  /// [status] - Optional status filter (server-side)
  /// 
  /// Returns paginated results with next cursor if more data available.
  Future<Result<PaginatedResult<ClaimSummary>>> fetchQueuePage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
  });

  @Deprecated('Use fetchQueuePage instead. This method will be removed in a future version.')
  Future<Result<List<ClaimSummary>>> fetchQueue({ClaimStatus? status});

  Future<Result<Claim>> fetchById(String claimId);

  Future<Result<String>> createClaim({
    required ClaimDraft draft,
  });

  Future<Result<Claim>> addContactAttempt({
    required String claimId,
    required ContactAttemptInput draft,
  });

  Future<Result<Claim>> changeStatus({
    required String claimId,
    required ClaimStatus newStatus,
    String? reason,
  });

  Future<Result<Claim>> updateTechnician({
    required String claimId,
    String? technicianId,
  });

  Future<Result<Claim>> updateAppointment({
    required String claimId,
    DateTime? appointmentDate,
    String? appointmentTime,
  });

  Future<Result<bool>> claimExists({
    required String insurerId,
    required String claimNumber,
  });
}

