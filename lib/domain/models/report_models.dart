import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'report_models.freezed.dart';

// Agent Performance Report Models
@freezed
abstract class AgentPerformanceReport with _$AgentPerformanceReport {
  const factory AgentPerformanceReport({
    required String agentId,
    required String agentName,
    required int claimsHandled,
    double? averageMinutesToFirstContact,
    required double slaComplianceRate,
    required int claimsClosed,
    double? averageResolutionTimeMinutes,
    required double contactSuccessRate,
  }) = _AgentPerformanceReport;

  const AgentPerformanceReport._();
}

// Status Distribution Report Models
@freezed
abstract class StatusDistributionReport with _$StatusDistributionReport {
  const factory StatusDistributionReport({
    required ClaimStatus status,
    required int count,
    required double percentage,
    double? averageTimeInStatusHours,
    required int stuckClaims, // Claims >7 days in status
  }) = _StatusDistributionReport;

  const StatusDistributionReport._();
}

// Damage Cause Analysis Report Models
@freezed
abstract class DamageCauseReport with _$DamageCauseReport {
  const factory DamageCauseReport({
    required DamageCause cause,
    required int count,
    required double percentage,
    double? averageResolutionTimeHours,
  }) = _DamageCauseReport;

  const DamageCauseReport._();
}

// Geographic Distribution Report Models
@freezed
abstract class GeographicReport with _$GeographicReport {
  const factory GeographicReport({
    String? province,
    String? city,
    String? suburb,
    required int claimCount,
    required double percentage,
    double? averageLat,
    double? averageLng,
  }) = _GeographicReport;

  const GeographicReport._();
}

// Insurer Performance Report Models
@freezed
abstract class InsurerPerformanceReport with _$InsurerPerformanceReport {
  const factory InsurerPerformanceReport({
    required String insurerId,
    required String insurerName,
    required int totalClaims,
    required int closedClaims,
    required int newClaims,
    required int scheduledClaims,
    required int inContactClaims,
    double? averageResolutionTimeHours,
    required int uniqueDamageCauseCount,
    @Default(<InsurerDamageCauseBreakdown>[])
    List<InsurerDamageCauseBreakdown> damageCauseBreakdown,
    @Default(<InsurerStatusBreakdown>[])
    List<InsurerStatusBreakdown> statusBreakdown,
  }) = _InsurerPerformanceReport;

  const InsurerPerformanceReport._();
}

@freezed
abstract class InsurerDamageCauseBreakdown with _$InsurerDamageCauseBreakdown {
  const factory InsurerDamageCauseBreakdown({
    required String insurerId,
    required String insurerName,
    required DamageCause damageCause,
    required int claimCount,
    required double percentage,
  }) = _InsurerDamageCauseBreakdown;

  const InsurerDamageCauseBreakdown._();
}

@freezed
abstract class InsurerStatusBreakdown with _$InsurerStatusBreakdown {
  const factory InsurerStatusBreakdown({
    required String insurerId,
    required String insurerName,
    required ClaimStatus status,
    required int claimCount,
    required double percentage,
  }) = _InsurerStatusBreakdown;

  const InsurerStatusBreakdown._();
}

