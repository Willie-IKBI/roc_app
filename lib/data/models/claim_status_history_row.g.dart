// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_status_history_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimStatusHistoryRow _$ClaimStatusHistoryRowFromJson(
  Map<String, dynamic> json,
) => ClaimStatusHistoryRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  claimId: json['claim_id'] as String,
  fromStatus: json['from_status'] as String,
  toStatus: json['to_status'] as String,
  changedBy: json['changed_by'] as String?,
  changedAt: DateTime.parse(json['changed_at'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ClaimStatusHistoryRowToJson(
  ClaimStatusHistoryRow instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'claim_id': instance.claimId,
  'from_status': instance.fromStatus,
  'to_status': instance.toStatus,
  'changed_by': instance.changedBy,
  'changed_at': instance.changedAt.toIso8601String(),
  'reason': instance.reason,
};
