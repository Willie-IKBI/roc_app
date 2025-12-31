/// Interface for scheduling remote data source
/// 
/// Provides methods to fetch scheduling data from remote storage (Supabase)
abstract class SchedulingRemoteDataSource {
  /// Fetch all appointments for a specific date with all required joins
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Includes: claims, clients, addresses, profiles (technician)
  /// 
  /// Enforces:
  /// - Hard limit: 200 appointments per day
  /// - Deterministic ordering: appointment_time ASC, id ASC
  /// - Filters: appointment_date = date, appointment_time IS NOT NULL
  /// - Optional: technician_id filter
  Future<List<Map<String, dynamic>>> fetchScheduleForDay({
    required DateTime date,
    String? technicianId,
  });
}

