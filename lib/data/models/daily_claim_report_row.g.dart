// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_claim_report_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyClaimReportRow _$DailyClaimReportRowFromJson(Map<String, dynamic> json) =>
    DailyClaimReportRow(
      reportDate: DateTime.parse(json['claim_date'] as String),
      claimsCaptured: (json['claims_captured'] as num).toInt(),
      avgMinutesToFirstContact: (json['avg_minutes_to_first_contact'] as num?)
          ?.toDouble(),
      compliantClaims: (json['compliant_claims'] as num).toInt(),
      contactedClaims: (json['contacted_claims'] as num).toInt(),
    );

Map<String, dynamic> _$DailyClaimReportRowToJson(
  DailyClaimReportRow instance,
) => <String, dynamic>{
  'claim_date': instance.reportDate.toIso8601String(),
  'claims_captured': instance.claimsCaptured,
  'avg_minutes_to_first_contact': instance.avgMinutesToFirstContact,
  'compliant_claims': instance.compliantClaims,
  'contacted_claims': instance.contactedClaims,
};
