import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import '../../domain/models/paginated_result.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../models/claim_summary_row.dart';
import 'assignments_remote_data_source.dart';

class SupabaseAssignmentsRemoteDataSource implements AssignmentsRemoteDataSource {
  SupabaseAssignmentsRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<PaginatedResult<ClaimSummaryRow>> fetchAssignableJobsPage({
    String? cursor,
    int limit = 50,
    String? status,
    bool? assignedFilter,
    String? technicianId,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      // Validate and enforce limit
      final pageSize = limit.clamp(1, 100);

      // Build query using v_claims_list view for minimal payload
      var query = _client
          .from('v_claims_list')
          .select('*')
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value);

      // Apply status filter (server-side)
      if (status != null) {
        query = query.eq('status', status);
      }

      // Apply assigned/unassigned filter (server-side)
      if (assignedFilter != null) {
        if (assignedFilter == true) {
          // Only assigned claims
          query = query.not('technician_id', 'is', null);
        } else {
          // Only unassigned claims
          query = query.isFilter('technician_id', null);
        }
      }

      // Apply technician filter (server-side)
      if (technicianId != null) {
        query = query.eq('technician_id', technicianId);
      }

      // Apply appointment date range filter (server-side)
      if (dateFrom != null) {
        query = query.gte('appointment_date', dateFrom);
      }
      if (dateTo != null) {
        query = query.lte('appointment_date', dateTo);
      }

      // Apply cursor for pagination (same pattern as Claims Queue)
      if (cursor != null && cursor.isNotEmpty) {
        final parts = cursor.split('|');
        if (parts.length == 2) {
          final cursorSlaStartedAt = DateTime.parse(parts[0]);
          final cursorClaimId = parts[1];

          // PostgREST filter: (sla_started_at > cursor) OR
          //                  (sla_started_at = cursor AND claim_id > cursor_id)
          query = query.or(
            'sla_started_at.gt.$cursorSlaStartedAt,sla_started_at.eq.$cursorSlaStartedAt.claim_id.gt.$cursorClaimId',
          );
        } else {
          // Invalid cursor format - treat as first page
          AppLogger.warn(
            'Invalid cursor format: $cursor. Fetching first page.',
            name: 'SupabaseAssignmentsRemoteDataSource',
          );
        }
      }

      // Apply ordering and limit (chain directly to avoid type mismatch)
      final data = await query
          .order('sla_started_at', ascending: true)
          .order('claim_id', ascending: true)
          .limit(pageSize + 1); // Fetch limit + 1 to detect if more data exists

      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ClaimSummaryRow.fromJson)
          .toList();

      // Check if we have more data
      final hasMore = rows.length > pageSize;
      final items = hasMore ? rows.take(pageSize).toList(growable: false) : rows;

      // Generate next cursor from last item
      String? nextCursor;
      if (items.isNotEmpty) {
        final lastItem = items.last;
        nextCursor = '${lastItem.slaStartedAt.toIso8601String()}|${lastItem.claimId}';
      }

      return PaginatedResult(
        items: items,
        nextCursor: nextCursor,
        hasMore: hasMore,
      );
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch assignable jobs page: ${e.message}',
        name: 'SupabaseAssignmentsRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching assignable jobs page: $e',
        name: 'SupabaseAssignmentsRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

