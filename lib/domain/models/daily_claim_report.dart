import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_claim_report.freezed.dart';

@freezed
abstract class DailyClaimReport with _$DailyClaimReport {
  const factory DailyClaimReport({
    required DateTime date,
    required int claimsCaptured,
    double? averageMinutesToFirstContact,
    required int compliantClaims,
    required int contactedClaims,
  }) = _DailyClaimReport;

  const DailyClaimReport._();

  double get complianceRate {
    if (claimsCaptured == 0) return 0;
    return compliantClaims / claimsCaptured;
  }
}


