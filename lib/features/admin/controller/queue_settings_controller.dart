import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/queue_settings.dart';
import '../../../data/repositories/admin_settings_repository_supabase.dart';

part 'queue_settings_controller.g.dart';

@riverpod
class QueueSettingsController extends _$QueueSettingsController {
  @override
  Future<QueueSettings> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> save({
    required int retryLimit,
    required int retryIntervalMinutes,
  }) async {
    final repo = ref.read(adminSettingsRepositoryProvider);
    final result = await repo.updateQueueSettings(
      retryLimit: retryLimit,
      retryIntervalMinutes: retryIntervalMinutes,
    );
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<QueueSettings> _load() async {
    final repo = ref.read(adminSettingsRepositoryProvider);
    final result = await repo.fetchQueueSettings();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }
}

