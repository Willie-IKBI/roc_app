import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim_draft.dart';

part 'capture_controller.g.dart';

@riverpod
class ClaimCaptureController extends _$ClaimCaptureController {
  @override
  Future<String?> build() async => null;

  Future<void> submit(ClaimDraft draft) async {
    state = const AsyncLoading();
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.createClaim(draft: draft);
    if (result.isErr) {
      state = AsyncError(result.error, StackTrace.current);
      return;
    }
    state = AsyncData(result.data);
  }

  void reset() {
    state = const AsyncData(null);
  }
}

