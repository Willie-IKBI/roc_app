import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';
import 'address.dart';
import 'claim.dart';

part 'scheduling_models.freezed.dart';

/// Represents a single appointment slot with timing and travel information.
@freezed
abstract class AppointmentSlot with _$AppointmentSlot {
  const factory AppointmentSlot({
    required String claimId,
    required String claimNumber,
    required String clientName,
    required Address address,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int estimatedDurationMinutes,
    int? travelTimeMinutes, // Travel time from previous appointment
    String? technicianId,
    String? technicianName,
    required ClaimStatus status,
    required PriorityLevel priority,
    DateTime? appointmentDateTime, // Combined date + time for sorting
  }) = _AppointmentSlot;

  const AppointmentSlot._();

  /// Creates an AppointmentSlot from a Claim.
  factory AppointmentSlot.fromClaim(Claim claim) {
    if (claim.appointmentDate == null || claim.appointmentTime == null) {
      throw ArgumentError('Claim must have appointment date and time');
    }

    // Parse appointment time and combine with date
    final timeParts = claim.appointmentTime!.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
    
    final appointmentDateTime = DateTime(
      claim.appointmentDate!.year,
      claim.appointmentDate!.month,
      claim.appointmentDate!.day,
      hour,
      minute,
    );

    return AppointmentSlot(
      claimId: claim.id,
      claimNumber: claim.claimNumber,
      clientName: claim.client?.fullName ?? 'Unknown',
      address: claim.address ?? Address(
        id: '',
        tenantId: '',
        clientId: '',
        street: '',
        suburb: '',
        postalCode: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      appointmentDate: claim.appointmentDate!,
      appointmentTime: claim.appointmentTime!,
      estimatedDurationMinutes: 60, // Default, can be overridden
      travelTimeMinutes: null,
      technicianId: claim.technicianId,
      technicianName: null, // Will be populated from technician data
      status: claim.status,
      priority: claim.priority,
      appointmentDateTime: appointmentDateTime,
    );
  }

  /// Returns the end time of the appointment (start time + duration).
  DateTime? get endDateTime {
    if (appointmentDateTime == null) return null;
    return appointmentDateTime!.add(Duration(minutes: estimatedDurationMinutes));
  }

  /// Returns the start time of the next appointment considering travel time.
  DateTime? get nextAvailableTime {
    if (endDateTime == null) return null;
    final travelDuration = Duration(minutes: travelTimeMinutes ?? 0);
    return endDateTime!.add(travelDuration);
  }
}

/// Represents a technician's schedule for a specific date.
@freezed
abstract class TechnicianSchedule with _$TechnicianSchedule {
  const factory TechnicianSchedule({
    required String technicianId,
    required String technicianName,
    required DateTime date,
    required List<AppointmentSlot> appointments,
    @Default(8) int workStartHour, // Default: 8am
    @Default(17) int workEndHour, // Default: 5pm
  }) = _TechnicianSchedule;

  const TechnicianSchedule._();

  /// Returns appointments sorted by time.
  List<AppointmentSlot> get sortedAppointments {
    final sorted = List<AppointmentSlot>.from(appointments);
    sorted.sort((a, b) {
      if (a.appointmentDateTime == null && b.appointmentDateTime == null) return 0;
      if (a.appointmentDateTime == null) return 1;
      if (b.appointmentDateTime == null) return -1;
      return a.appointmentDateTime!.compareTo(b.appointmentDateTime!);
    });
    return sorted;
  }

  /// Returns the total number of appointments.
  int get totalAppointments => appointments.length;

  /// Returns the total estimated work time in minutes.
  int get totalWorkTimeMinutes {
    return appointments.fold<int>(
      0,
      (sum, appointment) => sum + appointment.estimatedDurationMinutes,
    );
  }

  /// Returns the total travel time in minutes.
  int get totalTravelTimeMinutes {
    return appointments.fold<int>(
      0,
      (sum, appointment) => sum + (appointment.travelTimeMinutes ?? 0),
    );
  }
}

/// Represents all technicians' schedules for a specific date.
@freezed
abstract class DaySchedule with _$DaySchedule {
  const factory DaySchedule({
    required DateTime date,
    required List<TechnicianSchedule> technicianSchedules,
    required List<AppointmentSlot> unassignedAppointments,
  }) = _DaySchedule;

  const DaySchedule._();

  /// Returns the total number of appointments for the day.
  int get totalAppointments {
    return technicianSchedules.fold<int>(
      0,
      (sum, schedule) => sum + schedule.totalAppointments,
    ) + unassignedAppointments.length;
  }

  /// Returns the number of assigned appointments.
  int get assignedAppointments {
    return technicianSchedules.fold<int>(
      0,
      (sum, schedule) => sum + schedule.totalAppointments,
    );
  }

  /// Returns the number of technicians with appointments.
  int get techniciansWithAppointments {
    return technicianSchedules.where((s) => s.appointments.isNotEmpty).length;
  }
}

/// Represents a route optimization suggestion for a technician.
@freezed
abstract class RouteOptimization with _$RouteOptimization {
  const factory RouteOptimization({
    required String technicianId,
    required String technicianName,
    required DateTime date,
    required List<AppointmentSlot> optimizedOrder,
    required List<int> travelTimes, // Travel time between each pair
    required int totalTravelTimeMinutes,
    required int totalWorkTimeMinutes,
    List<String>? conflicts, // List of conflict descriptions
  }) = _RouteOptimization;

  const RouteOptimization._();

  /// Returns true if there are any conflicts.
  bool get hasConflicts => conflicts != null && conflicts!.isNotEmpty;

  /// Returns the total time (work + travel) in minutes.
  int get totalTimeMinutes => totalWorkTimeMinutes + totalTravelTimeMinutes;
}

/// Represents an available time window for scheduling.
@freezed
abstract class AvailabilityWindow with _$AvailabilityWindow {
  const factory AvailabilityWindow({
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes, // Available duration in minutes
  }) = _AvailabilityWindow;

  const AvailabilityWindow._();

  /// Returns true if the window can accommodate the required duration.
  bool canAccommodate(int requiredDurationMinutes) {
    return durationMinutes >= requiredDurationMinutes;
  }

  /// Returns the available duration in minutes.
  int get availableMinutes {
    return endTime.difference(startTime).inMinutes;
  }
}

