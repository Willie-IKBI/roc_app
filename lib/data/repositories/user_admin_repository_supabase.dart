import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/profile.dart';
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
  Future<Result<List<UserAccount>>> fetchUsers({int limit = 200}) async {
    final response = await _remote.fetchUsers(limit: limit);
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Result<List<UserAccount>>> fetchTechnicians({
    int limit = 200,
  }) async {
    final response = await _remote.fetchTechnicians(limit: limit);
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(response.data.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Result<Profile?>> fetchUserById(String userId) async {
    final response = await _remote.fetchUserById(userId);
    if (response.isErr) {
      return Result.err(response.error);
    }

    final row = response.data;
    if (row == null) {
      return const Result.ok(null);
    }

    // Map ProfileRow to Profile domain model
    return Result.ok(
      Profile(
        id: row.id,
        email: row.email,
        fullName: row.fullName,
        phone: row.phone,
        role: row.role,
        isActive: row.isActive,
        tenantId: row.tenantId,
      ),
    );
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

