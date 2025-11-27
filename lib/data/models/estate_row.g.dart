// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estate_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EstateRow _$EstateRowFromJson(Map<String, dynamic> json) => EstateRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  name: json['name'] as String,
  suburb: json['suburb'] as String?,
  city: json['city'] as String?,
  province: json['province'] as String?,
  postalCode: json['postal_code'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$EstateRowToJson(EstateRow instance) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'name': instance.name,
  'suburb': instance.suburb,
  'city': instance.city,
  'province': instance.province,
  'postal_code': instance.postalCode,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
