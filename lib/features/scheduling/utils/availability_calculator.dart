import '../../../domain/models/scheduling_models.dart';

/// Utility class for calculating available time slots for scheduling.
class AvailabilityCalculator {
  AvailabilityCalculator({
    this.workStartHour = 8,
    this.workEndHour = 17,
    this.bufferMinutes = 15,
  });

  /// Work start hour (24-hour format, default: 8 = 8am)
  final int workStartHour;

  /// Work end hour (24-hour format, default: 17 = 5pm)
  final int workEndHour;

  /// Buffer time in minutes between appointments (default: 15)
  final int bufferMinutes;

  /// Calculates available time slots for scheduling a new appointment.
  /// 
  /// Takes into account:
  /// - Existing appointments
  /// - Travel time between appointments
  /// - Estimated job duration
  /// - Working hours
  /// - Buffer time between appointments
  List<AvailabilityWindow> calculateAvailableSlots({
    required List<AppointmentSlot> appointments,
    required int requiredDurationMinutes,
  }) {
    final availableWindows = <AvailabilityWindow>[];
    
    if (appointments.isEmpty) {
      // No appointments, entire day is available
      final startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        workStartHour,
      );
      final endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        workEndHour,
      );
      
      final duration = endTime.difference(startTime).inMinutes;
      if (duration >= requiredDurationMinutes) {
        availableWindows.add(
          AvailabilityWindow(
            startTime: startTime,
            endTime: endTime,
            durationMinutes: duration,
          ),
        );
      }
      return availableWindows;
    }

    // Sort appointments by time
    final sortedAppointments = List<AppointmentSlot>.from(appointments);
    sortedAppointments.sort((a, b) {
      if (a.appointmentDateTime == null && b.appointmentDateTime == null) return 0;
      if (a.appointmentDateTime == null) return 1;
      if (b.appointmentDateTime == null) return -1;
      return a.appointmentDateTime!.compareTo(b.appointmentDateTime!);
    });

    // Get the date from the first appointment
    final date = sortedAppointments.first.appointmentDate;

    // Check slot before first appointment
    final dayStart = DateTime(
      date.year,
      date.month,
      date.day,
      workStartHour,
    );
    
    final firstAppointment = sortedAppointments.first;
    if (firstAppointment.appointmentDateTime != null) {
      final timeUntilFirst = firstAppointment.appointmentDateTime!.difference(dayStart);
      if (timeUntilFirst.inMinutes >= requiredDurationMinutes + bufferMinutes) {
        availableWindows.add(
          AvailabilityWindow(
            startTime: dayStart,
            endTime: firstAppointment.appointmentDateTime!,
            durationMinutes: timeUntilFirst.inMinutes - bufferMinutes,
          ),
        );
      }
    }

    // Check slots between appointments
    for (int i = 0; i < sortedAppointments.length - 1; i++) {
      final current = sortedAppointments[i];
      final next = sortedAppointments[i + 1];

      if (current.endDateTime == null || next.appointmentDateTime == null) {
        continue;
      }

      // Calculate available time considering travel time and buffer
      final travelTime = current.travelTimeMinutes ?? 0;
      final currentEnd = current.endDateTime!.add(Duration(minutes: travelTime + bufferMinutes));
      
      final timeAvailable = next.appointmentDateTime!.difference(currentEnd);
      
      if (timeAvailable.inMinutes >= requiredDurationMinutes + bufferMinutes) {
        availableWindows.add(
          AvailabilityWindow(
            startTime: currentEnd,
            endTime: next.appointmentDateTime!,
            durationMinutes: timeAvailable.inMinutes - bufferMinutes,
          ),
        );
      }
    }

    // Check slot after last appointment
    final lastAppointment = sortedAppointments.last;
    if (lastAppointment.endDateTime != null) {
      final dayEnd = DateTime(
        date.year,
        date.month,
        date.day,
        workEndHour,
      );

      final travelTime = lastAppointment.travelTimeMinutes ?? 0;
      final lastEnd = lastAppointment.endDateTime!.add(Duration(minutes: travelTime + bufferMinutes));
      
      final timeAfterLast = dayEnd.difference(lastEnd);
      
      if (timeAfterLast.inMinutes >= requiredDurationMinutes) {
        availableWindows.add(
          AvailabilityWindow(
            startTime: lastEnd,
            endTime: dayEnd,
            durationMinutes: timeAfterLast.inMinutes,
          ),
        );
      }
    }

    return availableWindows;
  }
}

