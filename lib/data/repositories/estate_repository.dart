import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../../domain/models/estate.dart';
import '../clients/supabase_client.dart';
import '../models/estate_row.dart';

final estateRepositoryProvider = Provider<EstateRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EstateRepository(client);
});

class EstateRepository {
  EstateRepository(this._client);

  final SupabaseClient _client;

  Future<Result<List<Estate>>> fetchEstates({required String tenantId}) async {
    try {
      final data = await _client
          .from('estates')
          .select('*')
          .eq('tenant_id', tenantId)
          .order('name');
      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(EstateRow.fromJson)
          .map((row) => row.toDomain())
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<Estate>> createEstate({
    required String tenantId,
    required EstateInput input,
  }) async {
    try {
      final payload = <String, dynamic>{
        'tenant_id': tenantId,
        'name': input.name.trim(),
        if (input.suburb?.trim().isNotEmpty ?? false) 'suburb': input.suburb!.trim(),
        if (input.city?.trim().isNotEmpty ?? false) 'city': input.city!.trim(),
        if (input.province?.trim().isNotEmpty ?? false)
          'province': input.province!.trim(),
        if (input.postalCode?.trim().isNotEmpty ?? false)
          'postal_code': input.postalCode!.trim(),
      };

      final record =
          await _client.from('estates').insert(payload).select('*').single();

      return Result.ok(
        EstateRow.fromJson(Map<String, dynamic>.from(record as Map)).toDomain(),
      );
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

