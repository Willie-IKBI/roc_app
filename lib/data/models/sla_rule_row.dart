import '../../domain/models/sla_rule.dart';

class SlaRuleRow {
  const SlaRuleRow({
    required this.id,
    required this.tenantId,
    required this.timeToFirstContactMinutes,
    required this.breachHighlight,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SlaRuleRow.fromJson(Map<String, dynamic> json) {
    return SlaRuleRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      timeToFirstContactMinutes:
          (json['time_to_first_contact_minutes'] as num).toInt(),
      breachHighlight: json['breach_highlight'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String tenantId;
  final int timeToFirstContactMinutes;
  final bool breachHighlight;
  final DateTime createdAt;
  final DateTime updatedAt;

  SlaRule toDomain() => SlaRule(
        id: id,
        tenantId: tenantId,
        timeToFirstContactMinutes: timeToFirstContactMinutes,
        breachHighlight: breachHighlight,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

