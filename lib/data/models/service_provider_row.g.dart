// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProviderRow _$ServiceProviderRowFromJson(Map<String, dynamic> json) =>
    ServiceProviderRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      companyName: json['company_name'] as String,
      contactName: json['contact_name'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      referenceNumberFormat: json['reference_number_format'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceProviderRowToJson(ServiceProviderRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'company_name': instance.companyName,
      'contact_name': instance.contactName,
      'contact_phone': instance.contactPhone,
      'contact_email': instance.contactEmail,
      'reference_number_format': instance.referenceNumberFormat,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
