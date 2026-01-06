import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logging/logger.dart';
import '../../../data/repositories/reporting_repository_supabase.dart';
import '../../../domain/models/report_models.dart';
import '../domain/paginated_report_state.dart';

part 'paginated_report_controller.g.dart';

@Riverpod(keepAlive: true)
class AgentPerformanceReportController extends _$AgentPerformanceReportController {
  @override
  Future<PaginatedReportState<AgentPerformanceReport>> build() async {
    // Load initial data - no date filtering
    return await _loadInitial();
  }

  Future<PaginatedReportState<AgentPerformanceReport>> _loadInitial() async {
    try {
      AppLogger.debug(
        'Loading agent performance report: ALL DATA (no date filter)',
        name: 'AgentPerformanceReportController',
      );

      final repository = ref.read(reportingRepositoryProvider);
      
      // Load all data automatically - start with max limit
      var allItems = <AgentPerformanceReport>[];
      String? nextCursor;
      bool hasMore = true;
      int pageCount = 0;
      const maxPageSize = 500;
      
      while (hasMore && pageCount < 100) { // Safety limit of 100 pages
        final result = await repository.fetchAgentPerformanceReportPage(
          // No date range - show all data
          cursor: nextCursor,
          limit: maxPageSize,
        );

        if (result.isErr) {
          AppLogger.error(
            'Failed to load agent performance report page ${pageCount + 1}: ${result.error}',
            name: 'AgentPerformanceReportController',
            error: result.error,
          );
          // Return what we have so far, or error if we have nothing
          if (allItems.isEmpty) {
            return PaginatedReportState(
              isLoading: false,
              error: result.error,
            );
          }
          break; // Return partial data
        }

        // Handle empty first page - continue to next page in case of cursor issue
        if (pageCount == 0 && result.data.items.isEmpty) {
          AppLogger.warn(
            'First page returned empty. Checking if date range is correct or if cursor issue exists.',
            name: 'AgentPerformanceReportController',
          );
          // Continue to next page if hasMore is true
          if (result.data.hasMore && result.data.nextCursor != null) {
            hasMore = result.data.hasMore;
            nextCursor = result.data.nextCursor;
            pageCount++;
            continue;
          } else {
            // No more data, break
            break;
          }
        }

        allItems.addAll(result.data.items);
        hasMore = result.data.hasMore;
        nextCursor = result.data.nextCursor;
        pageCount++;
        
        AppLogger.debug(
          'Loaded page $pageCount: ${result.data.items.length} items (total: ${allItems.length})',
          name: 'AgentPerformanceReportController',
        );
        
        // Break if no more data
        if (!hasMore || nextCursor == null) {
          break;
        }
      }

      AppLogger.debug(
        'Loaded all agent performance data: ${allItems.length} items across $pageCount pages',
        name: 'AgentPerformanceReportController',
      );
      return PaginatedReportState(
        items: allItems,
        hasMore: false, // All data loaded
        nextCursor: null,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Exception loading agent performance report: $e',
        name: 'AgentPerformanceReportController',
        error: e,
        stackTrace: stackTrace,
      );
      return PaginatedReportState(
        isLoading: false,
        error: e,
      );
    }
  }

  Future<void> loadMore() async {
    // All data is loaded automatically, so this is a no-op
    // Keeping for API compatibility but it won't do anything
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.nextCursor == null) {
      return;
    }
    // This should never be called since hasMore is always false after _loadInitial
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitial());
  }
}

@Riverpod(keepAlive: true)
class StatusDistributionReportController extends _$StatusDistributionReportController {
  @override
  Future<PaginatedReportState<StatusDistributionReport>> build() async {
    return await _loadInitial();
  }

  Future<PaginatedReportState<StatusDistributionReport>> _loadInitial() async {
    try {
      AppLogger.debug(
        'Loading status distribution report: ALL DATA (no date filter)',
        name: 'StatusDistributionReportController',
      );

      final repository = ref.read(reportingRepositoryProvider);
      
      // Load all data automatically
      var allItems = <StatusDistributionReport>[];
      String? nextCursor;
      bool hasMore = true;
      int pageCount = 0;
      const maxPageSize = 500;
      
      while (hasMore && pageCount < 100) {
        final result = await repository.fetchStatusDistributionReportPage(
          // No date range - show all data
          cursor: nextCursor,
          limit: maxPageSize,
        );

        if (result.isErr) {
          AppLogger.error(
            'Failed to load status distribution report page ${pageCount + 1}: ${result.error}',
            name: 'StatusDistributionReportController',
            error: result.error,
          );
          if (allItems.isEmpty) {
            return PaginatedReportState(isLoading: false, error: result.error);
          }
          break;
        }

        // Handle empty first page - continue to next page in case of cursor issue
        if (pageCount == 0 && result.data.items.isEmpty) {
          AppLogger.warn(
            'First page returned empty. Checking if date range is correct or if cursor issue exists.',
            name: 'StatusDistributionReportController',
          );
          if (result.data.hasMore && result.data.nextCursor != null) {
            hasMore = result.data.hasMore;
            nextCursor = result.data.nextCursor;
            pageCount++;
            continue;
          } else {
            break;
          }
        }

        allItems.addAll(result.data.items);
        hasMore = result.data.hasMore;
        nextCursor = result.data.nextCursor;
        pageCount++;
        
        if (!hasMore || nextCursor == null) break;
      }

      AppLogger.debug(
        'Loaded all status distribution data: ${allItems.length} items across $pageCount pages',
        name: 'StatusDistributionReportController',
      );
      return PaginatedReportState(
        items: allItems,
        hasMore: false,
        nextCursor: null,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Exception loading status distribution report: $e',
        name: 'StatusDistributionReportController',
        error: e,
        stackTrace: stackTrace,
      );
      return PaginatedReportState(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    // All data is loaded automatically, so this is a no-op
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.nextCursor == null) return;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitial());
  }
}

@Riverpod(keepAlive: true)
class DamageCauseReportController extends _$DamageCauseReportController {
  @override
  Future<PaginatedReportState<DamageCauseReport>> build() async {
    return await _loadInitial();
  }

  Future<PaginatedReportState<DamageCauseReport>> _loadInitial() async {
    try {
      AppLogger.debug(
        'Loading damage cause report: ALL DATA (no date filter)',
        name: 'DamageCauseReportController',
      );

      final repository = ref.read(reportingRepositoryProvider);
      
      // Load all data automatically
      var allItems = <DamageCauseReport>[];
      String? nextCursor;
      bool hasMore = true;
      int pageCount = 0;
      const maxPageSize = 500;
      
      while (hasMore && pageCount < 100) {
        final result = await repository.fetchDamageCauseReportPage(
          // No date range - show all data
          cursor: nextCursor,
          limit: maxPageSize,
        );

        if (result.isErr) {
          AppLogger.error(
            'Failed to load damage cause report page ${pageCount + 1}: ${result.error}',
            name: 'DamageCauseReportController',
            error: result.error,
          );
          if (allItems.isEmpty) {
            return PaginatedReportState(isLoading: false, error: result.error);
          }
          break;
        }

        // Handle empty first page - continue to next page in case of cursor issue
        if (pageCount == 0 && result.data.items.isEmpty) {
          AppLogger.warn(
            'First page returned empty. Checking if date range is correct or if cursor issue exists.',
            name: 'DamageCauseReportController',
          );
          if (result.data.hasMore && result.data.nextCursor != null) {
            hasMore = result.data.hasMore;
            nextCursor = result.data.nextCursor;
            pageCount++;
            continue;
          } else {
            break;
          }
        }

        allItems.addAll(result.data.items);
        hasMore = result.data.hasMore;
        nextCursor = result.data.nextCursor;
        pageCount++;
        
        if (!hasMore || nextCursor == null) break;
      }

      AppLogger.debug(
        'Loaded all damage cause data: ${allItems.length} items across $pageCount pages',
        name: 'DamageCauseReportController',
      );
      return PaginatedReportState(
        items: allItems,
        hasMore: false,
        nextCursor: null,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Exception loading damage cause report: $e',
        name: 'DamageCauseReportController',
        error: e,
        stackTrace: stackTrace,
      );
      return PaginatedReportState(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    // All data is loaded automatically, so this is a no-op
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.nextCursor == null) return;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitial());
  }
}

@Riverpod(keepAlive: true)
class GeographicReportController extends _$GeographicReportController {
  @override
  Future<PaginatedReportState<GeographicReport>> build(String? groupBy) async {
    _groupBy = groupBy;
    return await _loadInitial();
  }

  String? _groupBy;

  Future<PaginatedReportState<GeographicReport>> _loadInitial() async {
    try {
      AppLogger.debug(
        'Loading geographic report: ALL DATA (no date filter), groupBy: $_groupBy',
        name: 'GeographicReportController',
      );

      final repository = ref.read(reportingRepositoryProvider);
      
      // Load all data automatically
      var allItems = <GeographicReport>[];
      String? nextCursor;
      bool hasMore = true;
      int pageCount = 0;
      const maxPageSize = 500;
      
      while (hasMore && pageCount < 100) {
        final result = await repository.fetchGeographicReportPage(
          // No date range - show all data
          groupBy: _groupBy,
          cursor: nextCursor,
          limit: maxPageSize,
        );

        if (result.isErr) {
          AppLogger.error(
            'Failed to load geographic report page ${pageCount + 1}: ${result.error}',
            name: 'GeographicReportController',
            error: result.error,
          );
          if (allItems.isEmpty) {
            return PaginatedReportState(isLoading: false, error: result.error);
          }
          break;
        }

        // Handle empty first page - continue to next page in case of cursor issue
        if (pageCount == 0 && result.data.items.isEmpty) {
          AppLogger.warn(
            'First page returned empty. Checking if date range is correct or if cursor issue exists.',
            name: 'GeographicReportController',
          );
          if (result.data.hasMore && result.data.nextCursor != null) {
            hasMore = result.data.hasMore;
            nextCursor = result.data.nextCursor;
            pageCount++;
            continue;
          } else {
            break;
          }
        }

        allItems.addAll(result.data.items);
        hasMore = result.data.hasMore;
        nextCursor = result.data.nextCursor;
        pageCount++;
        
        if (!hasMore || nextCursor == null) break;
      }

      AppLogger.debug(
        'Loaded all geographic data: ${allItems.length} items across $pageCount pages',
        name: 'GeographicReportController',
      );
      return PaginatedReportState(
        items: allItems,
        hasMore: false,
        nextCursor: null,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Exception loading geographic report: $e',
        name: 'GeographicReportController',
        error: e,
        stackTrace: stackTrace,
      );
      return PaginatedReportState(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    // All data is loaded automatically, so this is a no-op
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.nextCursor == null) return;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitial());
  }
}

@Riverpod(keepAlive: true)
class InsurerPerformanceReportController extends _$InsurerPerformanceReportController {
  @override
  Future<PaginatedReportState<InsurerPerformanceReport>> build() async {
    return await _loadInitial();
  }

  Future<PaginatedReportState<InsurerPerformanceReport>> _loadInitial() async {
    try {
      AppLogger.debug(
        'Loading insurer performance report: ALL DATA (no date filter)',
        name: 'InsurerPerformanceReportController',
      );

      final repository = ref.read(reportingRepositoryProvider);
      
      // Load all data automatically
      var allItems = <InsurerPerformanceReport>[];
      String? nextCursor;
      bool hasMore = true;
      int pageCount = 0;
      const maxPageSize = 500;
      
      while (hasMore && pageCount < 100) {
        final result = await repository.fetchInsurerPerformanceReportPage(
          // No date range - show all data
          cursor: nextCursor,
          limit: maxPageSize,
        );

        if (result.isErr) {
          AppLogger.error(
            'Failed to load insurer performance report page ${pageCount + 1}: ${result.error}',
            name: 'InsurerPerformanceReportController',
            error: result.error,
          );
          if (allItems.isEmpty) {
            return PaginatedReportState(isLoading: false, error: result.error);
          }
          break;
        }

        // Handle empty first page - continue to next page in case of cursor issue
        if (pageCount == 0 && result.data.items.isEmpty) {
          AppLogger.warn(
            'First page returned empty. Checking if date range is correct or if cursor issue exists.',
            name: 'InsurerPerformanceReportController',
          );
          if (result.data.hasMore && result.data.nextCursor != null) {
            hasMore = result.data.hasMore;
            nextCursor = result.data.nextCursor;
            pageCount++;
            continue;
          } else {
            break;
          }
        }

        allItems.addAll(result.data.items);
        hasMore = result.data.hasMore;
        nextCursor = result.data.nextCursor;
        pageCount++;
        
        if (!hasMore || nextCursor == null) break;
      }

      AppLogger.debug(
        'Loaded all insurer performance data: ${allItems.length} items across $pageCount pages',
        name: 'InsurerPerformanceReportController',
      );
      return PaginatedReportState(
        items: allItems,
        hasMore: false,
        nextCursor: null,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Exception loading insurer performance report: $e',
        name: 'InsurerPerformanceReportController',
        error: e,
        stackTrace: stackTrace,
      );
      return PaginatedReportState(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    // All data is loaded automatically, so this is a no-op
    if (!state.hasValue) return;
    final currentState = state.value!;
    if (!currentState.hasMore || currentState.isLoadingMore || currentState.nextCursor == null) return;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitial());
  }
}
