import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/claim_repository_supabase.dart';
import '../domain/dashboard_state.dart';

part 'dashboard_controller.g.dart';

@Riverpod(keepAlive: true)
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardState> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<DashboardState> _load() async {
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.fetchQueue(status: null);
    if (result.isErr) {
      throw result.error;
    }
    return DashboardState.fromClaims(result.data);
  }
}

