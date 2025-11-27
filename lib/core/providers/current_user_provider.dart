import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/clients/supabase_client.dart';
import '../../domain/models/profile.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<AuthState> authChanges(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
}

@Riverpod(keepAlive: true)
Future<Profile?> currentUser(Ref ref) async {
  ref.watch(authChangesProvider);
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) {
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

