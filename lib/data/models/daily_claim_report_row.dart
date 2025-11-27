import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/daily_claim_report.dart';

part 'daily_claim_report_row.g.dart';

@JsonSerializable()
class DailyClaimReportRow {
  DailyClaimReportRow({
    required this.reportDate,
    required this.claimsCaptured,
    this.avgMinutesToFirstContact,
    required this.compliantClaims,
    required this.contactedClaims,
  });

  factory DailyClaimReportRow.fromJson(Map<String, dynamic> json) =>
      _$DailyClaimReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$DailyClaimReportRowToJson(this);

  @JsonKey(name: 'claim_date')
  final DateTime reportDate;

  @JsonKey(name: 'claims_captured')
  final int claimsCaptured;

  @JsonKey(name: 'avg_minutes_to_first_contact')
  final double? avgMinutesToFirstContact;

  @JsonKey(name: 'compliant_claims')
  final int compliantClaims;

  @JsonKey(name: 'contacted_claims')
  final int contactedClaims;

  DailyClaimReport toDomain() {
    return DailyClaimReport(
      date: reportDate,
      claimsCaptured: claimsCaptured,
      averageMinutesToFirstContact: avgMinutesToFirstContact,
      compliantClaims: compliantClaims,
      contactedClaims: contactedClaims,
    );
  }
}


