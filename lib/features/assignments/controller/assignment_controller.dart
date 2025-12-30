import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/clients/supabase_client.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../domain/models/claim.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../../core/logging/logger.dart';
import '../../scheduling/controller/scheduling_controller.dart';

part 'assignment_controller.g.dart';

/// Fetches assignable jobs with filtering support.
@riverpod
Future<List<ClaimSummary>> assignableJobs(
  Ref ref, {
  ClaimStatus? statusFilter,
  bool? assignedFilter, // null = all, true = assigned, false = unassigned
  String? technicianIdFilter,
  DateTime? dateFrom,
  DateTime? dateTo,
}) async {
  final client = ref.watch(supabaseClientProvider);
  final claimRepository = ref.watch(claimRepositoryProvider);

  try {
    // Use fetchQueue as base, then filter in memory for now
    // In the future, we could add a more sophisticated query method
    final queueResult = await claimRepository.fetchQueue(status: statusFilter);
    
    if (queueResult.isErr) {
      AppLogger.error(
        'Failed to fetch assignable jobs',
        name: 'AssignmentController',
        error: queueResult.error,
      );
      return [];
    }

    var claims = queueResult.data;

    // Filter by assignment status
    if (assignedFilter != null) {
      // We need to fetch full claims to check technician_id
      // For now, filter by checking if we can get technician info
      final filteredClaims = <ClaimSummary>[];
      for (final claimSummary in claims) {
        final claimResult = await claimRepository.fetchById(claimSummary.claimId);
        if (claimResult.isOk) {
          final claim = claimResult.data;
          final isAssigned = claim.technicianId != null;
          if (assignedFilter == isAssigned) {
            filteredClaims.add(claimSummary);
          }
        }
      }
      claims = filteredClaims;
    }

    // Filter by technician
    if (technicianIdFilter != null) {
      final filteredClaims = <ClaimSummary>[];
      for (final claimSummary in claims) {
        final claimResult = await claimRepository.fetchById(claimSummary.claimId);
        if (claimResult.isOk) {
          final claim = claimResult.data;
          if (claim.technicianId == technicianIdFilter) {
            filteredClaims.add(claimSummary);
          }
        }
      }
      claims = filteredClaims;
    }

    // Filter by date range (appointment date)
    if (dateFrom != null || dateTo != null) {
      final filteredClaims = <ClaimSummary>[];
      for (final claimSummary in claims) {
        final claimResult = await claimRepository.fetchById(claimSummary.claimId);
        if (claimResult.isOk) {
          final claim = claimResult.data;
          if (claim.appointmentDate != null) {
            final appointmentDate = claim.appointmentDate!;
            final matchesFrom = dateFrom == null || appointmentDate.isAfter(dateFrom.subtract(const Duration(days: 1)));
            final matchesTo = dateTo == null || appointmentDate.isBefore(dateTo.add(const Duration(days: 1)));
            if (matchesFrom && matchesTo) {
              filteredClaims.add(claimSummary);
            }
          } else if (dateFrom == null && dateTo == null) {
            // Include claims without appointment date if no date filter
            filteredClaims.add(claimSummary);
          }
        }
      }
      claims = filteredClaims;
    }

    return claims;
  } catch (error, stackTrace) {
    AppLogger.error(
      'Error fetching assignable jobs',
      name: 'AssignmentController',
      error: error,
      stackTrace: stackTrace,
    );
    return [];
  }
}

/// Controller for assignment operations.
@riverpod
class AssignmentController extends _$AssignmentController {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Assigns a technician and appointment to a claim.
  Future<void> assignTechnician({
    required String claimId,
    String? technicianId,
    DateTime? appointmentDate,
    String? appointmentTime,
  }) async {
    final claimRepository = ref.read(claimRepositoryProvider);

    try {
      // Update technician
      if (technicianId != null) {
        final techResult = await claimRepository.updateTechnician(
          claimId: claimId,
          technicianId: technicianId,
        );
        if (techResult.isErr) {
          AppLogger.error(
            'Failed to update technician for claim $claimId',
            name: 'AssignmentController',
            error: techResult.error,
          );
          throw techResult.error;
        }
      }

      // Update appointment
      if (appointmentDate != null || appointmentTime != null) {
        final apptResult = await claimRepository.updateAppointment(
          claimId: claimId,
          appointmentDate: appointmentDate,
          appointmentTime: appointmentTime,
        );
        if (apptResult.isErr) {
          AppLogger.error(
            'Failed to update appointment for claim $claimId',
            name: 'AssignmentController',
            error: apptResult.error,
          );
          throw apptResult.error;
        }
      }

      // Invalidate relevant providers
      ref.invalidate(assignableJobsProvider);
      ref.invalidate(dayScheduleProvider);
      ref.invalidate(unassignedAppointmentsProvider);
      
      // Invalidate all technician schedules
      final userRepository = ref.read(userAdminRepositoryProvider);
      final techniciansResult = await userRepository.fetchTechnicians();
      if (techniciansResult.isOk) {
        for (final technician in techniciansResult.data) {
          if (appointmentDate != null) {
            ref.invalidate(technicianScheduleProvider(technicianId: technician.id, date: appointmentDate));
          }
        }
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Error assigning technician',
        name: 'AssignmentController',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

