import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/service_provider_row.dart';
import 'service_provider_admin_remote_data_source.dart';

final serviceProviderAdminRemoteDataSourceProvider =
    Provider<ServiceProviderAdminRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseServiceProviderAdminRemoteDataSource(client);
});

class SupabaseServiceProviderAdminRemoteDataSource
    implements ServiceProviderAdminRemoteDataSource {
  SupabaseServiceProviderAdminRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<ServiceProviderRow>>> fetchProviders() async {
    try {
      final response = await _client
          .from('service_providers')
          .select(
            'id, tenant_id, company_name, contact_name, contact_phone, contact_email, reference_number_format, created_at, updated_at',
          )
          .order('company_name');

      final rows = (response as List<dynamic>)
          .map(
            (row) => ServiceProviderRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
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
  Future<Result<String>> createProvider({
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  }) async {
    try {
      final payload = <String, dynamic>{
        'company_name': companyName.trim(),
        if (contactName != null && contactName.trim().isNotEmpty)
          'contact_name': contactName.trim(),
        if (contactPhone != null && contactPhone.trim().isNotEmpty)
          'contact_phone': contactPhone.trim(),
        if (contactEmail != null && contactEmail.trim().isNotEmpty)
          'contact_email': contactEmail.trim(),
        if (referenceNumberFormat != null &&
            referenceNumberFormat.trim().isNotEmpty)
          'reference_number_format': referenceNumberFormat.trim(),
      };

      final response = await _client
          .from('service_providers')
          .insert(payload)
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
  Future<Result<void>> updateProvider({
    required String id,
    required String companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  }) async {
    try {
      final payload = <String, dynamic>{
        'company_name': companyName.trim(),
        'contact_name': contactName?.trim(),
        'contact_phone': contactPhone?.trim(),
        'contact_email': contactEmail?.trim(),
        'reference_number_format': referenceNumberFormat?.trim(),
      };

      await _client
          .from('service_providers')
          .update(payload)
          .eq('id', id);

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> deleteProvider(String id) async {
    try {
      await _client.from('service_providers').delete().eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}


