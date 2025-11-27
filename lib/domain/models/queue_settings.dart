import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_settings.freezed.dart';

@freezed
abstract class QueueSettings with _$QueueSettings {
  const factory QueueSettings({
    required String id,
    required String tenantId,
    required int retryLimit,
    required int retryIntervalMinutes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QueueSettings;
}

