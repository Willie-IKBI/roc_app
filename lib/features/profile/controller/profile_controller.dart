import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/domain_error.dart';
import '../../../data/clients/supabase_client.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../domain/models/profile.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  Future<Profile> build() async {
    return _fetchProfile();
  }

  Future<void> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    final previous = state.maybeWhen(
      data: (profile) => profile,
      orElse: () => null,
    ) ??
        await future;
    state = const AsyncLoading();
    final repository = ref.read(userAdminRepositoryProvider);
    final trimmedName = fullName.trim();
    final trimmedPhone = phone?.trim().isEmpty ?? true ? null : phone!.trim();

    try {
      final result = await repository.updateDetails(
        userId: previous.id,
        fullName: trimmedName,
        phone: trimmedPhone,
      );

      if (result.isErr) {
        // Map DomainError to exception for backward compatibility
        final error = _mapDomainErrorToException(result.error);
        state = AsyncError(error, StackTrace.current);
        throw error;
      }

      state = AsyncData(
        previous.copyWith(
          fullName: trimmedName,
          phone: trimmedPhone,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfile);
  }

  Future<Profile> _fetchProfile() async {
    final client = ref.watch(supabaseClientProvider);
    final user = client.auth.currentUser;
    if (user == null) {
      throw const AuthException('not-authenticated');
    }

    final repository = ref.watch(userAdminRepositoryProvider);
    final result = await repository.fetchUserById(user.id);

    if (result.isErr) {
      // Map DomainError to AuthException for backward compatibility
      final error = _mapDomainErrorToException(result.error);
      throw error;
    }

    final profile = result.data;
    if (profile == null) {
      throw const AuthException('profile-missing');
    }

    // Preserve behavior: ensure email is populated from auth user if missing in profile
    return Profile(
      id: profile.id,
      email: user.email ?? profile.email,
      fullName: profile.fullName,
      phone: profile.phone,
      role: profile.role,
      isActive: profile.isActive,
      tenantId: profile.tenantId,
    );
  }

  /// Maps DomainError to AuthException for backward compatibility
  /// 
  /// Preserves existing exception behavior for consumers.
  AuthException _mapDomainErrorToException(DomainError error) {
    if (error is AuthError) {
      return AuthException(error.detail ?? error.message);
    }
    if (error is PermissionDeniedError) {
      return AuthException('permission-denied: ${error.message}');
    }
    if (error is NotFoundError) {
      return AuthException('profile-missing: ${error.message}');
    }
    // For other errors, wrap in AuthException to maintain backward compatibility
    return AuthException('unknown: ${error.message}');
  }
}

