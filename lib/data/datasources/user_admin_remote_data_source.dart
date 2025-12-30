import '../../core/utils/result.dart';
import '../models/profile_row.dart';
import '../../domain/value_objects/role_type.dart';

abstract class UserAdminRemoteDataSource {
  Future<Result<List<ProfileRow>>> fetchUsers();

  Future<Result<List<ProfileRow>>> fetchTechnicians();

  Future<Result<void>> updateRole({
    required String userId,
    required RoleType role,
  });

  Future<Result<void>> updateStatus({
    required String userId,
    required bool isActive,
  });

  Future<Result<void>> updateDetails({
    required String userId,
    required String fullName,
    String? phone,
  });

  Future<Result<void>> sendInvite({
    required String email,
    required RoleType role,
  });
}

