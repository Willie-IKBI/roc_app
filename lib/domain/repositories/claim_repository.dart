import '../../core/utils/result.dart';
import '../models/claim.dart';
import '../models/claim_draft.dart';
import '../models/claim_summary.dart';
import '../models/contact_attempt_input.dart';
import '../value_objects/claim_enums.dart';

abstract class ClaimRepository {
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

