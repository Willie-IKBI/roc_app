// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandRow _$BrandRowFromJson(Map<String, dynamic> json) => BrandRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$BrandRowToJson(BrandRow instance) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
