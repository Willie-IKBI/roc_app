// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimRow _$ClaimRowFromJson(Map<String, dynamic> json) => ClaimRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  claimNumber: json['claim_number'] as String,
  insurerId: json['insurer_id'] as String,
  clientId: json['client_id'] as String,
  addressId: json['address_id'] as String,
  serviceProviderId: json['service_provider_id'] as String?,
  dasNumber: json['das_number'] as String?,
  status: json['status'] as String,
  priority: json['priority'] as String,
  damageCause: json['damage_cause'] as String,
  damageDescription: json['damage_description'] as String?,
  surgeProtectionAtDb: json['surge_protection_at_db'] as bool,
  surgeProtectionAtPlug: json['surge_protection_at_plug'] as bool,
  agentId: json['agent_id'] as String?,
  slaStartedAt: DateTime.parse(json['sla_started_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  notesPublic: json['notes_public'] as String?,
  notesInternal: json['notes_internal'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ClaimRowToJson(ClaimRow instance) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'claim_number': instance.claimNumber,
  'insurer_id': instance.insurerId,
  'client_id': instance.clientId,
  'address_id': instance.addressId,
  'service_provider_id': instance.serviceProviderId,
  'das_number': instance.dasNumber,
  'status': instance.status,
  'priority': instance.priority,
  'damage_cause': instance.damageCause,
  'damage_description': instance.damageDescription,
  'surge_protection_at_db': instance.surgeProtectionAtDb,
  'surge_protection_at_plug': instance.surgeProtectionAtPlug,
  'agent_id': instance.agentId,
  'sla_started_at': instance.slaStartedAt.toIso8601String(),
  'closed_at': instance.closedAt?.toIso8601String(),
  'notes_public': instance.notesPublic,
  'notes_internal': instance.notesInternal,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
