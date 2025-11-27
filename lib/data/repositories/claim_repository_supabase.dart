import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/result.dart';
import '../../domain/models/claim.dart';
import '../../domain/models/claim_draft.dart';
import '../../domain/models/claim_summary.dart';
import '../../domain/models/contact_attempt_input.dart';
import '../../domain/repositories/claim_repository.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../datasources/claim_remote_data_source.dart';
import '../datasources/supabase_claim_remote_data_source.dart';

final claimRepositoryProvider = Provider<ClaimRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseClaimRemoteDataSource(client);
  return ClaimRepositorySupabase(dataSource);
});

class ClaimRepositorySupabase implements ClaimRepository {
  ClaimRepositorySupabase(this._remote);

  final ClaimRemoteDataSource _remote;

  @override
  Future<Result<List<ClaimSummary>>> fetchQueue({ClaimStatus? status}) async {
    final result = await _remote.fetchQueue(status: status);
    return result.map(
      (rows) => rows.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<Claim>> fetchById(String claimId) => _loadClaim(claimId);

  @override
  Future<Result<String>> createClaim({required ClaimDraft draft}) async {
    final createResult = await _remote.createClaim(draft);
    if (createResult.isErr) {
      return Result.err(createResult.error);
    }

    final claimId = createResult.data;
    final itemsResult = await _remote.createClaimItems(
      claimId: claimId,
      draft: draft,
    );

    if (itemsResult.isErr) {
      return Result.err(itemsResult.error);
    }

    return Result.ok(claimId);
  }

  @override
  Future<Result<Claim>> addContactAttempt({
    required String claimId,
    required ContactAttemptInput draft,
  }) async {
    final claimRowResult = await _remote.fetchClaim(claimId);
    if (claimRowResult.isErr) {
      return Result.err(claimRowResult.error);
    }

    final attemptResult = await _remote.createContactAttempt(
      claimId: claimId,
      tenantId: claimRowResult.data.tenantId,
      method: draft.method.value,
      outcome: draft.outcome.value,
      notes: draft.notes,
      sendSmsTemplate: draft.sendSmsTemplate,
      smsTemplateId: draft.smsTemplateId,
    );

    if (attemptResult.isErr) {
      return Result.err(attemptResult.error);
    }

    return _loadClaim(claimId);
  }

  @override
  Future<Result<Claim>> changeStatus({
    required String claimId,
    required ClaimStatus newStatus,
    String? reason,
  }) async {
    final claimRowResult = await _remote.fetchClaim(claimId);
    if (claimRowResult.isErr) {
      return Result.err(claimRowResult.error);
    }

    final currentStatus = ClaimStatus.fromJson(claimRowResult.data.status);
    if (currentStatus == newStatus) {
      return _loadClaim(claimId);
    }

    final updateResult = await _remote.updateClaimStatus(
      claimId: claimId,
      tenantId: claimRowResult.data.tenantId,
      fromStatus: currentStatus,
      toStatus: newStatus,
      reason: reason,
    );

    if (updateResult.isErr) {
      return Result.err(updateResult.error);
    }

    return _loadClaim(claimId);
  }

  Future<Result<Claim>> _loadClaim(String claimId) async {
    final claimRowResult = await _remote.fetchClaim(claimId);

    if (claimRowResult.isErr) {
      return Result.err(claimRowResult.error);
    }

    final itemsResult = await _remote.fetchClaimItems(claimId);

    if (itemsResult.isErr) {
      return Result.err(itemsResult.error);
    }

    final latestContactResult = await _remote.fetchLatestContact(claimId);

    if (latestContactResult.isErr) {
      return Result.err(latestContactResult.error);
    }

    final contactAttemptsResult = await _remote.fetchContactAttempts(claimId);

    if (contactAttemptsResult.isErr) {
      return Result.err(contactAttemptsResult.error);
    }

    final statusHistoryResult = await _remote.fetchStatusHistory(claimId);

    if (statusHistoryResult.isErr) {
      return Result.err(statusHistoryResult.error);
    }

    final clientResult = await _remote.fetchClient(claimRowResult.data.clientId);

    if (clientResult.isErr) {
      return Result.err(clientResult.error);
    }

    final addressResult = await _remote.fetchAddress(claimRowResult.data.addressId);

    if (addressResult.isErr) {
      return Result.err(addressResult.error);
    }

    final items = itemsResult.data.map((row) => row.toDomain()).toList(growable: false);

    final contactAttempts =
        contactAttemptsResult.data.map((row) => row.toDomain()).toList(growable: false);

    final statusHistory =
        statusHistoryResult.data.map((row) => row.toDomain()).toList(growable: false);

    final latestContactRow = latestContactResult.data;
    final claim = claimRowResult.data.toDomain(
      items: items,
      latestContact: latestContactRow?.toDomain(),
      contactAttempts: contactAttempts,
      statusHistory: statusHistory,
      client: clientResult.data.toDomain(),
      address: addressResult.data.toDomain(),
    );
    return Result.ok(claim);
  }

  @override
  Future<Result<bool>> claimExists({
    required String insurerId,
    required String claimNumber,
  }) {
    return _remote.claimExists(
      insurerId: insurerId,
      claimNumber: claimNumber,
    );
  }
}

