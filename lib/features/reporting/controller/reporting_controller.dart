import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/daily_claim_report.dart';
import '../../../data/repositories/reporting_repository_supabase.dart';
import '../domain/reporting_state.dart';

part 'reporting_controller.g.dart';

@riverpod
class ReportingWindowController extends _$ReportingWindowController {
  @override
  ReportingWindow build() => ReportingWindow.last7;

  void setWindow(ReportingWindow window) {
    if (state == window) return;
    state = window;
  }
}

@riverpod
class CustomDateRangeController extends _$CustomDateRangeController {
  @override
  ({DateTime startDate, DateTime endDate})? build() => null;

  void setDateRange(DateTime startDate, DateTime endDate) {
    state = (startDate: startDate, endDate: endDate);
  }

  void clear() {
    state = null;
  }
}

@riverpod
class ReportingController extends _$ReportingController {
  @override
  Future<ReportingState> build() async {
    final window = ref.watch(reportingWindowControllerProvider);
    final customDateRange = ref.watch(customDateRangeControllerProvider);
    return _load(window, customDateRange);
  }

  Future<void> changeWindow(ReportingWindow window) async {
    state = const AsyncLoading();
    ref.read(reportingWindowControllerProvider.notifier).setWindow(window);
    // Clear custom date range when selecting a preset
    ref.read(customDateRangeControllerProvider.notifier).clear();
  }

  Future<void> setCustomDateRange(DateTime startDate, DateTime endDate) async {
    state = const AsyncLoading();
    ref.read(customDateRangeControllerProvider.notifier).setDateRange(startDate, endDate);
    // Set window to last30 as a fallback (won't be used since custom range is set)
    ref.read(reportingWindowControllerProvider.notifier).setWindow(ReportingWindow.last30);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final window = ref.read(reportingWindowControllerProvider);
    final customDateRange = ref.read(customDateRangeControllerProvider);
    state = await AsyncValue.guard(() => _load(window, customDateRange));
  }

  Future<ReportingState> _load(
    ReportingWindow window,
    ({DateTime startDate, DateTime endDate})? customDateRange,
  ) async {
    final repository = ref.read(reportingRepositoryProvider);
    
    DateTime startDate;
    DateTime endDate;
    
    if (customDateRange != null) {
      // Use custom date range
      startDate = customDateRange.startDate;
      endDate = customDateRange.endDate;
    } else {
      // Use preset window
      final now = DateTime.now().toUtc();
      final today = DateTime.utc(now.year, now.month, now.day);
      startDate = today.subtract(Duration(days: window.days - 1));
      // Use end of today (23:59:59.999) instead of tomorrow to include all of today's data
      endDate = DateTime.utc(today.year, today.month, today.day, 23, 59, 59, 999);
    }
    
    // Date range is now required (enforced at method signature level)
    final result = await repository.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
      limit: 90,
    );
    if (result.isErr) {
      throw result.error;
    }
    final reports = result.data;
    return _aggregate(reports, window);
  }

  ReportingState _aggregate(
    List<DailyClaimReport> reports,
    ReportingWindow window,
  ) {
    final totalClaims =
        reports.fold<int>(0, (sum, report) => sum + report.claimsCaptured);

    final minutesValues = reports
        .where((report) =>
            report.averageMinutesToFirstContact != null &&
            report.claimsCaptured > 0)
        .toList();

    double? weightedAverage;
    if (minutesValues.isNotEmpty) {
      final numerator = minutesValues.fold<double>(
        0,
        (acc, report) =>
            acc +
            (report.averageMinutesToFirstContact! * report.claimsCaptured),
      );
      final denominator =
          minutesValues.fold<int>(0, (acc, report) => acc + report.claimsCaptured);
      if (denominator > 0) {
        weightedAverage = numerator / denominator;
      }
    }

    final compliantTotal =
        reports.fold<int>(0, (sum, report) => sum + report.compliantClaims);
    final complianceRate =
        totalClaims == 0 ? 0.0 : compliantTotal / totalClaims.toDouble();

    return ReportingState(
      reports: reports,
      totalClaims: totalClaims,
      averageMinutesToFirstContact: weightedAverage,
      complianceRate: complianceRate,
      window: window,
    );
  }
}

