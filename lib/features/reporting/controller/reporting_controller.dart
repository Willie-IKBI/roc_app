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
class ReportingController extends _$ReportingController {
  @override
  Future<ReportingState> build() async {
    final window = ref.watch(reportingWindowControllerProvider);
    return _load(window);
  }

  Future<void> changeWindow(ReportingWindow window) async {
    state = const AsyncLoading();
    ref.read(reportingWindowControllerProvider.notifier).setWindow(window);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final window = ref.read(reportingWindowControllerProvider);
    state = await AsyncValue.guard(() => _load(window));
  }

  Future<ReportingState> _load(ReportingWindow window) async {
    final repository = ref.read(reportingRepositoryProvider);
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final startDate = today.subtract(Duration(days: window.days - 1));
    final endDate = today.add(const Duration(days: 1));
    
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

