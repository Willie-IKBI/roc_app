import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/domain_error.dart';
import '../../../data/repositories/assignments_repository_supabase.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../data/repositories/user_admin_repository_supabase.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../../core/logging/logger.dart';
import '../../scheduling/controller/scheduling_controller.dart';

part 'assignment_controller.g.dart';
part 'assignment_controller.freezed.dart';

/// State for paginated assignable jobs
@freezed
abstract class AssignableJobsState with _$AssignableJobsState {
  const factory AssignableJobsState({
    @Default([]) List<ClaimSummary> items,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
    String? nextCursor,
    DomainError? error,
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) = _AssignableJobsState;
}

@riverpod
class AssignableJobsController extends _$AssignableJobsController {
  @override
  Future<AssignableJobsState> build({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    // Initial load - don't update state internally, let Riverpod handle it
    return await _loadFirstPage(
      statusFilter: statusFilter,
      assignedFilter: assignedFilter,
      technicianIdFilter: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
      updateState: false,
    );
  }

  /// Load first page (reset pagination)
  Future<AssignableJobsState> _loadFirstPage({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool updateState = true,
  }) async {
    // Set loading state only if updating state (not during build)
    if (updateState) {
      final currentState = state.asData?.value ?? AssignableJobsState();
      state = AsyncValue.data(
        currentState.copyWith(
          isLoading: true,
          error: null,
          statusFilter: statusFilter,
          assignedFilter: assignedFilter,
          technicianIdFilter: technicianIdFilter,
          dateFrom: dateFrom,
          dateTo: dateTo,
          items: [], // Clear items on first page load
        ),
      );
    }

    final repository = ref.read(assignmentsRepositoryProvider);
    final result = await repository.fetchAssignableJobsPage(
      cursor: null, // First page
      limit: 50,
      status: statusFilter,
      assignedFilter: assignedFilter,
      technicianId: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );

    AssignableJobsState finalState;
    if (result.isErr) {
      finalState = AssignableJobsState(
        items: [],
        isLoading: false,
        error: result.error,
        statusFilter: statusFilter,
        assignedFilter: assignedFilter,
        technicianIdFilter: technicianIdFilter,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } else {
      final page = result.data;
      finalState = AssignableJobsState(
        items: page.items,
        isLoading: false,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
        statusFilter: statusFilter,
        assignedFilter: assignedFilter,
        technicianIdFilter: technicianIdFilter,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    }
    
    // Update state with final result (only if updating state)
    if (updateState) {
      state = AsyncValue.data(finalState);
    }
    return finalState;
  }

  /// Load next page (append to existing items)
  Future<void> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null ||
        current.isLoadingMore ||
        !current.hasMore ||
        current.nextCursor == null) {
      return; // Already loading, no more data, or no cursor
    }

    // Update state: loading more
    state = AsyncValue.data(
      current.copyWith(isLoadingMore: true, error: null),
    );

    final repository = ref.read(assignmentsRepositoryProvider);
    final result = await repository.fetchAssignableJobsPage(
      cursor: current.nextCursor,
      limit: 50,
      status: current.statusFilter,
      assignedFilter: current.assignedFilter,
      technicianId: current.technicianIdFilter,
      dateFrom: current.dateFrom,
      dateTo: current.dateTo,
    );

    if (result.isErr) {
      // Update state: error (but keep existing items)
      state = AsyncValue.data(
        current.copyWith(
          isLoadingMore: false,
          error: result.error,
        ),
      );
      return;
    }

    final page = result.data;
    // Update state: append new items
    state = AsyncValue.data(
      current.copyWith(
        items: [...current.items, ...page.items],
        isLoadingMore: false,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
        error: null,
      ),
    );
  }

  /// Refresh (reload first page)
  Future<void> refresh() async {
    final current = state.asData?.value;
    final newState = await _loadFirstPage(
      statusFilter: current?.statusFilter,
      assignedFilter: current?.assignedFilter,
      technicianIdFilter: current?.technicianIdFilter,
      dateFrom: current?.dateFrom,
      dateTo: current?.dateTo,
      updateState: true,
    );
    state = AsyncValue.data(newState);
  }

  /// Update filters (reload first page)
  Future<void> updateFilters({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final newState = await _loadFirstPage(
      statusFilter: statusFilter,
      assignedFilter: assignedFilter,
      technicianIdFilter: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
      updateState: true,
    );
    state = AsyncValue.data(newState);
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
      // Note: assignableJobsControllerProvider will be refreshed by the UI when assignment completes
      // We can't easily invalidate all filter combinations, so the UI should handle refresh
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

