import '../../core/utils/result.dart';
import '../models/queue_settings_row.dart';
import '../models/sla_rule_row.dart';

abstract class AdminSettingsRemoteDataSource {
  Future<Result<SlaRuleRow>> fetchSlaRule();

  Future<Result<void>> updateSlaRule({
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
  });

  Future<Result<QueueSettingsRow>> fetchQueueSettings();

  Future<Result<void>> updateQueueSettings({
    required int retryLimit,
    required int retryIntervalMinutes,
  });
}

