// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_summary_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimSummaryRow _$ClaimSummaryRowFromJson(Map<String, dynamic> json) =>
    ClaimSummaryRow(
      claimId: json['claim_id'] as String,
      claimNumber: json['claim_number'] as String,
      clientFullName: json['client_full_name'] as String,
      primaryPhone: json['primary_phone'] as String,
      insurerName: json['insurer_name'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      slaStartedAt: DateTime.parse(json['sla_started_at'] as String),
      elapsedMinutes: (json['elapsed_minutes'] as num).toDouble(),
      latestContactAttemptAt: json['latest_contact_attempt_at'] == null
          ? null
          : DateTime.parse(json['latest_contact_attempt_at'] as String),
      latestContactOutcome: json['latest_contact_outcome'] as String?,
      slaTargetMinutes: (json['sla_target_minutes'] as num).toInt(),
      attemptCount: (json['attempt_count'] as num).toInt(),
      retryIntervalMinutes: (json['retry_interval_minutes'] as num).toInt(),
      nextRetryAt: json['next_retry_at'] == null
          ? null
          : DateTime.parse(json['next_retry_at'] as String),
      readyForRetry: json['ready_for_retry'] as bool,
      addressShort: json['address_short'] as String,
    );

Map<String, dynamic> _$ClaimSummaryRowToJson(ClaimSummaryRow instance) =>
    <String, dynamic>{
      'claim_id': instance.claimId,
      'claim_number': instance.claimNumber,
      'client_full_name': instance.clientFullName,
      'primary_phone': instance.primaryPhone,
      'insurer_name': instance.insurerName,
      'status': instance.status,
      'priority': instance.priority,
      'sla_started_at': instance.slaStartedAt.toIso8601String(),
      'elapsed_minutes': instance.elapsedMinutes,
      'latest_contact_attempt_at': instance.latestContactAttemptAt
          ?.toIso8601String(),
      'latest_contact_outcome': instance.latestContactOutcome,
      'sla_target_minutes': instance.slaTargetMinutes,
      'attempt_count': instance.attemptCount,
      'retry_interval_minutes': instance.retryIntervalMinutes,
      'next_retry_at': instance.nextRetryAt?.toIso8601String(),
      'ready_for_retry': instance.readyForRetry,
      'address_short': instance.addressShort,
    };
