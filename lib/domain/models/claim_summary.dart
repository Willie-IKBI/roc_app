import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'claim_summary.freezed.dart';

@freezed
abstract class ClaimSummary with _$ClaimSummary {
  const factory ClaimSummary({
    required String claimId,
    required String claimNumber,
    required String clientFullName,
    required String primaryPhone,
    required String insurerName,
    required ClaimStatus status,
    required PriorityLevel priority,
    required DateTime slaStartedAt,
    required Duration elapsed,
    DateTime? latestContactAt,
    String? latestContactOutcome,
    required Duration slaTarget,
    required int attemptCount,
    required Duration retryInterval,
    DateTime? nextRetryAt,
    required bool readyForRetry,
    required String addressShort,
  }) = _ClaimSummary;

  const ClaimSummary._();

  bool get isBreached => elapsed > slaTarget;

  bool get isDueSoon {
    if (isBreached) return false;
    final thresholdMinutes = (slaTarget.inMinutes * 0.75).round();
    return elapsed.inMinutes >= thresholdMinutes;
  }

  Duration? get timeUntilRetry {
    if (readyForRetry || nextRetryAt == null) return null;
    final remaining = nextRetryAt!.difference(DateTime.now());
    if (remaining.isNegative) return null;
    return remaining;
  }
}

