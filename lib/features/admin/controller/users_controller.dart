import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersControllerProvider =
    Provider<UsersController>(UsersController.new);

class UsersController {
  UsersController(this._ref);

  // ignore: unused_field
  final Ref _ref;

  // TODO(roc): User invite and activation flows.
  // This feature is planned for future implementation. When implemented, it should:
  // 1. Allow admins to invite new users via email
  // 2. Handle user activation/deactivation workflows
  // 3. Manage user role assignments and permissions
  // 4. Send invitation emails via Supabase Auth or custom email service
}

