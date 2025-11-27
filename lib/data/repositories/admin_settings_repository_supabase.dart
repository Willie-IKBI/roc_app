import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/queue_settings.dart';
import '../../domain/models/sla_rule.dart';
import '../../domain/repositories/admin_settings_repository.dart';
import '../datasources/admin_settings_remote_data_source.dart';
import '../datasources/supabase_admin_settings_remote_data_source.dart';

final adminSettingsRepositoryProvider =
    Provider<AdminSettingsRepository>((ref) {
  final remote = ref.watch(adminSettingsRemoteDataSourceProvider);
  return AdminSettingsRepositorySupabase(remote);
});

class AdminSettingsRepositorySupabase implements AdminSettingsRepository {
  AdminSettingsRepositorySupabase(this._remote);

  final AdminSettingsRemoteDataSource _remote;

  @override
  Future<Result<SlaRule>> fetchSlaRule() async {
    final response = await _remote.fetchSlaRule();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.toDomain());
  }

  @override
  Future<Result<void>> updateSlaRule({
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
  }) {
    return _remote.updateSlaRule(
      timeToFirstContactMinutes: timeToFirstContactMinutes,
      breachHighlight: breachHighlight,
    );
  }

  @override
  Future<Result<QueueSettings>> fetchQueueSettings() async {
    final response = await _remote.fetchQueueSettings();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.toDomain());
  }

  @override
  Future<Result<void>> updateQueueSettings({
    required int retryLimit,
    required int retryIntervalMinutes,
  }) {
    return _remote.updateQueueSettings(
      retryLimit: retryLimit,
      retryIntervalMinutes: retryIntervalMinutes,
    );
  }
}

