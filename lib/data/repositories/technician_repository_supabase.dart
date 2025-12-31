import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/technician_repository.dart';
import '../clients/supabase_client.dart';
import '../datasources/supabase_technician_remote_data_source.dart';
import '../datasources/technician_remote_data_source.dart';

final technicianRepositoryProvider = Provider<TechnicianRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseTechnicianRemoteDataSource(client);
  return TechnicianRepositorySupabase(dataSource);
});

class TechnicianRepositorySupabase implements TechnicianRepository {
  TechnicianRepositorySupabase(this._remote);

  final TechnicianRemoteDataSource _remote;

  @override
  Future<Result<Map<String, int>>> fetchTechnicianAssignments({
    required DateTime date,
    int limit = 1000,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final assignments = await _remote.fetchTechnicianAssignments(
        dateStr: dateStr,
        limit: limit,
      );

      return Result.ok(assignments);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch technician assignments: $e',
        name: 'TechnicianRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch technician assignments: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Technician assignments data');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  @override
  Future<Result<TechnicianAvailability>> fetchTechnicianAvailability({
    required String technicianId,
    required DateTime date,
    int limit = 100,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final availability = await _remote.fetchTechnicianAvailability(
        technicianId: technicianId,
        dateStr: dateStr,
        limit: limit,
      );

      return Result.ok(availability);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch technician availability: $e',
        name: 'TechnicianRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch technician availability: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Technician availability data');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }
}

