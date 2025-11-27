import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/insurer.dart';
import '../../../data/repositories/insurer_admin_repository_supabase.dart';

part 'insurers_controller.g.dart';

@riverpod
class AdminInsurersController extends _$AdminInsurersController {
  @override
  Future<List<Insurer>> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> createInsurer({
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) async {
    final repo = ref.read(insurerAdminRepositoryProvider);
    final result = await repo.createInsurer(
      name: name,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
    );
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<void> updateInsurer({
    required String id,
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) async {
    final repo = ref.read(insurerAdminRepositoryProvider);
    final result = await repo.updateInsurer(
      id: id,
      name: name,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
    );
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<void> deleteInsurer(String id) async {
    final repo = ref.read(insurerAdminRepositoryProvider);
    final result = await repo.deleteInsurer(id);
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<List<Insurer>> _load() async {
    final repo = ref.read(insurerAdminRepositoryProvider);
    final result = await repo.fetchInsurers();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }
}

