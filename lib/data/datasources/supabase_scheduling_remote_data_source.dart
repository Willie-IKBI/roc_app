import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import 'scheduling_remote_data_source.dart';

class SupabaseSchedulingRemoteDataSource implements SchedulingRemoteDataSource {
  SupabaseSchedulingRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchScheduleForDay({
    required DateTime date,
    String? technicianId,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];

      // Build query with all required joins
      var query = _client
          .from('claims')
          .select('''
            id,
            claim_number,
            technician_id,
            appointment_date,
            appointment_time,
            status,
            priority,
            estimated_duration_minutes,
            travel_time_minutes,
            client:clients!claims_client_id_fkey(
              first_name,
              last_name,
              primary_phone
            ),
            address:addresses!claims_address_id_fkey(
              id,
              street,
              suburb,
              city,
              province,
              lat,
              lng
            ),
            technician:profiles!claims_technician_id_fkey(
              id,
              full_name
            )
          ''')
          .eq('appointment_date', dateStr)
          .not('appointment_time', 'is', null);

      // Apply optional technician filter
      if (technicianId != null) {
        query = query.eq('technician_id', technicianId);
      }

      // Execute query with deterministic ordering and hard limit
      final response = await query
          .order('appointment_time', ascending: true)
          .order('id', ascending: true) // Tie-breaker for deterministic ordering
          .limit(200); // Hard limit: max 200 appointments per day

      final data = response as List<dynamic>;
      final result = data.map((row) => row as Map<String, dynamic>).toList();

      // Warn if result is truncated (may have more than 200 appointments)
      if (result.length == 200) {
        AppLogger.warn(
          'Schedule query returned exactly 200 appointments for $dateStr. '
          'Result may be truncated. Consider pagination if this occurs frequently.',
          name: 'SupabaseSchedulingRemoteDataSource',
        );
      }

      return result;
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch schedule for day: ${e.message}',
        name: 'SupabaseSchedulingRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching schedule for day: $e',
        name: 'SupabaseSchedulingRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

