import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/clients/supabase_client.dart';
import '../../data/repositories/user_admin_repository_supabase.dart';
import '../../domain/models/profile.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<AuthState> authChanges(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange.map((authState) {
    // Log auth state changes for debugging token expiration issues
    developer.log(
      'Auth state changed: ${authState.event.name} - User: ${authState.session?.user.id ?? 'null'}',
      name: 'AuthState',
    );
    
    // Log specific events that might indicate token expiration
    if (authState.event == AuthChangeEvent.signedOut) {
      developer.log(
        'User signed out. Session expired: ${authState.session == null}',
        name: 'AuthState',
      );
    } else if (authState.event == AuthChangeEvent.tokenRefreshed) {
      developer.log(
        'Token refreshed successfully',
        name: 'AuthState',
      );
    }
    
    return authState;
  });
}

/// Tracks whether the last logout was due to token expiration
@riverpod
class SessionExpirationReason extends _$SessionExpirationReason {
  @override
  bool build() => false;
  
  void setExpired(bool expired) {
    state = expired;
  }
}

@Riverpod(keepAlive: true)
Future<Profile?> currentUser(Ref ref) async {
  ref.watch(authChangesProvider);
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  
  // If user is null, check if we can recover the session
  if (user == null) {
    final session = client.auth.currentSession;
    if (session != null) {
      // Session exists but user is null - might be a transient issue
      developer.log(
        'User is null but session exists, attempting to recover',
        name: 'CurrentUser',
      );
      // The session will be validated by Supabase on next request
    }
    return null;
  }

  // Fetch profile using repository (no direct Supabase calls)
  final repository = ref.watch(userAdminRepositoryProvider);
  final result = await repository.fetchUserById(user.id);

  if (result.isErr) {
    // Propagate error as AsyncError (no silent failure)
    developer.log(
      'Error fetching user profile: ${result.error}',
      name: 'CurrentUser',
      error: result.error,
    );
    throw result.error;
  }

  final profile = result.data;
  
  // If profile not found, return null (preserve existing behavior for not-logged-in case)
  if (profile == null) {
    return null;
  }

  // Ensure email is populated from auth user if missing in profile
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

