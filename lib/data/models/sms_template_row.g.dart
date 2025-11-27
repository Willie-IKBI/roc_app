// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_template_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsTemplateRow _$SmsTemplateRowFromJson(Map<String, dynamic> json) =>
    SmsTemplateRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      body: json['body'] as String,
      isActive: json['is_active'] as bool,
      defaultForFollowUp: json['default_for_follow_up'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SmsTemplateRowToJson(SmsTemplateRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'name': instance.name,
      'description': instance.description,
      'body': instance.body,
      'is_active': instance.isActive,
      'default_for_follow_up': instance.defaultForFollowUp,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
