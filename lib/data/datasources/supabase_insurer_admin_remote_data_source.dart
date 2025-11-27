import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/insurer_row.dart';
import 'insurer_admin_remote_data_source.dart';

final insurerAdminRemoteDataSourceProvider =
    Provider<InsurerAdminRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseInsurerAdminRemoteDataSource(client);
});

class SupabaseInsurerAdminRemoteDataSource
    implements InsurerAdminRemoteDataSource {
  SupabaseInsurerAdminRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<InsurerRow>>> fetchInsurers() async {
    try {
      final response = await _client
          .from('insurers')
          .select(
            'id, tenant_id, name, contact_phone, contact_email, created_at, updated_at',
          )
          .order('name');

      final rows = (response as List<dynamic>)
          .map(
            (row) => InsurerRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList();
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> createInsurer({
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) async {
    try {
      final tenantId = await _resolveTenantId();
      if (tenantId == null) {
        return Result.err(
          const AuthError(code: 'not-authenticated', detail: 'No tenant context'),
        );
      }

      await _client.from('insurers').insert({
        'tenant_id': tenantId,
        'name': name.trim(),
        if (contactPhone != null && contactPhone.trim().isNotEmpty)
          'contact_phone': contactPhone.trim(),
        if (contactEmail != null && contactEmail.trim().isNotEmpty)
          'contact_email': contactEmail.trim(),
      });
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateInsurer({
    required String id,
    required String name,
    String? contactPhone,
    String? contactEmail,
  }) async {
    try {
      await _client.from('insurers').update({
        'name': name.trim(),
        'contact_phone':
            contactPhone != null && contactPhone.trim().isNotEmpty
                ? contactPhone.trim()
                : null,
        'contact_email':
            contactEmail != null && contactEmail.trim().isNotEmpty
                ? contactEmail.trim()
                : null,
      }).eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> deleteInsurer(String id) async {
    try {
      await _client.from('insurers').delete().eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<String?> _resolveTenantId() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return null;
    }
    try {
      final record = await _client
          .from('profiles')
          .select('tenant_id')
          .eq('id', user.id)
          .maybeSingle();
      if (record == null) {
        return null;
      }
      final map = Map<String, dynamic>.from(record as Map);
      final tenantId = (map['tenant_id'] as String?)?.trim();
      if (tenantId == null || tenantId.isEmpty) {
        return null;
      }
      return tenantId;
    } on PostgrestException {
      rethrow;
    } catch (_) {
      return null;
    }
  }
}

