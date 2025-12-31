import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import '../../domain/value_objects/claim_enums.dart';
import 'map_view_remote_data_source.dart';

class SupabaseMapViewRemoteDataSource implements MapViewRemoteDataSource {
  SupabaseMapViewRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchMapClaims({
    Map<String, dynamic>? bounds,
    Map<String, dynamic>? dateRange,
    String? status,
    String? technicianId,
    bool? technicianAssignmentFilter,
    int limit = 500,
  }) async {
    try {
      // Validate and enforce limit
      final pageSize = limit.clamp(1, 1000);

      // Build query with minimal payload (only fields needed for map markers)
      var query = _client
          .from('claims')
          .select('''
            id,
            claim_number,
            status,
            technician_id,
            priority,
            sla_started_at,
            address:addresses!claims_address_id_fkey(
              lat,
              lng,
              street,
              suburb,
              city,
              province
            ),
            technician:profiles!claims_technician_id_fkey(
              full_name
            ),
            client:clients!claims_client_id_fkey(
              first_name,
              last_name
            )
          ''')
          // Exclude closed/cancelled
          .neq('status', ClaimStatus.closed.value)
          .neq('status', ClaimStatus.cancelled.value)
          // Require valid coordinates
          .not('address.lat', 'is', null)
          .not('address.lng', 'is', null);

      // Apply status filter
      if (status != null) {
        query = query.eq('status', status);
      }

      // Apply technician filter
      if (technicianId != null) {
        query = query.eq('technician_id', technicianId);
      }

      // Apply technician assignment filter
      if (technicianAssignmentFilter != null) {
        if (technicianAssignmentFilter == true) {
          query = query.not('technician_id', 'is', null);
        } else {
          query = query.isFilter('technician_id', null);
        }
      }

      // Apply bounds filter (geographic bounding box)
      if (bounds != null) {
        final north = bounds['north'] as double?;
        final south = bounds['south'] as double?;
        final east = bounds['east'] as double?;
        final west = bounds['west'] as double?;
        
        if (north != null && south != null && east != null && west != null) {
          query = query
              .gte('address.lat', south)
              .lte('address.lat', north)
              .gte('address.lng', west)
              .lte('address.lng', east);
        }
      }

      // Apply date range filter (if provided)
      if (dateRange != null) {
        final startDate = dateRange['startDate'] as DateTime?;
        final endDate = dateRange['endDate'] as DateTime?;
        
        if (startDate != null) {
          query = query.gte('created_at', startDate.toIso8601String());
        }
        if (endDate != null) {
          query = query.lte('created_at', endDate.toIso8601String());
        }
      }

      // Ordering: priority DESC (urgent first), then SLA (oldest first), then id (deterministic)
      final response = await query
          .order('priority', ascending: false)
          .order('sla_started_at', ascending: true)
          .order('id', ascending: true)
          .limit(pageSize);

      final data = response as List<dynamic>;
      final result = data.map((row) => row as Map<String, dynamic>).toList();

      // Warn if result is truncated (may have more than limit markers)
      if (result.length == pageSize) {
        AppLogger.warn(
          'Map view query returned exactly $pageSize markers. Result may be truncated. '
          'Consider using bounds filtering or increasing limit if this occurs frequently.',
          name: 'SupabaseMapViewRemoteDataSource',
        );
      }

      return result;
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch map claims: ${e.message}',
        name: 'SupabaseMapViewRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching map claims: $e',
        name: 'SupabaseMapViewRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

