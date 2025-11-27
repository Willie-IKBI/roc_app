import '../../core/utils/result.dart';
import '../models/queue_settings.dart';
import '../models/sla_rule.dart';

abstract class AdminSettingsRepository {
  Future<Result<SlaRule>> fetchSlaRule();

  Future<Result<void>> updateSlaRule({
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
  });

  Future<Result<QueueSettings>> fetchQueueSettings();

  Future<Result<void>> updateQueueSettings({
    required int retryLimit,
    required int retryIntervalMinutes,
  });
}

