// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_item_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimItemRow _$ClaimItemRowFromJson(Map<String, dynamic> json) => ClaimItemRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  claimId: json['claim_id'] as String,
  brand: json['brand'] as String,
  color: json['color'] as String?,
  warranty: json['warranty'] as String,
  serialOrModel: json['serial_or_model'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ClaimItemRowToJson(ClaimItemRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'claim_id': instance.claimId,
      'brand': instance.brand,
      'color': instance.color,
      'warranty': instance.warranty,
      'serial_or_model': instance.serialOrModel,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
