import '../models/scheduling_models.dart';
import '../../core/utils/result.dart';

abstract class SchedulingRepository {
  /// Fetch all appointments for a specific date
  /// 
  /// [date] - Date to fetch appointments for (YYYY-MM-DD)
  /// [technicianId] - Optional filter by technician (null = all technicians)
  /// 
  /// Returns DaySchedule with:
  /// - All appointments grouped by technician
  /// - Unassigned appointments (technician_id IS NULL)
  /// - Hard limit: 200 appointments per day (enforced in data source)
  /// 
  /// Query includes all required data (eliminates N+1 pattern):
  /// - Claim details (id, claim_number, status, priority)
  /// - Client details (first_name, last_name)
  /// - Address details (street, suburb, city, province, lat, lng)
  /// - Appointment details (appointment_date, appointment_time, estimated_duration_minutes, travel_time_minutes)
  /// - Technician details (technician_id, technician name via join)
  Future<Result<DaySchedule>> fetchScheduleForDay({
    required DateTime date,
    String? technicianId,
  });

  // Note: updateAppointment() already exists in ClaimRepository
  // Use ClaimRepository.updateAppointment() for appointment updates
  // This repository is read-only for scheduling data
}

