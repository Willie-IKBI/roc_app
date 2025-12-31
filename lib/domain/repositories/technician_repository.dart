import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/result.dart';

part 'technician_repository.freezed.dart';

/// Appointment slot (minimal data for availability)
@freezed
abstract class AppointmentSlot with _$AppointmentSlot {
  const factory AppointmentSlot({
    required String claimId,
    required String appointmentTime,
    required String status,
  }) = _AppointmentSlot;
}

/// Technician availability data for a specific date
@freezed
abstract class TechnicianAvailability with _$TechnicianAvailability {
  const factory TechnicianAvailability({
    required String technicianId,
    required DateTime date,
    required List<AppointmentSlot> appointments,
    required List<String> availableSlots,
    required int totalAppointments,
  }) = _TechnicianAvailability;
}

abstract class TechnicianRepository {
  /// Fetch assignment counts per technician for a specific date
  /// 
  /// [date] - Date to fetch assignments for (YYYY-MM-DD)
  /// [limit] - Maximum number of assignments to count (default: 1000, max: 2000)
  /// 
  /// Returns map of technician_id -> assignment_count
  /// 
  /// Query: Counts appointments per technician for the date
  /// Uses minimal payload (only technician_id)
  Future<Result<Map<String, int>>> fetchTechnicianAssignments({
    required DateTime date,
    int limit = 1000,
  });

  /// Fetch availability data for a technician on a specific date
  /// 
  /// [technicianId] - Technician to fetch availability for
  /// [date] - Date to fetch availability for (YYYY-MM-DD)
  /// [limit] - Maximum number of appointments to fetch (default: 100, max: 200)
  /// 
  /// Returns availability data including:
  /// - List of appointments (id, time, status)
  /// - Available time slots (calculated client-side)
  /// - Total appointment count
  /// 
  /// Query: Fetches appointments for technician on date
  /// Uses minimal payload (only id, appointment_time, status)
  Future<Result<TechnicianAvailability>> fetchTechnicianAvailability({
    required String technicianId,
    required DateTime date,
    int limit = 100,
  });
}

