import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/clients/supabase_client.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../domain/models/address.dart';
import '../../../domain/models/claim.dart';
import '../../../domain/models/scheduling_models.dart';
import '../../../domain/models/user_account.dart';
import '../../../core/utils/travel_time_service.dart';
import '../../../core/logging/logger.dart';
import '../utils/availability_calculator.dart';

part 'scheduling_controller.g.dart';

/// Fetches all appointments for a specific date, grouped by technician.
@riverpod
Future<DaySchedule> daySchedule(
  Ref ref, {
  required DateTime date,
}) async {
  final client = ref.watch(supabaseClientProvider);
  final claimRepository = ref.watch(claimRepositoryProvider);
  final userRepository = ref.watch(userAdminRepositoryProvider);
  
  final dateStr = date.toIso8601String().split('T')[0];
  
  try {
    // Fetch all claims with appointments for this date
    final response = await client
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
            last_name
          ),
          address:addresses!claims_address_id_fkey(
            id,
            street,
            suburb,
            city,
            province,
            lat,
            lng
          )
        ''')
        .eq('appointment_date', dateStr)
        .not('appointment_time', 'is', null)
        .order('appointment_time');

    // Fetch all technicians
    final techniciansResult = await userRepository.fetchTechnicians();
    final technicians = techniciansResult.isOk ? techniciansResult.data : <UserAccount>[];
    final technicianMap = {for (var t in technicians) t.id: t};

    // Convert to Claim objects and then to AppointmentSlot
    final appointmentSlots = <AppointmentSlot>[];
    final unassignedAppointments = <AppointmentSlot>[];
    
    for (final row in response as List<dynamic>) {
      try {
        // Fetch full claim to get all required data
        final claimResult = await claimRepository.fetchById(row['id'] as String);
        if (claimResult.isErr) {
          AppLogger.warn(
            'Failed to fetch claim ${row['id']} for scheduling',
            name: 'SchedulingController',
          );
          continue;
        }

        final claim = claimResult.data;
        if (claim.appointmentDate == null || claim.appointmentTime == null) {
          continue;
        }

        // Create appointment slot
        var slot = AppointmentSlot.fromClaim(claim);
        
        // Set technician name if assigned
        if (slot.technicianId != null) {
          final technician = technicianMap[slot.technicianId];
          if (technician != null) {
            slot = slot.copyWith(technicianName: technician.fullName);
          }
        }

        // Set estimated duration from database if available
        final estimatedDuration = row['estimated_duration_minutes'] as int? ?? 60;
        final travelTime = row['travel_time_minutes'] as int?;
        
        final finalSlot = slot.copyWith(
          estimatedDurationMinutes: estimatedDuration,
          travelTimeMinutes: travelTime,
        );

        if (finalSlot.technicianId != null) {
          appointmentSlots.add(finalSlot);
        } else {
          unassignedAppointments.add(finalSlot);
        }
      } catch (error, stackTrace) {
        AppLogger.error(
          'Error processing appointment for claim ${row['id']}',
          name: 'SchedulingController',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    // Group appointments by technician
    final technicianSchedules = <TechnicianSchedule>[];
    final appointmentsByTechnician = <String, List<AppointmentSlot>>{};
    
    for (final slot in appointmentSlots) {
      if (slot.technicianId != null) {
        appointmentsByTechnician.putIfAbsent(slot.technicianId!, () => []).add(slot);
      }
    }

    // Create technician schedules
    for (final entry in appointmentsByTechnician.entries) {
      final technician = technicianMap[entry.key];
      if (technician != null) {
        technicianSchedules.add(
          TechnicianSchedule(
            technicianId: entry.key,
            technicianName: technician.fullName,
            date: date,
            appointments: entry.value,
          ),
        );
      }
    }

    return DaySchedule(
      date: date,
      technicianSchedules: technicianSchedules,
      unassignedAppointments: unassignedAppointments,
    );
  } catch (error, stackTrace) {
    AppLogger.error(
      'Failed to fetch day schedule',
      name: 'SchedulingController',
      error: error,
      stackTrace: stackTrace,
    );
    return DaySchedule(
      date: date,
      technicianSchedules: [],
      unassignedAppointments: [],
    );
  }
}

/// Fetches a technician's schedule for a specific date.
@riverpod
Future<TechnicianSchedule> technicianSchedule(
  Ref ref, {
  required String technicianId,
  required DateTime date,
}) async {
  final dayScheduleData = await ref.watch(dayScheduleProvider(date: date).future);
  
  final schedule = dayScheduleData.technicianSchedules.firstWhere(
    (s) => s.technicianId == technicianId,
    orElse: () => TechnicianSchedule(
      technicianId: technicianId,
      technicianName: 'Unknown',
      date: date,
      appointments: [],
    ),
  );

  return schedule;
}

/// Calculates travel time between two addresses.
@riverpod
Future<int?> calculateTravelTime(
  Ref ref, {
  required Address from,
  required Address to,
}) async {
  return await TravelTimeService.calculateTravelTime(from: from, to: to);
}

/// Optimizes route for a technician on a specific date.
@riverpod
Future<RouteOptimization> optimizeRoute(
  Ref ref, {
  required String technicianId,
  required DateTime date,
}) async {
  final schedule = await ref.watch(
    technicianScheduleProvider(technicianId: technicianId, date: date).future,
  );

  if (schedule.appointments.isEmpty) {
    return RouteOptimization(
      technicianId: technicianId,
      technicianName: schedule.technicianName,
      date: date,
      optimizedOrder: [],
      travelTimes: [],
      totalTravelTimeMinutes: 0,
      totalWorkTimeMinutes: 0,
      conflicts: [],
    );
  }

  // Sort appointments by time
  final sortedAppointments = schedule.sortedAppointments;
  
  // Calculate travel times between consecutive appointments
  final travelTimes = <int?>[];
  final conflicts = <String>[];

  for (int i = 1; i < sortedAppointments.length; i++) {
    final from = sortedAppointments[i - 1];
    final to = sortedAppointments[i];

    // Calculate travel time
    final travelTime = await TravelTimeService.calculateTravelTime(
      from: from.address,
      to: to.address,
    );

    travelTimes.add(travelTime);

    // Check for conflicts
    if (travelTime != null && from.nextAvailableTime != null) {
      if (to.appointmentDateTime != null) {
        final timeUntilNext = to.appointmentDateTime!.difference(from.nextAvailableTime!);
        if (timeUntilNext.isNegative) {
          conflicts.add(
            'Insufficient travel time between ${from.claimNumber} and ${to.claimNumber}. '
            'Need ${travelTime} minutes but only have ${timeUntilNext.inMinutes.abs()} minutes.',
          );
        } else if (timeUntilNext.inMinutes < 15) {
          conflicts.add(
            'Tight schedule between ${from.claimNumber} and ${to.claimNumber}. '
            'Only ${timeUntilNext.inMinutes} minutes buffer.',
          );
        }
      }
    }
  }

  final totalTravelTime = travelTimes.fold<int>(
    0,
    (sum, time) => sum + (time ?? 0),
  );

  return RouteOptimization(
    technicianId: technicianId,
    technicianName: schedule.technicianName,
    date: date,
    optimizedOrder: sortedAppointments,
    travelTimes: travelTimes.map((t) => t ?? 0).toList(),
    totalTravelTimeMinutes: totalTravelTime,
    totalWorkTimeMinutes: schedule.totalWorkTimeMinutes,
    conflicts: conflicts.isEmpty ? null : conflicts,
  );
}

/// Gets available time slots for a technician on a specific date.
@riverpod
Future<List<AvailabilityWindow>> availableTimeSlots(
  Ref ref, {
  required String technicianId,
  required DateTime date,
  required int requiredDurationMinutes,
}) async {
  final schedule = await ref.watch(
    technicianScheduleProvider(technicianId: technicianId, date: date).future,
  );

  // Import availability calculator
  final calculator = AvailabilityCalculator(
    workStartHour: schedule.workStartHour,
    workEndHour: schedule.workEndHour,
    bufferMinutes: 15,
  );

  return calculator.calculateAvailableSlots(
    appointments: schedule.sortedAppointments,
    requiredDurationMinutes: requiredDurationMinutes,
  );
}

/// Gets unassigned appointments for a specific date.
@riverpod
Future<List<AppointmentSlot>> unassignedAppointments(
  Ref ref, {
  required DateTime date,
}) async {
  final daySchedule = await ref.watch(dayScheduleProvider(date: date).future);
  return daySchedule.unassignedAppointments;
}

