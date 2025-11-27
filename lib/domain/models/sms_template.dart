import 'package:json_annotation/json_annotation.dart';

part 'sms_template.g.dart';

@JsonSerializable()
class SmsTemplate {
  const SmsTemplate({
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

  factory SmsTemplate.fromJson(Map<String, dynamic> json) =>
      _$SmsTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$SmsTemplateToJson(this);

  final String id;
  final String tenantId;
  final String name;
  final String? description;
  final String body;
  final bool isActive;
  final bool defaultForFollowUp;
  final DateTime createdAt;
  final DateTime updatedAt;

  SmsTemplate copyWith({
    String? name,
    String? description,
    String? body,
    bool? isActive,
    bool? defaultForFollowUp,
  }) {
    return SmsTemplate(
      id: id,
      tenantId: tenantId,
      name: name ?? this.name,
      description: description ?? this.description,
      body: body ?? this.body,
      isActive: isActive ?? this.isActive,
      defaultForFollowUp:
          defaultForFollowUp ?? this.defaultForFollowUp,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}


