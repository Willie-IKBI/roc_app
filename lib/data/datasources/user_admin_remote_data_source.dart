import '../../core/utils/result.dart';
import '../models/profile_row.dart';
import '../../domain/value_objects/role_type.dart';

abstract class UserAdminRemoteDataSource {
  /// Fetch all users
  /// 
  /// [limit] - Maximum number of users to fetch (default: 200, max: 500)
  Future<Result<List<ProfileRow>>> fetchUsers({int limit = 200});

  Future<Result<List<ProfileRow>>> fetchTechnicians({int limit = 200});

  /// Fetch a single user profile by ID
  /// 
  /// Returns the profile row if found, null if not found.
  /// Errors are propagated (no silent failures).
  Future<Result<ProfileRow?>> fetchUserById(String userId);

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

