import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersControllerProvider =
    Provider<UsersController>(UsersController.new);

class UsersController {
  UsersController(this._ref);

  // ignore: unused_field
  final Ref _ref;

  // TODO(roc): manage user invite and activation flows.
}

