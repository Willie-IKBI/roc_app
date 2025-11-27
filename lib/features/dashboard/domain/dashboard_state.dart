import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required List<ClaimSummary> claims,
    required Map<ClaimStatus, int> statusCounts,
    required Map<PriorityLevel, int> priorityCounts,
    required List<ClaimSummary> overdueClaims,
    required List<ClaimSummary> needsFollowUp,
    required List<ClaimSummary> recentClaims,
    required int dueSoonCount,
  }) = _DashboardState;

  const DashboardState._();

  factory DashboardState.fromClaims(
    List<ClaimSummary> claims, {
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final statusCounts = <ClaimStatus, int>{};
    final priorityCounts = <PriorityLevel, int>{};

    final priorityThresholds = <PriorityLevel, Duration>{
      PriorityLevel.urgent: const Duration(hours: 2),
      PriorityLevel.high: const Duration(hours: 4),
      PriorityLevel.normal: const Duration(hours: 8),
      PriorityLevel.low: const Duration(hours: 24),
    };

    final overdueClaims = <ClaimSummary>[];
    final needsFollowUp = <ClaimSummary>[];
    int dueSoonCount = 0;

    for (final claim in claims) {
      statusCounts.update(claim.status, (value) => value + 1, ifAbsent: () => 1);
      priorityCounts.update(claim.priority, (value) => value + 1, ifAbsent: () => 1);

      final threshold = priorityThresholds[claim.priority] ??
          const Duration(hours: 8);
      if (claim.elapsed > threshold) {
        overdueClaims.add(claim);
      }

      final latestContact = claim.latestContactAt;
      final shouldFollowUp = latestContact == null
          ? true
          : reference.difference(latestContact) >= const Duration(hours: 4);

      if (shouldFollowUp &&
          claim.status != ClaimStatus.closed &&
          claim.status != ClaimStatus.cancelled) {
        needsFollowUp.add(claim);
      }
      if (!shouldFollowUp && claim.elapsed >= threshold * 0.5 && claim.elapsed <= threshold) {
        dueSoonCount += 1;
      }
    }

    final recentClaims = [...claims]
      ..sort((a, b) => b.slaStartedAt.compareTo(a.slaStartedAt));

    return DashboardState(
      claims: List.unmodifiable(claims),
      statusCounts: Map.unmodifiable(statusCounts),
      priorityCounts: Map.unmodifiable(priorityCounts),
      overdueClaims: List.unmodifiable(overdueClaims),
      needsFollowUp: List.unmodifiable(needsFollowUp.take(5)),
      recentClaims: List.unmodifiable(recentClaims.take(5)),
      dueSoonCount: dueSoonCount,
    );
  }

  int summaryCount(ClaimStatus status) => statusCounts[status] ?? 0;

  int priorityCount(PriorityLevel level) => priorityCounts[level] ?? 0;

  int get totalActiveClaims => claims.length;

  int get overdueCount => overdueClaims.length;

  int get followUpCount => needsFollowUp.length;

  int get dueSoon => dueSoonCount;
}

