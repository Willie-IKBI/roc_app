import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/address.dart';
import '../../domain/models/scheduling_models.dart';
import '../../domain/repositories/scheduling_repository.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../datasources/scheduling_remote_data_source.dart';
import '../datasources/supabase_scheduling_remote_data_source.dart';

final schedulingRepositoryProvider = Provider<SchedulingRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseSchedulingRemoteDataSource(client);
  return SchedulingRepositorySupabase(dataSource);
});

class SchedulingRepositorySupabase implements SchedulingRepository {
  SchedulingRepositorySupabase(this._remote);

  final SchedulingRemoteDataSource _remote;

  @override
  Future<Result<DaySchedule>> fetchScheduleForDay({
    required DateTime date,
    String? technicianId,
  }) async {
    try {
      final rows = await _remote.fetchScheduleForDay(
        date: date,
        technicianId: technicianId,
      );

      // Transform rows to AppointmentSlot
      final appointmentSlots = <AppointmentSlot>[];
      final unassignedAppointments = <AppointmentSlot>[];

      for (final row in rows) {
        try {
          final slot = _mapRowToAppointmentSlot(row, date);
          
          if (slot.technicianId != null) {
            appointmentSlots.add(slot);
          } else {
            unassignedAppointments.add(slot);
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error processing appointment row for claim ${row['id']}: $e',
            name: 'SchedulingRepositorySupabase',
            error: e,
            stackTrace: stackTrace,
          );
          // Continue processing other appointments
        }
      }

      // Group appointments by technician
      final technicianSchedules = <TechnicianSchedule>[];
      final appointmentsByTechnician = <String, List<AppointmentSlot>>{};
      
      for (final slot in appointmentSlots) {
        if (slot.technicianId != null) {
          appointmentsByTechnician
              .putIfAbsent(slot.technicianId!, () => [])
              .add(slot);
        }
      }

      // Create technician schedules
      for (final entry in appointmentsByTechnician.entries) {
        // Sort appointments by time within each technician
        final sortedAppointments = List<AppointmentSlot>.from(entry.value);
        sortedAppointments.sort((a, b) {
          if (a.appointmentDateTime == null && b.appointmentDateTime == null) return 0;
          if (a.appointmentDateTime == null) return 1;
          if (b.appointmentDateTime == null) return -1;
          return a.appointmentDateTime!.compareTo(b.appointmentDateTime!);
        });

        // Get technician name from first appointment (all should have same technician)
        final technicianName = entry.value.first.technicianName ?? 'Unknown';
        
        technicianSchedules.add(
          TechnicianSchedule(
            technicianId: entry.key,
            technicianName: technicianName,
            date: date,
            appointments: sortedAppointments,
          ),
        );
      }

      // Sort unassigned appointments by time
      unassignedAppointments.sort((a, b) {
        if (a.appointmentDateTime == null && b.appointmentDateTime == null) return 0;
        if (a.appointmentDateTime == null) return 1;
        if (b.appointmentDateTime == null) return -1;
        return a.appointmentDateTime!.compareTo(b.appointmentDateTime!);
      });

      return Result.ok(
        DaySchedule(
          date: date,
          technicianSchedules: technicianSchedules,
          unassignedAppointments: unassignedAppointments,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch schedule for day: $e',
        name: 'SchedulingRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );
      
      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' || 
            (e.message.contains('permission')) || 
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch schedule: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Schedule data');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }
      
      return Result.err(error);
    }
  }

  /// Maps a Supabase row to AppointmentSlot
  AppointmentSlot _mapRowToAppointmentSlot(Map<String, dynamic> row, DateTime date) {
    // Extract claim data
    final claimId = row['id'] as String;
    final claimNumber = row['claim_number'] as String;
    final technicianId = row['technician_id'] as String?;
    final appointmentDateStr = row['appointment_date'] as String;
    final appointmentTime = row['appointment_time'] as String;
    final statusStr = row['status'] as String;
    final priorityStr = row['priority'] as String;
    final estimatedDurationMinutes = (row['estimated_duration_minutes'] as int?) ?? 60;
    final travelTimeMinutes = row['travel_time_minutes'] as int?;

    // Parse appointment date
    final appointmentDate = DateTime.parse(appointmentDateStr);

    // Parse appointment time and create DateTime
    final timeParts = appointmentTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
    
    final appointmentDateTime = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
      hour,
      minute,
    );

    // Extract client data
    final clientData = row['client'] as Map<String, dynamic>?;
    final clientName = clientData != null
        ? '${clientData['first_name'] ?? ''} ${clientData['last_name'] ?? ''}'.trim()
        : 'Unknown';
    if (clientName.isEmpty) {
      AppLogger.warn(
        'Client name is empty for claim $claimId',
        name: 'SchedulingRepositorySupabase',
      );
    }

    // Extract address data
    final addressData = row['address'] as Map<String, dynamic>?;
    Address address;
    if (addressData != null) {
      address = Address(
        id: addressData['id'] as String? ?? '',
        tenantId: '', // Not available in join, but not needed for scheduling
        clientId: '', // Not available in join, but not needed for scheduling
        street: addressData['street'] as String? ?? '',
        suburb: addressData['suburb'] as String? ?? '',
        city: addressData['city'] as String? ?? '',
        province: addressData['province'] as String? ?? '',
        postalCode: '', // Not available in join, but not needed for scheduling
        latitude: (addressData['lat'] as num?)?.toDouble(),
        longitude: (addressData['lng'] as num?)?.toDouble(),
        createdAt: DateTime.now(), // Not available in join
        updatedAt: DateTime.now(), // Not available in join
      );
    } else {
      // Fallback empty address
      address = Address(
        id: '',
        tenantId: '',
        clientId: '',
        street: '',
        suburb: '',
        city: '',
        province: '',
        postalCode: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      AppLogger.warn(
        'Address data missing for claim $claimId',
        name: 'SchedulingRepositorySupabase',
      );
    }

    // Extract technician data
    final technicianData = row['technician'] as Map<String, dynamic>?;
    final technicianName = technicianData?['full_name'] as String?;

    // Parse enums
    final status = ClaimStatus.fromJson(statusStr);
    final priority = PriorityLevel.fromJson(priorityStr);

    return AppointmentSlot(
      claimId: claimId,
      claimNumber: claimNumber,
      clientName: clientName,
      address: address,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      estimatedDurationMinutes: estimatedDurationMinutes,
      travelTimeMinutes: travelTimeMinutes,
      technicianId: technicianId,
      technicianName: technicianName,
      status: status,
      priority: priority,
      appointmentDateTime: appointmentDateTime,
    );
  }
}
