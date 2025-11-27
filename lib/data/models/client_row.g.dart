// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientRow _$ClientRowFromJson(Map<String, dynamic> json) => ClientRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  primaryPhone: json['primary_phone'] as String,
  altPhone: json['alt_phone'] as String?,
  email: json['email'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ClientRowToJson(ClientRow instance) => <String, dynamic>{
  'id': instance.id,
  'tenant_id': instance.tenantId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'primary_phone': instance.primaryPhone,
  'alt_phone': instance.altPhone,
  'email': instance.email,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
