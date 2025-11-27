import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/user_account.dart';
import '../../../domain/value_objects/role_type.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';

part 'admin_users_controller.g.dart';

@riverpod
class AdminUsersController extends _$AdminUsersController {
  @override
  Future<List<UserAccount>> build() async {
    return _load();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> changeRole({
    required String userId,
    required RoleType role,
  }) async {
    final repo = ref.read(userAdminRepositoryProvider);
    final result = await repo.updateRole(userId: userId, role: role);
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<void> toggleActive({
    required String userId,
    required bool isActive,
  }) async {
    final repo = ref.read(userAdminRepositoryProvider);
    final result = await repo.updateStatus(userId: userId, isActive: isActive);
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<void> invite({
    required String email,
    required RoleType role,
  }) async {
    final repo = ref.read(userAdminRepositoryProvider);
    final result = await repo.sendInvite(email: email, role: role);
    if (result.isErr) {
      throw result.error;
    }
  }

  Future<void> updateDetails({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    final repo = ref.read(userAdminRepositoryProvider);
    final result = await repo.updateDetails(
      userId: userId,
      fullName: fullName,
      phone: phone,
    );
    if (result.isErr) {
      throw result.error;
    }
    await refresh();
  }

  Future<List<UserAccount>> _load() async {
    final repo = ref.read(userAdminRepositoryProvider);
    final result = await repo.fetchUsers();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }
}

