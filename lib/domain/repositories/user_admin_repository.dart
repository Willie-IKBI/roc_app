import '../../core/utils/result.dart';
import '../models/user_account.dart';
import '../value_objects/role_type.dart';

import '../../core/utils/result.dart';
import '../models/profile.dart';
import '../models/user_account.dart';
import '../value_objects/role_type.dart';

abstract class UserAdminRepository {
  /// Fetch all users
  /// 
  /// [limit] - Maximum number of users to fetch (default: 200, max: 500)
  Future<Result<List<UserAccount>>> fetchUsers({int limit = 200});

  /// Fetch all technicians (active, role=technician)
  /// 
  /// [limit] - Maximum number of technicians to fetch (default: 200, max: 500)
  /// 
  /// Returns list of active technicians
  Future<Result<List<UserAccount>>> fetchTechnicians({
    int limit = 200,
  });

  /// Fetch a single user profile by ID
  /// 
  /// Returns the profile if found, null if not found.
  /// Errors are propagated (no silent failures).
  Future<Result<Profile?>> fetchUserById(String userId);

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

