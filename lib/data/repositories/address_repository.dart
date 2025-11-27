import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../../domain/models/address.dart';
import '../clients/supabase_client.dart';
import '../models/address_row.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AddressRepository(client);
});

class AddressRepository {
  AddressRepository(this._client);

  final SupabaseClient _client;

  Future<Result<Address?>> findByPlaceId({
    required String tenantId,
    required String clientId,
    required String placeId,
    String? unitNumber,
  }) async {
    try {
      final query = _client
          .from('addresses')
          .select('*, estate:estate_id(*)')
          .eq('tenant_id', tenantId)
          .eq('client_id', clientId)
          .eq('google_place_id', placeId);

      if (unitNumber != null && unitNumber.trim().isNotEmpty) {
        query.eq('unit_number', unitNumber.trim());
      }

      final data = await query.limit(1).maybeSingle();
      if (data == null) {
        return const Result.ok(null);
      }
      final row = AddressRow.fromJson(Map<String, dynamic>.from(data as Map));
      return Result.ok(row.toDomain());
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

