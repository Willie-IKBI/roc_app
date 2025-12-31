import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/scheduling_repository_supabase.dart';
import '../../../domain/models/address.dart';
import '../../../domain/models/scheduling_models.dart';
import '../../../core/utils/travel_time_service.dart';
import '../utils/availability_calculator.dart';

part 'scheduling_controller.g.dart';

/// Fetches all appointments for a specific date, grouped by technician.
@riverpod
Future<DaySchedule> daySchedule(
  Ref ref, {
  required DateTime date,
  String? technicianId,
}) async {
  final repository = ref.watch(schedulingRepositoryProvider);
  final result = await repository.fetchScheduleForDay(
    date: date,
    technicianId: technicianId,
  );

  if (result.isErr) {
    // Surface error to UI - AsyncValue will be AsyncError
    throw result.error;
  }

  return result.data;
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

