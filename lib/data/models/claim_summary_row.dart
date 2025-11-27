import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/claim_summary.dart';
import '../../domain/value_objects/claim_enums.dart';

part 'claim_summary_row.g.dart';

@JsonSerializable()
class ClaimSummaryRow {
  ClaimSummaryRow({
    required this.claimId,
    required this.claimNumber,
    required this.clientFullName,
    required this.primaryPhone,
    required this.insurerName,
    required this.status,
    required this.priority,
    required this.slaStartedAt,
    required this.elapsedMinutes,
    this.latestContactAttemptAt,
    this.latestContactOutcome,
    required this.slaTargetMinutes,
    required this.attemptCount,
    required this.retryIntervalMinutes,
    this.nextRetryAt,
    required this.readyForRetry,
    required this.addressShort,
  });

  factory ClaimSummaryRow.fromJson(Map<String, dynamic> json) => _$ClaimSummaryRowFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimSummaryRowToJson(this);

  @JsonKey(name: 'claim_id')
  final String claimId;

  @JsonKey(name: 'claim_number')
  final String claimNumber;

  @JsonKey(name: 'client_full_name')
  final String clientFullName;

  @JsonKey(name: 'primary_phone')
  final String primaryPhone;

  @JsonKey(name: 'insurer_name')
  final String insurerName;

  final String status;

  final String priority;

  @JsonKey(name: 'sla_started_at')
  final DateTime slaStartedAt;

  @JsonKey(name: 'elapsed_minutes')
  final double elapsedMinutes;

  @JsonKey(name: 'latest_contact_attempt_at')
  final DateTime? latestContactAttemptAt;

  @JsonKey(name: 'latest_contact_outcome')
  final String? latestContactOutcome;

  @JsonKey(name: 'sla_target_minutes')
  final int slaTargetMinutes;

  @JsonKey(name: 'attempt_count')
  final int attemptCount;

  @JsonKey(name: 'retry_interval_minutes')
  final int retryIntervalMinutes;

  @JsonKey(name: 'next_retry_at')
  final DateTime? nextRetryAt;

  @JsonKey(name: 'ready_for_retry')
  final bool readyForRetry;

  @JsonKey(name: 'address_short')
  final String addressShort;

  ClaimSummary toDomain() => ClaimSummary(
        claimId: claimId,
        claimNumber: claimNumber,
        clientFullName: clientFullName,
        primaryPhone: primaryPhone,
        insurerName: insurerName,
        status: ClaimStatus.fromJson(status),
        priority: PriorityLevel.fromJson(priority),
        slaStartedAt: slaStartedAt,
        elapsed: Duration(minutes: elapsedMinutes.round()),
        latestContactAt: latestContactAttemptAt,
        latestContactOutcome: latestContactOutcome,
        slaTarget: Duration(minutes: slaTargetMinutes),
        attemptCount: attemptCount,
        retryInterval: Duration(minutes: retryIntervalMinutes),
        nextRetryAt: nextRetryAt,
        readyForRetry: readyForRetry,
        addressShort: addressShort,
      );
}

