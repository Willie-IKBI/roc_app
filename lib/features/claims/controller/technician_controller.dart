import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/user_account.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../data/repositories/technician_repository_supabase.dart';

part 'technician_controller.g.dart';

@riverpod
Future<List<UserAccount>> technicians(Ref ref) async {
  final repository = ref.watch(userAdminRepositoryProvider);
  final result = await repository.fetchTechnicians(limit: 200);
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
  final repository = ref.watch(technicianRepositoryProvider);
  final result = await repository.fetchTechnicianAssignments(date: date);
  
  if (result.isErr) {
    throw result.error;
  }
  
  return result.data;
}

@riverpod
Future<Map<String, dynamic>> technicianAvailability(
  Ref ref, {
  required String technicianId,
  required DateTime date,
}) async {
  final repository = ref.watch(technicianRepositoryProvider);
  final result = await repository.fetchTechnicianAvailability(
    technicianId: technicianId,
    date: date,
  );
  
  if (result.isErr) {
    throw result.error;
  }
  
  // Convert to map format (for backward compatibility)
  final availability = result.data;
  return {
    'appointments': availability.appointments.map((a) => {
      'id': a.claimId,
      'time': a.appointmentTime,
      'status': a.status,
    }).toList(),
    'availableSlots': availability.availableSlots,
    'totalAppointments': availability.totalAppointments,
  };
}

