import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';
import 'claim_item.dart';
import 'address.dart';
import 'client.dart';
import 'contact_attempt.dart';
import 'claim_status_change.dart';

part 'claim.freezed.dart';

@freezed
abstract class Claim with _$Claim {
  const factory Claim({
    required String id,
    required String tenantId,
    required String claimNumber,
    required String insurerId,
    required String clientId,
    required String addressId,
    String? serviceProviderId,
    String? dasNumber,
    @Default(ClaimStatus.newClaim) ClaimStatus status,
    @Default(PriorityLevel.normal) PriorityLevel priority,
    @Default(DamageCause.other) DamageCause damageCause,
    String? damageDescription,
    @Default(false) bool surgeProtectionAtDb,
    @Default(false) bool surgeProtectionAtPlug,
    String? agentId,
    required DateTime slaStartedAt,
    DateTime? closedAt,
    String? notesPublic,
    String? notesInternal,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<ClaimItem>[]) List<ClaimItem> items,
    ContactAttempt? latestContact,
    @Default(<ContactAttempt>[]) List<ContactAttempt> contactAttempts,
    @Default(<ClaimStatusChange>[]) List<ClaimStatusChange> statusHistory,
    Client? client,
    Address? address,
  }) = _Claim;

  const Claim._();
}
