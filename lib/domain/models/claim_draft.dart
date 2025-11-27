import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'claim_draft.freezed.dart';

@freezed
abstract class ClaimItemDraft with _$ClaimItemDraft {
  const factory ClaimItemDraft({
    required String brand,
    String? color,
    @Default(WarrantyStatus.unknown) WarrantyStatus warranty,
    String? serialOrModel,
    String? notes,
  }) = _ClaimItemDraft;

  const ClaimItemDraft._();
}

@freezed
abstract class ClientInput with _$ClientInput {
  const factory ClientInput({
    required String firstName,
    required String lastName,
    required String primaryPhone,
    String? altPhone,
    String? email,
  }) = _ClientInput;

  const ClientInput._();
}

@freezed
abstract class AddressInput with _$AddressInput {
  const factory AddressInput({
    String? estateId,
    String? complexOrEstate,
    String? unitNumber,
    required String street,
    required String suburb,
    required String city,
    required String province,
    required String postalCode,
    double? latitude,
    double? longitude,
    String? googlePlaceId,
    String? notes,
  }) = _AddressInput;

  const AddressInput._();
}

@freezed
abstract class ServiceProviderInput with _$ServiceProviderInput {
  const factory ServiceProviderInput({
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumber,
  }) = _ServiceProviderInput;

  const ServiceProviderInput._();
}

@freezed
abstract class ClaimDraft with _$ClaimDraft {
  const factory ClaimDraft({
    required String tenantId,
    required String claimNumber,
    required String insurerId,
    String? clientId,
    ClientInput? clientInput,
    String? addressId,
    AddressInput? addressInput,
    String? serviceProviderId,
    ServiceProviderInput? serviceProviderInput,
    String? dasNumber,
    @Default(PriorityLevel.normal) PriorityLevel priority,
    @Default(DamageCause.other) DamageCause damageCause,
    String? damageDescription,
    @Default(false) bool surgeProtectionAtDb,
    @Default(false) bool surgeProtectionAtPlug,
    String? agentId,
    String? notesPublic,
    String? notesInternal,
    String? clientNotes,
    @Default(<ClaimItemDraft>[]) List<ClaimItemDraft> items,
  }) = _ClaimDraft;

  const ClaimDraft._();
}
