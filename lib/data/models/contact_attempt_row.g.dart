// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_attempt_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactAttemptRow _$ContactAttemptRowFromJson(Map<String, dynamic> json) =>
    ContactAttemptRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      claimId: json['claim_id'] as String,
      attemptedBy: json['attempted_by'] as String,
      attemptedAt: DateTime.parse(json['attempted_at'] as String),
      method: json['method'] as String,
      outcome: json['outcome'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ContactAttemptRowToJson(ContactAttemptRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'claim_id': instance.claimId,
      'attempted_by': instance.attemptedBy,
      'attempted_at': instance.attemptedAt.toIso8601String(),
      'method': instance.method,
      'outcome': instance.outcome,
      'notes': instance.notes,
    };
