import '../../core/utils/result.dart';
import '../../domain/models/claim_draft.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../models/address_row.dart';
import '../models/claim_item_row.dart';
import '../models/claim_row.dart';
import '../models/claim_status_history_row.dart';
import '../models/claim_summary_row.dart';
import '../models/client_row.dart';
import '../models/contact_attempt_row.dart';

abstract class ClaimRemoteDataSource {
  Future<Result<List<ClaimSummaryRow>>> fetchQueue({ClaimStatus? status});

  Future<Result<ClaimRow>> fetchClaim(String claimId);

  Future<Result<List<ClaimItemRow>>> fetchClaimItems(String claimId);

  Future<Result<ContactAttemptRow?>> fetchLatestContact(String claimId);

  Future<Result<List<ContactAttemptRow>>> fetchContactAttempts(String claimId);

  Future<Result<List<ClaimStatusHistoryRow>>> fetchStatusHistory(String claimId);

  Future<Result<ClientRow>> fetchClient(String clientId);

  Future<Result<AddressRow>> fetchAddress(String addressId);

  Future<Result<void>> createContactAttempt({
    required String claimId,
    required String tenantId,
    required String method,
    required String outcome,
    String? notes,
    bool sendSmsTemplate = false,
    String? smsTemplateId,
  });

  Future<Result<void>> updateClaimStatus({
    required String claimId,
    required String tenantId,
    required ClaimStatus fromStatus,
    required ClaimStatus toStatus,
    String? reason,
  });

  Future<Result<String>> createClaim(ClaimDraft draft);

  Future<Result<void>> createClaimItems({
    required String claimId,
    required ClaimDraft draft,
  });

  Future<Result<String>> createClient({
    required String tenantId,
    required ClientInput input,
  });

  Future<Result<String>> createAddress({
    required String tenantId,
    required String clientId,
    required AddressInput input,
  });

  Future<Result<String?>> createServiceProvider({
    required String tenantId,
    required ServiceProviderInput input,
  });

  Future<Result<bool>> claimExists({
    required String insurerId,
    required String claimNumber,
  });
}

