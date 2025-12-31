import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/reference_option.dart';
import '../../domain/repositories/reference_data_repository.dart';
import '../clients/supabase_client.dart';
import '../repositories/estate_repository.dart';

final referenceDataRepositoryProvider =
    Provider<ReferenceDataRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final estateRepo = ref.watch(estateRepositoryProvider);
  return ReferenceDataRepositorySupabase(
    client: client,
    estateRepository: estateRepo,
  );
});

class ReferenceDataRepositorySupabase implements ReferenceDataRepository {
  ReferenceDataRepositorySupabase({
    required SupabaseClient client,
    required EstateRepository estateRepository,
  })  : _client = client,
        _estateRepository = estateRepository;

  final SupabaseClient _client;
  final EstateRepository _estateRepository;

  @override
  Future<Result<List<ReferenceOption>>> fetchInsurerOptions() async {
    try {
      // Query: SELECT id, name FROM insurers ORDER BY name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('insurers')
          .select('id, name')
          .order('name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch insurer options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching insurer options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchServiceProviderOptions() async {
    try {
      // Query: SELECT id, company_name FROM service_providers ORDER BY company_name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('service_providers')
          .select('id, company_name')
          .order('company_name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['company_name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch service provider options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching service provider options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchBrandOptions() async {
    try {
      // Query: SELECT id, name FROM brands ORDER BY name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('brands')
          .select('id, name')
          .order('name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch brand options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching brand options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchEstateOptions() async {
    try {
      // Reuse existing EstateRepository (already follows pattern)
      // Query handled by EstateRepository.fetchEstates()
      // Returns estates with formatted labels (name, suburb, city)
      final tenantId = await _resolveTenantId();
      if (tenantId == null) {
        return Result.err(
          const AuthError(code: 'not-authenticated', detail: 'No tenant context'),
        );
      }

      final result = await _estateRepository.fetchEstates(tenantId: tenantId);
      if (result.isErr) {
        return Result.err(result.error);
      }

      final options = result.data
          .map((estate) {
            // Format label: "Name, Suburb, City" (same logic as EstateOption.label)
            final parts = <String>[
              estate.name,
              if (estate.suburb?.trim().isNotEmpty ?? false) estate.suburb!,
              if (estate.city?.trim().isNotEmpty ?? false) estate.city!,
            ];
            final label = parts.where((p) => p.trim().isNotEmpty).join(', ');

            return ReferenceOption(
              id: estate.id,
              label: label,
            );
          })
          .toList(growable: false);

      return Result.ok(options);
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching estate options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  /// Resolve tenant_id from current user context
  /// Returns null if user not authenticated or profile missing
  Future<String?> _resolveTenantId() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final profile = await _client
          .from('profiles')
          .select('tenant_id')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) return null;
      // ignore: unnecessary_cast
      final profileMap = profile as Map<String, dynamic>;
      return profileMap['tenant_id'] as String?;
    } catch (_) {
      return null;
    }
  }
}

