import '../../core/utils/result.dart';
import '../models/user_account.dart';
import '../value_objects/role_type.dart';

abstract class UserAdminRepository {
  Future<Result<List<UserAccount>>> fetchUsers();

  Future<Result<List<UserAccount>>> fetchTechnicians();

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

