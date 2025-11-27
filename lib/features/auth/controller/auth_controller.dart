import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/clients/supabase_client.dart';

part 'auth_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final auth = ref.read(supabaseClientProvider).auth;
    try {
      await auth.signInWithPassword(email: email, password: password);
      state = const AsyncData(null);
    } on AuthException catch (error, stack) {
      state = AsyncError(error, stack);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

@riverpod
class SignUpController extends _$SignUpController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = const AsyncLoading();
    final auth = ref.read(supabaseClientProvider).auth;
    try {
      await auth.signUp(
        email: email,
        password: password,
        data: fullName == null || fullName.isEmpty
            ? null
            : {'full_name': fullName},
      );
      state = const AsyncData(null);
    } on AuthException catch (error, stack) {
      state = AsyncError(error, stack);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

@riverpod
class PasswordResetRequestController extends _$PasswordResetRequestController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email}) async {
    state = const AsyncLoading();
    final auth = ref.read(supabaseClientProvider).auth;
    try {
      final redirectTo = kIsWeb
          ? Uri(
              scheme: Uri.base.scheme,
              host: Uri.base.host,
              port: Uri.base.hasPort ? Uri.base.port : null,
              path: '/reset-password',
            ).toString()
          : null;
      await auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
      state = const AsyncData(null);
    } on AuthException catch (error, stack) {
      state = AsyncError(error, stack);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

@riverpod
class PasswordResetController extends _$PasswordResetController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String newPassword,
    String? refreshToken,
  }) async {
    state = const AsyncLoading();
    final auth = ref.read(supabaseClientProvider).auth;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        // Establish a session using the tokens delivered by the recovery email.
        await auth.setSession(refreshToken);
      }
      await auth.updateUser(UserAttributes(password: newPassword));
      state = const AsyncData(null);
    } on AuthException catch (error, stack) {
      state = AsyncError(error, stack);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

