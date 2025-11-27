import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/clients/supabase_client.dart';
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
    final client = ref.read(supabaseClientProvider);
    final trimmedName = fullName.trim();
    final trimmedPhone = phone?.trim().isEmpty ?? true ? null : phone!.trim();

    try {
      await client.from('profiles').update({
        'full_name': trimmedName,
        'phone': trimmedPhone,
      }).eq('id', previous.id);

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

    final data = await client
        .from('profiles')
        .select('id, full_name, phone, role, is_active, tenant_id')
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      throw const AuthException('profile-missing');
    }

    final map = Map<String, dynamic>.from(data as Map);
    final isActive = (map['is_active'] as bool?) ?? true;
    return Profile(
      id: user.id,
      email: user.email ?? '',
      fullName: (map['full_name'] as String?)?.trim() ?? '',
      phone: (map['phone'] as String?)?.trim(),
      role: (map['role'] as String?) ?? 'agent',
      isActive: isActive,
      tenantId: (map['tenant_id'] as String?) ?? '',
    );
  }
}

