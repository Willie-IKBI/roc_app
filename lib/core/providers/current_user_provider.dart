import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/clients/supabase_client.dart';
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

  final data = await client
      .from('profiles')
      .select('id, full_name, phone, role, is_active, tenant_id')
      .eq('id', user.id)
      .maybeSingle();

  if (data == null) {
    return Profile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.email ?? '',
      phone: null,
      role: 'agent',
      isActive: true,
      tenantId: '',
    );
  }

  final map = Map<String, dynamic>.from(data as Map);
  final isActive = (map['is_active'] as bool?) ?? true;
  if (!isActive) {
    return Profile(
      id: user.id,
      email: user.email ?? '',
      fullName: (map['full_name'] as String?)?.trim() ?? '',
      phone: (map['phone'] as String?)?.trim(),
      role: (map['role'] as String?) ?? 'agent',
      isActive: false,
      tenantId: (map['tenant_id'] as String?) ?? '',
    );
  }

  return Profile(
    id: user.id,
    email: user.email ?? '',
    fullName: (map['full_name'] as String?)?.trim() ?? '',
    phone: (map['phone'] as String?)?.trim(),
    role: (map['role'] as String?) ?? 'agent',
    isActive: true,
    tenantId: (map['tenant_id'] as String?) ?? '',
  );
}

