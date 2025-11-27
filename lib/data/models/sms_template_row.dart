import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/sms_template.dart';

part 'sms_template_row.g.dart';

@JsonSerializable()
class SmsTemplateRow {
  SmsTemplateRow({
    required this.id,
    required this.tenantId,
    required this.name,
    this.description,
    required this.body,
    required this.isActive,
    required this.defaultForFollowUp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SmsTemplateRow.fromJson(Map<String, dynamic> json) =>
      _$SmsTemplateRowFromJson(json);

  Map<String, dynamic> toJson() => _$SmsTemplateRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final String name;

  final String? description;

  final String body;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'default_for_follow_up')
  final bool defaultForFollowUp;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  SmsTemplate toDomain() {
    return SmsTemplate(
      id: id,
      tenantId: tenantId,
      name: name,
      description: description,
      body: body,
      isActive: isActive,
      defaultForFollowUp: defaultForFollowUp,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}


