import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/sla_rule.dart';
import '../../../data/repositories/admin_settings_repository_supabase.dart';

part 'sla_rules_controller.g.dart';

@riverpod
class SlaRulesController extends _$SlaRulesController {
  @override
  Future<SlaRule> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> save({
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
  }) async {
    final repo = ref.read(adminSettingsRepositoryProvider);
    final result = await repo.updateSlaRule(
      timeToFirstContactMinutes: timeToFirstContactMinutes,
      breachHighlight: breachHighlight,
    );
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<SlaRule> _load() async {
    final repo = ref.read(adminSettingsRepositoryProvider);
    final result = await repo.fetchSlaRule();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }
}

