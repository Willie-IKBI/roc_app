import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/profile_row.dart';
import '../../domain/value_objects/role_type.dart';
import 'user_admin_remote_data_source.dart';

final userAdminRemoteDataSourceProvider =
    Provider<UserAdminRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserAdminRemoteDataSource(client);
});

class SupabaseUserAdminRemoteDataSource implements UserAdminRemoteDataSource {
  SupabaseUserAdminRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<ProfileRow>>> fetchUsers() async {
    try {
      final response = await _client
          .from('profiles')
          .select(
            'id, tenant_id, full_name, phone, email, role, is_active, created_at, updated_at',
          )
          .order('full_name');

      final rows = (response as List<dynamic>)
          .map((row) => ProfileRow.fromJson(Map<String, dynamic>.from(row as Map)))
          .toList();
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateRole({
    required String userId,
    required RoleType role,
  }) async {
    try {
      await _client
          .from('profiles')
          .update({'role': role.value}).eq('id', userId);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateStatus({
    required String userId,
    required bool isActive,
  }) async {
    try {
      await _client
          .from('profiles')
          .update({'is_active': isActive}).eq('id', userId);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateDetails({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    try {
      await _client.from('profiles').update({
        'full_name': fullName.trim(),
        'phone': phone?.trim(),
      }).eq('id', userId);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> sendInvite({
    required String email,
    required RoleType role,
  }) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        emailRedirectTo: null,
        // store intended role in user metadata so welcome flow can apply.
        data: <String, dynamic>{
          'desired_role': role.value,
        },
      );
      return const Result.ok(null);
    } on AuthException catch (err) {
      return Result.err(
        AuthError(code: 'auth-invite', detail: err.message),
      );
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

