import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim.dart';
import '../../../domain/models/contact_attempt_input.dart';
import '../../../domain/value_objects/claim_enums.dart';
import 'queue_controller.dart';

part 'detail_controller.g.dart';

@Riverpod(keepAlive: true)
class ClaimDetailController extends _$ClaimDetailController {
  @override
  Future<Claim> build(String claimId) async {
    return _load(claimId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(claimId));
  }

  Future<Claim> _load(String claimId) async {
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.fetchById(claimId);
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }

  Future<void> addContactAttempt({
    required String claimId,
    required ContactAttemptInput input,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.addContactAttempt(
      claimId: claimId,
      draft: input,
    );
    if (result.isErr) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(result.data);
      ref.invalidate(claimsQueueControllerProvider());
    }
  }

  Future<void> changeStatus({
    required String claimId,
    required ClaimStatus newStatus,
    String? reason,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.changeStatus(
      claimId: claimId,
      newStatus: newStatus,
      reason: reason,
    );
    if (result.isErr) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(result.data);
      ref.invalidate(claimsQueueControllerProvider());
    }
  }

  Future<void> updateTechnician({
    required String claimId,
    String? technicianId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.updateTechnician(
      claimId: claimId,
      technicianId: technicianId,
    );
    if (result.isErr) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(result.data);
      ref.invalidate(claimsQueueControllerProvider());
    }
  }

  Future<void> updateAppointment({
    required String claimId,
    DateTime? appointmentDate,
    String? appointmentTime,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(claimRepositoryProvider);
    final result = await repository.updateAppointment(
      claimId: claimId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
    );
    if (result.isErr) {
      state = AsyncError(result.error, StackTrace.current);
    } else {
      state = AsyncData(result.data);
      ref.invalidate(claimsQueueControllerProvider());
    }
  }
}

