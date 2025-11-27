import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';

part 'queue_controller.g.dart';

@Riverpod(keepAlive: true)
class ClaimsQueueController extends _$ClaimsQueueController {
  @override
  Future<List<ClaimSummary>> build({ClaimStatus? status}) async {
    return _load(status);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(status));
  }

  Future<List<ClaimSummary>> _load(ClaimStatus? filter) async {
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.fetchQueue(status: filter);
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }
}

