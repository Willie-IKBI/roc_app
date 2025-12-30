import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/user_account.dart';
import '../../domain/repositories/user_admin_repository.dart';
import '../../domain/value_objects/role_type.dart';
import '../datasources/supabase_user_admin_remote_data_source.dart';
import '../datasources/user_admin_remote_data_source.dart';

final userAdminRepositoryProvider = Provider<UserAdminRepository>((ref) {
  final remote = ref.watch(userAdminRemoteDataSourceProvider);
  return UserAdminRepositorySupabase(remote);
});

class UserAdminRepositorySupabase implements UserAdminRepository {
  UserAdminRepositorySupabase(this._remote);

  final UserAdminRemoteDataSource _remote;

  @override
  Future<Result<List<UserAccount>>> fetchUsers() async {
    final response = await _remote.fetchUsers();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Result<List<UserAccount>>> fetchTechnicians() async {
    final response = await _remote.fetchTechnicians();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Result<void>> updateRole({
    required String userId,
    required RoleType role,
  }) async {
    final result = await _remote.updateRole(userId: userId, role: role);
    if (result.isErr) return Result.err(result.error);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> updateStatus({
    required String userId,
    required bool isActive,
  }) async {
    final result =
        await _remote.updateStatus(userId: userId, isActive: isActive);
    if (result.isErr) return Result.err(result.error);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> updateDetails({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    final result = await _remote.updateDetails(
      userId: userId,
      fullName: fullName,
      phone: phone,
    );
    if (result.isErr) return Result.err(result.error);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> sendInvite({
    required String email,
    required RoleType role,
  }) async {
    final result = await _remote.sendInvite(email: email, role: role);
    if (result.isErr) return Result.err(result.error);
    return const Result.ok(null);
  }
}

