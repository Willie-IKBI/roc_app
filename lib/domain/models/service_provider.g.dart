// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    ServiceProvider(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      companyName: json['companyName'] as String,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      referenceNumberFormat: json['referenceNumberFormat'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'companyName': instance.companyName,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'referenceNumberFormat': instance.referenceNumberFormat,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
