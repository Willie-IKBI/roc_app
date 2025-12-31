import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/claim_summary.dart';
import '../../domain/models/paginated_result.dart';
import '../../domain/repositories/assignments_repository.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../datasources/assignments_remote_data_source.dart';
import '../datasources/supabase_assignments_remote_data_source.dart';
import '../models/claim_summary_row.dart';

final assignmentsRepositoryProvider = Provider<AssignmentsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseAssignmentsRemoteDataSource(client);
  return AssignmentsRepositorySupabase(dataSource);
});

class AssignmentsRepositorySupabase implements AssignmentsRepository {
  AssignmentsRepositorySupabase(this._remote);

  final AssignmentsRemoteDataSource _remote;

  @override
  Future<Result<PaginatedResult<ClaimSummary>>> fetchAssignableJobsPage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
    bool? assignedFilter,
    String? technicianId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      // Convert domain models to data source format
      final dateFromStr = dateFrom?.toIso8601String().split('T')[0];
      final dateToStr = dateTo?.toIso8601String().split('T')[0];

      final page = await _remote.fetchAssignableJobsPage(
        cursor: cursor,
        limit: limit,
        status: status?.value,
        assignedFilter: assignedFilter,
        technicianId: technicianId,
        dateFrom: dateFromStr,
        dateTo: dateToStr,
      );

      // Map ClaimSummaryRow to ClaimSummary domain models
      final items = page.items.map((row) => row.toDomain()).toList();

      return Result.ok(
        PaginatedResult(
          items: items,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch assignable jobs page: $e',
        name: 'AssignmentsRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch assignable jobs: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Assignable jobs data');
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

