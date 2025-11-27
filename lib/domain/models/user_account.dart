import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/role_type.dart';

part 'user_account.freezed.dart';

@freezed
abstract class UserAccount with _$UserAccount {
  const factory UserAccount({
    required String id,
    required String email,
    required String fullName,
    String? phone,
    required RoleType role,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserAccount;
}

