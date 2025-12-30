import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/user_account.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../data/clients/supabase_client.dart';

part 'technician_controller.g.dart';

@riverpod
Future<List<UserAccount>> technicians(Ref ref) async {
  final repository = ref.watch(userAdminRepositoryProvider);
  final result = await repository.fetchTechnicians();
  if (result.isErr) {
    throw result.error;
  }
  return result.data;
}

@riverpod
Future<Map<String, int>> technicianAssignments(
  Ref ref, {
  required DateTime date,
}) async {
  final client = ref.watch(supabaseClientProvider);
  final dateStr = date.toIso8601String().split('T')[0];
  
  try {
    final response = await client
        .from('claims')
        .select('technician_id')
        .eq('appointment_date', dateStr)
        .not('technician_id', 'is', null);
    
    final assignments = <String, int>{};
    for (final row in response as List<dynamic>) {
      final technicianId = row['technician_id'] as String?;
      if (technicianId != null) {
        assignments[technicianId] = (assignments[technicianId] ?? 0) + 1;
      }
    }
    
    return assignments;
  } catch (err) {
    return {};
  }
}

@riverpod
Future<Map<String, dynamic>> technicianAvailability(
  Ref ref, {
  required String technicianId,
  required DateTime date,
}) async {
  final client = ref.watch(supabaseClientProvider);
  final dateStr = date.toIso8601String().split('T')[0];
  
  try {
    // Fetch all appointments for this technician on this date
    final response = await client
        .from('claims')
        .select('id, appointment_time, status')
        .eq('technician_id', technicianId)
        .eq('appointment_date', dateStr)
        .not('appointment_time', 'is', null)
        .order('appointment_time');
    
    final appointments = <Map<String, dynamic>>[];
    for (final row in response as List<dynamic>) {
      appointments.add({
        'id': row['id'] as String,
        'time': row['appointment_time'] as String,
        'status': row['status'] as String,
      });
    }
    
    // Calculate available time slots (assuming 1-hour slots from 8am to 5pm)
    final availableSlots = <String>[];
    final bookedTimes = appointments.map((a) => a['time'] as String).toSet();
    
    for (int hour = 8; hour < 17; hour++) {
      final timeStr = '${hour.toString().padLeft(2, '0')}:00:00';
      if (!bookedTimes.contains(timeStr)) {
        availableSlots.add(timeStr);
      }
    }
    
    return {
      'appointments': appointments,
      'availableSlots': availableSlots,
      'totalAppointments': appointments.length,
    };
  } catch (err) {
    return {
      'appointments': <Map<String, dynamic>>[],
      'availableSlots': <String>[],
      'totalAppointments': 0,
    };
  }
}

