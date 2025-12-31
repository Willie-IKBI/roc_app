import '../../domain/repositories/technician_repository.dart';

/// Interface for technician remote data source
/// 
/// Provides methods to fetch technician data from remote storage (Supabase)
abstract class TechnicianRemoteDataSource {
  /// Fetch assignment counts per technician for a specific date
  /// 
  /// Returns map of technician_id -> assignment_count
  /// Uses minimal payload (only technician_id)
  /// 
  /// Enforces:
  /// - Hard limit: limit.clamp(1, 2000) per query
  /// - Deterministic ordering: technician_id ASC
  Future<Map<String, int>> fetchTechnicianAssignments({
    required String dateStr,
    int limit = 1000,
  });

  /// Fetch availability data for a technician on a specific date
  /// 
  /// Returns availability data including appointments and available slots
  /// Uses minimal payload (only id, appointment_time, status)
  /// 
  /// Enforces:
  /// - Hard limit: limit.clamp(1, 200) per query
  /// - Deterministic ordering: appointment_time ASC
  Future<TechnicianAvailability> fetchTechnicianAvailability({
    required String technicianId,
    required String dateStr,
    int limit = 100,
  });
}

