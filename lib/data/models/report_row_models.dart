import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/report_models.dart';
import '../../domain/value_objects/claim_enums.dart';

part 'report_row_models.g.dart';

// Agent Performance Report Row
@JsonSerializable()
class AgentPerformanceReportRow {
  AgentPerformanceReportRow({
    required this.agentId,
    this.agentName,
    required this.claimsHandled,
    this.averageMinutesToFirstContact,
    required this.slaComplianceRate,
    required this.claimsClosed,
    this.averageResolutionTimeMinutes,
    required this.contactSuccessRate,
  });

  factory AgentPerformanceReportRow.fromJson(Map<String, dynamic> json) =>
      _$AgentPerformanceReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$AgentPerformanceReportRowToJson(this);

  @JsonKey(name: 'agent_id')
  final String agentId;

  @JsonKey(name: 'agent_name')
  final String? agentName;

  @JsonKey(name: 'claims_handled')
  final int claimsHandled;

  @JsonKey(name: 'avg_minutes_to_first_contact')
  final double? averageMinutesToFirstContact;

  @JsonKey(name: 'sla_compliance_rate')
  final double slaComplianceRate;

  @JsonKey(name: 'claims_closed')
  final int claimsClosed;

  @JsonKey(name: 'avg_resolution_time_minutes')
  final double? averageResolutionTimeMinutes;

  @JsonKey(name: 'contact_success_rate')
  final double contactSuccessRate;

  AgentPerformanceReport toDomain() {
    return AgentPerformanceReport(
      agentId: agentId,
      agentName: agentName ?? 'Unknown',
      claimsHandled: claimsHandled,
      averageMinutesToFirstContact: averageMinutesToFirstContact,
      slaComplianceRate: slaComplianceRate,
      claimsClosed: claimsClosed,
      averageResolutionTimeMinutes: averageResolutionTimeMinutes,
      contactSuccessRate: contactSuccessRate,
    );
  }
}

// Status Distribution Report Row
@JsonSerializable()
class StatusDistributionReportRow {
  StatusDistributionReportRow({
    required this.status,
    required this.count,
    required this.percentage,
    this.averageTimeInStatusHours,
    required this.stuckClaims,
  });

  factory StatusDistributionReportRow.fromJson(Map<String, dynamic> json) =>
      _$StatusDistributionReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDistributionReportRowToJson(this);

  final String status;
  final int count;
  final double percentage;

  @JsonKey(name: 'avg_time_in_status_hours')
  final double? averageTimeInStatusHours;

  @JsonKey(name: 'stuck_claims')
  final int stuckClaims;

  StatusDistributionReport toDomain() {
    return StatusDistributionReport(
      status: ClaimStatus.fromJson(status),
      count: count,
      percentage: percentage,
      averageTimeInStatusHours: averageTimeInStatusHours,
      stuckClaims: stuckClaims,
    );
  }
}

// Damage Cause Report Row
@JsonSerializable()
class DamageCauseReportRow {
  DamageCauseReportRow({
    required this.damageCause,
    required this.count,
    required this.percentage,
    this.averageResolutionTimeHours,
  });

  factory DamageCauseReportRow.fromJson(Map<String, dynamic> json) =>
      _$DamageCauseReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$DamageCauseReportRowToJson(this);

  @JsonKey(name: 'damage_cause')
  final String damageCause;

  final int count;
  final double percentage;

  @JsonKey(name: 'avg_resolution_time_hours')
  final double? averageResolutionTimeHours;

  DamageCauseReport toDomain() {
    return DamageCauseReport(
      cause: DamageCause.fromJson(damageCause),
      count: count,
      percentage: percentage,
      averageResolutionTimeHours: averageResolutionTimeHours,
    );
  }
}

// Geographic Report Row
@JsonSerializable()
class GeographicReportRow {
  GeographicReportRow({
    this.province,
    this.city,
    this.suburb,
    required this.claimCount,
    required this.percentage,
    this.averageLat,
    this.averageLng,
  });

  factory GeographicReportRow.fromJson(Map<String, dynamic> json) =>
      _$GeographicReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$GeographicReportRowToJson(this);

  final String? province;
  final String? city;
  final String? suburb;

  @JsonKey(name: 'claim_count')
  final int claimCount;

  final double percentage;

  @JsonKey(name: 'avg_lat')
  final double? averageLat;

  @JsonKey(name: 'avg_lng')
  final double? averageLng;

  GeographicReport toDomain() {
    return GeographicReport(
      province: province,
      city: city,
      suburb: suburb,
      claimCount: claimCount,
      percentage: percentage,
      averageLat: averageLat,
      averageLng: averageLng,
    );
  }
}

// Insurer Performance Report Row
@JsonSerializable()
class InsurerPerformanceReportRow {
  InsurerPerformanceReportRow({
    required this.insurerId,
    required this.insurerName,
    required this.totalClaims,
    required this.closedClaims,
    required this.newClaims,
    required this.scheduledClaims,
    required this.inContactClaims,
    this.averageResolutionTimeHours,
    required this.uniqueDamageCauseCount,
  });

  factory InsurerPerformanceReportRow.fromJson(Map<String, dynamic> json) =>
      _$InsurerPerformanceReportRowFromJson(json);

  Map<String, dynamic> toJson() => _$InsurerPerformanceReportRowToJson(this);

  @JsonKey(name: 'id')
  final String insurerId;

  @JsonKey(name: 'insurer_name')
  final String insurerName;

  @JsonKey(name: 'total_claims')
  final int totalClaims;

  @JsonKey(name: 'closed_claims')
  final int closedClaims;

  @JsonKey(name: 'new_claims')
  final int newClaims;

  @JsonKey(name: 'scheduled_claims')
  final int scheduledClaims;

  @JsonKey(name: 'in_contact_claims')
  final int inContactClaims;

  @JsonKey(name: 'avg_resolution_time_hours')
  final double? averageResolutionTimeHours;

  @JsonKey(name: 'unique_damage_cause_count')
  final int uniqueDamageCauseCount;

  InsurerPerformanceReport toDomain({
    List<InsurerDamageCauseBreakdown> damageCauseBreakdown = const [],
    List<InsurerStatusBreakdown> statusBreakdown = const [],
  }) {
    return InsurerPerformanceReport(
      insurerId: insurerId,
      insurerName: insurerName,
      totalClaims: totalClaims,
      closedClaims: closedClaims,
      newClaims: newClaims,
      scheduledClaims: scheduledClaims,
      inContactClaims: inContactClaims,
      averageResolutionTimeHours: averageResolutionTimeHours,
      uniqueDamageCauseCount: uniqueDamageCauseCount,
      damageCauseBreakdown: damageCauseBreakdown,
      statusBreakdown: statusBreakdown,
    );
  }
}

// Insurer Damage Cause Breakdown Row
@JsonSerializable()
class InsurerDamageCauseRow {
  InsurerDamageCauseRow({
    required this.insurerId,
    required this.insurerName,
    required this.damageCause,
    required this.claimCount,
    required this.percentage,
  });

  factory InsurerDamageCauseRow.fromJson(Map<String, dynamic> json) =>
      _$InsurerDamageCauseRowFromJson(json);

  Map<String, dynamic> toJson() => _$InsurerDamageCauseRowToJson(this);

  @JsonKey(name: 'insurer_id')
  final String insurerId;

  @JsonKey(name: 'insurer_name')
  final String insurerName;

  @JsonKey(name: 'damage_cause')
  final String damageCause;

  @JsonKey(name: 'claim_count')
  final int claimCount;

  final double percentage;

  InsurerDamageCauseBreakdown toDomain() {
    return InsurerDamageCauseBreakdown(
      insurerId: insurerId,
      insurerName: insurerName,
      damageCause: DamageCause.fromJson(damageCause),
      claimCount: claimCount,
      percentage: percentage,
    );
  }
}

// Insurer Status Breakdown Row
@JsonSerializable()
class InsurerStatusBreakdownRow {
  InsurerStatusBreakdownRow({
    required this.insurerId,
    required this.insurerName,
    required this.status,
    required this.claimCount,
    required this.percentage,
  });

  factory InsurerStatusBreakdownRow.fromJson(Map<String, dynamic> json) =>
      _$InsurerStatusBreakdownRowFromJson(json);

  Map<String, dynamic> toJson() => _$InsurerStatusBreakdownRowToJson(this);

  @JsonKey(name: 'insurer_id')
  final String insurerId;

  @JsonKey(name: 'insurer_name')
  final String insurerName;

  final String status;

  @JsonKey(name: 'claim_count')
  final int claimCount;

  final double percentage;

  InsurerStatusBreakdown toDomain() {
    return InsurerStatusBreakdown(
      insurerId: insurerId,
      insurerName: insurerName,
      status: ClaimStatus.fromJson(status),
      claimCount: claimCount,
      percentage: percentage,
    );
  }
}

