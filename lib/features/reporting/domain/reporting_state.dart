import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/daily_claim_report.dart';

part 'reporting_state.freezed.dart';

enum ReportingWindow {
  last7,
  last14,
  last30,
}

extension ReportingWindowX on ReportingWindow {
  int get days {
    switch (this) {
      case ReportingWindow.last7:
        return 7;
      case ReportingWindow.last14:
        return 14;
      case ReportingWindow.last30:
        return 30;
    }
  }

  String get label {
    switch (this) {
      case ReportingWindow.last7:
        return 'Last 7 days';
      case ReportingWindow.last14:
        return 'Last 14 days';
      case ReportingWindow.last30:
        return 'Last 30 days';
    }
  }
}

@freezed
abstract class ReportingState with _$ReportingState {
  const factory ReportingState({
    required List<DailyClaimReport> reports,
    required int totalClaims,
    double? averageMinutesToFirstContact,
    required double complianceRate,
    required ReportingWindow window,
  }) = _ReportingState;
}

