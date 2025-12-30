// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_row_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentPerformanceReportRow _$AgentPerformanceReportRowFromJson(
  Map<String, dynamic> json,
) => AgentPerformanceReportRow(
  agentId: json['agent_id'] as String,
  agentName: json['agent_name'] as String?,
  claimsHandled: (json['claims_handled'] as num).toInt(),
  averageMinutesToFirstContact: (json['avg_minutes_to_first_contact'] as num?)
      ?.toDouble(),
  slaComplianceRate: (json['sla_compliance_rate'] as num).toDouble(),
  claimsClosed: (json['claims_closed'] as num).toInt(),
  averageResolutionTimeMinutes: (json['avg_resolution_time_minutes'] as num?)
      ?.toDouble(),
  contactSuccessRate: (json['contact_success_rate'] as num).toDouble(),
);

Map<String, dynamic> _$AgentPerformanceReportRowToJson(
  AgentPerformanceReportRow instance,
) => <String, dynamic>{
  'agent_id': instance.agentId,
  'agent_name': instance.agentName,
  'claims_handled': instance.claimsHandled,
  'avg_minutes_to_first_contact': instance.averageMinutesToFirstContact,
  'sla_compliance_rate': instance.slaComplianceRate,
  'claims_closed': instance.claimsClosed,
  'avg_resolution_time_minutes': instance.averageResolutionTimeMinutes,
  'contact_success_rate': instance.contactSuccessRate,
};

StatusDistributionReportRow _$StatusDistributionReportRowFromJson(
  Map<String, dynamic> json,
) => StatusDistributionReportRow(
  status: json['status'] as String,
  count: (json['count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  averageTimeInStatusHours: (json['avg_time_in_status_hours'] as num?)
      ?.toDouble(),
  stuckClaims: (json['stuck_claims'] as num).toInt(),
);

Map<String, dynamic> _$StatusDistributionReportRowToJson(
  StatusDistributionReportRow instance,
) => <String, dynamic>{
  'status': instance.status,
  'count': instance.count,
  'percentage': instance.percentage,
  'avg_time_in_status_hours': instance.averageTimeInStatusHours,
  'stuck_claims': instance.stuckClaims,
};

DamageCauseReportRow _$DamageCauseReportRowFromJson(
  Map<String, dynamic> json,
) => DamageCauseReportRow(
  damageCause: json['damage_cause'] as String,
  count: (json['count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
  averageResolutionTimeHours: (json['avg_resolution_time_hours'] as num?)
      ?.toDouble(),
);

Map<String, dynamic> _$DamageCauseReportRowToJson(
  DamageCauseReportRow instance,
) => <String, dynamic>{
  'damage_cause': instance.damageCause,
  'count': instance.count,
  'percentage': instance.percentage,
  'avg_resolution_time_hours': instance.averageResolutionTimeHours,
};

GeographicReportRow _$GeographicReportRowFromJson(Map<String, dynamic> json) =>
    GeographicReportRow(
      province: json['province'] as String?,
      city: json['city'] as String?,
      suburb: json['suburb'] as String?,
      claimCount: (json['claim_count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      averageLat: (json['avg_lat'] as num?)?.toDouble(),
      averageLng: (json['avg_lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeographicReportRowToJson(
  GeographicReportRow instance,
) => <String, dynamic>{
  'province': instance.province,
  'city': instance.city,
  'suburb': instance.suburb,
  'claim_count': instance.claimCount,
  'percentage': instance.percentage,
  'avg_lat': instance.averageLat,
  'avg_lng': instance.averageLng,
};

InsurerPerformanceReportRow _$InsurerPerformanceReportRowFromJson(
  Map<String, dynamic> json,
) => InsurerPerformanceReportRow(
  insurerId: json['id'] as String,
  insurerName: json['insurer_name'] as String,
  totalClaims: (json['total_claims'] as num).toInt(),
  closedClaims: (json['closed_claims'] as num).toInt(),
  newClaims: (json['new_claims'] as num).toInt(),
  scheduledClaims: (json['scheduled_claims'] as num).toInt(),
  inContactClaims: (json['in_contact_claims'] as num).toInt(),
  averageResolutionTimeHours: (json['avg_resolution_time_hours'] as num?)
      ?.toDouble(),
  uniqueDamageCauseCount: (json['unique_damage_cause_count'] as num).toInt(),
);

Map<String, dynamic> _$InsurerPerformanceReportRowToJson(
  InsurerPerformanceReportRow instance,
) => <String, dynamic>{
  'id': instance.insurerId,
  'insurer_name': instance.insurerName,
  'total_claims': instance.totalClaims,
  'closed_claims': instance.closedClaims,
  'new_claims': instance.newClaims,
  'scheduled_claims': instance.scheduledClaims,
  'in_contact_claims': instance.inContactClaims,
  'avg_resolution_time_hours': instance.averageResolutionTimeHours,
  'unique_damage_cause_count': instance.uniqueDamageCauseCount,
};

InsurerDamageCauseRow _$InsurerDamageCauseRowFromJson(
  Map<String, dynamic> json,
) => InsurerDamageCauseRow(
  insurerId: json['insurer_id'] as String,
  insurerName: json['insurer_name'] as String,
  damageCause: json['damage_cause'] as String,
  claimCount: (json['claim_count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$InsurerDamageCauseRowToJson(
  InsurerDamageCauseRow instance,
) => <String, dynamic>{
  'insurer_id': instance.insurerId,
  'insurer_name': instance.insurerName,
  'damage_cause': instance.damageCause,
  'claim_count': instance.claimCount,
  'percentage': instance.percentage,
};

InsurerStatusBreakdownRow _$InsurerStatusBreakdownRowFromJson(
  Map<String, dynamic> json,
) => InsurerStatusBreakdownRow(
  insurerId: json['insurer_id'] as String,
  insurerName: json['insurer_name'] as String,
  status: json['status'] as String,
  claimCount: (json['claim_count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$InsurerStatusBreakdownRowToJson(
  InsurerStatusBreakdownRow instance,
) => <String, dynamic>{
  'insurer_id': instance.insurerId,
  'insurer_name': instance.insurerName,
  'status': instance.status,
  'claim_count': instance.claimCount,
  'percentage': instance.percentage,
};
