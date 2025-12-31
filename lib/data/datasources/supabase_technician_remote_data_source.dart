import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import '../../domain/repositories/technician_repository.dart';
import 'technician_remote_data_source.dart';

class SupabaseTechnicianRemoteDataSource implements TechnicianRemoteDataSource {
  SupabaseTechnicianRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Map<String, int>> fetchTechnicianAssignments({
    required String dateStr,
    int limit = 1000,
  }) async {
    try {
      final pageSize = limit.clamp(1, 2000);

      var query = _client
          .from('claims')
          .select('technician_id') // Minimal payload
          .eq('appointment_date', dateStr)
          .not('technician_id', 'is', null)
          .order('technician_id', ascending: true) // Deterministic ordering
          .limit(pageSize);

      final data = await query;

      // Count assignments per technician
      final assignments = <String, int>{};
      for (final row in data as List<dynamic>) {
        final technicianId = row['technician_id'] as String?;
        if (technicianId != null) {
          assignments[technicianId] = (assignments[technicianId] ?? 0) + 1;
        }
      }

      // Warn if limit reached
      if (data.length >= pageSize) {
        AppLogger.warn(
          'fetchTechnicianAssignments() returned $pageSize results (limit reached). Some assignments may not be counted.',
          name: 'SupabaseTechnicianRemoteDataSource',
        );
      }

      return assignments;
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch technician assignments: ${e.message}',
        name: 'SupabaseTechnicianRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching technician assignments: $e',
        name: 'SupabaseTechnicianRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<TechnicianAvailability> fetchTechnicianAvailability({
    required String technicianId,
    required String dateStr,
    int limit = 100,
  }) async {
    try {
      final pageSize = limit.clamp(1, 200);

      var query = _client
          .from('claims')
          .select('id, appointment_time, status') // Minimal payload
          .eq('technician_id', technicianId)
          .eq('appointment_date', dateStr)
          .not('appointment_time', 'is', null)
          .order('appointment_time', ascending: true) // Deterministic ordering
          .limit(pageSize);

      final data = await query;

      final appointments = <AppointmentSlot>[];
      for (final row in data as List<dynamic>) {
        appointments.add(AppointmentSlot(
          claimId: row['id'] as String,
          appointmentTime: row['appointment_time'] as String,
          status: row['status'] as String,
        ));
      }

      // Warn if limit reached
      if (data.length >= pageSize) {
        AppLogger.warn(
          'fetchTechnicianAvailability() returned $pageSize results (limit reached). Some appointments may not be included.',
          name: 'SupabaseTechnicianRemoteDataSource',
        );
      }

      // Calculate available slots (client-side, same logic as current)
      final availableSlots = <String>[];
      final bookedTimes = appointments.map((a) => a.appointmentTime).toSet();

      for (int hour = 8; hour < 17; hour++) {
        final timeStr = '${hour.toString().padLeft(2, '0')}:00:00';
        if (!bookedTimes.contains(timeStr)) {
          availableSlots.add(timeStr);
        }
      }

      return TechnicianAvailability(
        technicianId: technicianId,
        date: DateTime.parse(dateStr),
        appointments: appointments,
        availableSlots: availableSlots,
        totalAppointments: appointments.length,
      );
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch technician availability: ${e.message}',
        name: 'SupabaseTechnicianRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching technician availability: $e',
        name: 'SupabaseTechnicianRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

