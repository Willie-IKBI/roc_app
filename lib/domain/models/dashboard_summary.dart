import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'dashboard_summary.freezed.dart';

/// Dashboard summary aggregates (counts by status/priority)
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required int totalActiveClaims,
    required Map<ClaimStatus, int> statusCounts,
    required Map<PriorityLevel, int> priorityCounts,
    required int overdueCount,
    required int dueSoonCount,
    required int followUpCount,
  }) = _DashboardSummary;

  const DashboardSummary._();
}

