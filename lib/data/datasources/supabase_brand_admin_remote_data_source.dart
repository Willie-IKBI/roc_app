import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/brand_row.dart';
import 'brand_admin_remote_data_source.dart';

final brandAdminRemoteDataSourceProvider = Provider<BrandAdminRemoteDataSource>(
  (ref) {
    final client = ref.watch(supabaseClientProvider);
    return SupabaseBrandAdminRemoteDataSource(client);
  },
);

class SupabaseBrandAdminRemoteDataSource implements BrandAdminRemoteDataSource {
  SupabaseBrandAdminRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<BrandRow>>> fetchBrands() async {
    try {
      final response = await _client
          .from('brands')
          .select('id, tenant_id, name, created_at, updated_at')
          .order('name');

      final rows = (response as List)
          .map(
            (row) => BrandRow.fromJson(Map<String, dynamic>.from(row as Map)),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String>> createBrand({required String name}) async {
    try {
      final tenantId = await _resolveTenantId();
      if (tenantId == null) {
        return Result.err(
          const AuthError(
            code: 'not-authenticated',
            detail: 'Unable to determine tenant context',
          ),
        );
      }

      final response = await _client
          .from('brands')
          .insert({'tenant_id': tenantId, 'name': name.trim()})
          .select('id')
          .single();
      return Result.ok(response['id'] as String);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateBrand({
    required String id,
    required String name,
  }) async {
    try {
      await _client.from('brands').update({'name': name.trim()}).eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> deleteBrand(String id) async {
    try {
      await _client.from('brands').delete().eq('id', id);
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
