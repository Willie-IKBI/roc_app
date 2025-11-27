// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsTemplate _$SmsTemplateFromJson(Map<String, dynamic> json) => SmsTemplate(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  body: json['body'] as String,
  isActive: json['isActive'] as bool,
  defaultForFollowUp: json['defaultForFollowUp'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SmsTemplateToJson(SmsTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'name': instance.name,
      'description': instance.description,
      'body': instance.body,
      'isActive': instance.isActive,
      'defaultForFollowUp': instance.defaultForFollowUp,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
