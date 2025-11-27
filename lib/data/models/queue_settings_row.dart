import '../../domain/models/queue_settings.dart';

class QueueSettingsRow {
  const QueueSettingsRow({
    required this.id,
    required this.tenantId,
    required this.retryLimit,
    required this.retryIntervalMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QueueSettingsRow.fromJson(Map<String, dynamic> json) {
    return QueueSettingsRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      retryLimit: (json['retry_limit'] as num).toInt(),
      retryIntervalMinutes: (json['retry_interval_minutes'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String tenantId;
  final int retryLimit;
  final int retryIntervalMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  QueueSettings toDomain() => QueueSettings(
        id: id,
        tenantId: tenantId,
        retryLimit: retryLimit,
        retryIntervalMinutes: retryIntervalMinutes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

