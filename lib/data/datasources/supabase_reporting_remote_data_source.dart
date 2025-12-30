import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/daily_claim_report_row.dart';
import '../models/report_row_models.dart';
import 'reporting_remote_data_source.dart';

class SupabaseReportingRemoteDataSource implements ReportingRemoteDataSource {
  SupabaseReportingRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<DailyClaimReportRow>>> fetchDailyReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _client.from('v_claims_reporting').select(
        'claim_date, claims_captured, avg_minutes_to_first_contact, compliant_claims, contacted_claims',
      );

      if (startDate != null) {
        query = query.gte('claim_date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('claim_date', endDate.toIso8601String());
      }

      final response = await query.order('claim_date', ascending: false).limit(90);

      final rows = (response as List<dynamic>)
          .map(
            (row) => DailyClaimReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<AgentPerformanceReportRow>>> fetchAgentPerformanceReport() async {
    try {
      final response = await _client.rpc('get_agent_performance_report').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => AgentPerformanceReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      // If RPC doesn't exist, fall back to direct query
      return _fetchAgentPerformanceDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<AgentPerformanceReportRow>>> _fetchAgentPerformanceDirect() async {
    try {
      // Fetch claims with agent info
      final claimsResponse = await _client
          .from('claims')
          .select('id, agent_id, sla_started_at, status, closed_at')
          .not('agent_id', 'is', null)
          .limit(10000);

      // Fetch profiles for agent names
      final profilesResponse = await _client
          .from('profiles')
          .select('id, full_name')
          .limit(1000);

      final profilesMap = <String, String>{};
      for (final profile in profilesResponse as List<dynamic>) {
        final id = profile['id'] as String;
        final name = profile['full_name'] as String? ?? 'Unknown';
        profilesMap[id] = name;
      }

      // Fetch first contact attempts
      final contactAttemptsResponse = await _client
          .from('contact_attempts')
          .select('claim_id, attempted_at, outcome')
          .order('attempted_at', ascending: true)
          .limit(10000);

      // Group contact attempts by claim to find first contact
      final firstContactMap = <String, Map<String, dynamic>>{};
      for (final attempt in contactAttemptsResponse as List<dynamic>) {
        final claimId = attempt['claim_id'] as String;
        if (!firstContactMap.containsKey(claimId)) {
          firstContactMap[claimId] = attempt as Map<String, dynamic>;
        }
      }

      // Aggregate by agent
      final agentMap = <String, AgentPerformanceData>{};
      final now = DateTime.now().toUtc();

      for (final claim in claimsResponse as List<dynamic>) {
        final agentId = claim['agent_id'] as String;
        final claimId = claim['id'] as String;
        final slaStartedAt = DateTime.parse(claim['sla_started_at'] as String);
        final status = claim['status'] as String;
        final closedAt = claim['closed_at'] != null
            ? DateTime.parse(claim['closed_at'] as String)
            : null;

        final data = agentMap.putIfAbsent(
          agentId,
          () => AgentPerformanceData(agentId: agentId),
        );

        data.claimsHandled++;
        if (status == 'closed') {
          data.claimsClosed++;
          if (closedAt != null) {
            final resolutionTime = closedAt.difference(slaStartedAt).inMinutes.toDouble();
            data.totalResolutionTimeMinutes += resolutionTime;
            data.resolutionCount++;
          }
        }

        // Check first contact
        final firstContact = firstContactMap[claimId];
        if (firstContact != null) {
          final attemptedAt = DateTime.parse(firstContact['attempted_at'] as String);
          final minutesToContact = attemptedAt.difference(slaStartedAt).inMinutes.toDouble();
          data.totalFirstContactMinutes += minutesToContact;
          data.firstContactCount++;
          if (minutesToContact <= 240) {
            data.compliantClaims++;
          }

          // Track contact success
          final outcome = firstContact['outcome'] as String?;
          if (outcome == 'answered') {
            data.successfulContacts++;
          }
          data.totalContacts++;
        }
      }

      // Convert to rows
      final rows = agentMap.values.map((data) {
        final agentName = profilesMap[data.agentId] ?? 'Unknown';
        return AgentPerformanceReportRow(
          agentId: data.agentId,
          agentName: agentName,
          claimsHandled: data.claimsHandled,
          averageMinutesToFirstContact: data.firstContactCount > 0
              ? data.totalFirstContactMinutes / data.firstContactCount
              : null,
          slaComplianceRate: data.claimsHandled > 0
              ? data.compliantClaims / data.claimsHandled
              : 0.0,
          claimsClosed: data.claimsClosed,
          averageResolutionTimeMinutes: data.resolutionCount > 0
              ? data.totalResolutionTimeMinutes / data.resolutionCount
              : null,
          contactSuccessRate: data.totalContacts > 0
              ? data.successfulContacts / data.totalContacts
              : 0.0,
        );
      }).toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<StatusDistributionReportRow>>> fetchStatusDistributionReport() async {
    try {
      final response = await _client.rpc('get_status_distribution_report').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => StatusDistributionReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return _fetchStatusDistributionDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<StatusDistributionReportRow>>> _fetchStatusDistributionDirect() async {
    try {
      // Group by status using PostgREST
      final response = await _client
          .from('claims')
          .select('status, created_at, closed_at')
          .limit(10000);

      // Aggregate in Dart for now
      final statusMap = <String, StatusDistributionData>{};
      final now = DateTime.now().toUtc();

      for (final row in response as List<dynamic>) {
        final status = row['status'] as String;
        final createdAt = DateTime.parse(row['created_at'] as String);
        final closedAt = row['closed_at'] != null
            ? DateTime.parse(row['closed_at'] as String)
            : null;

        final data = statusMap.putIfAbsent(
          status,
          () => StatusDistributionData(status: status),
        );

        data.count++;
        final timeDiff = (closedAt ?? now).difference(createdAt).inHours.toDouble();
        data.totalTimeHours += timeDiff;
        if (now.difference(createdAt).inDays > 7) {
          data.stuckCount++;
        }
      }

      final total = statusMap.values.fold<int>(0, (sum, data) => sum + data.count);
      final rows = statusMap.values.map((data) {
        return StatusDistributionReportRow(
          status: data.status,
          count: data.count,
          percentage: total > 0 ? data.count / total : 0.0,
          averageTimeInStatusHours: data.count > 0 ? data.totalTimeHours / data.count : null,
          stuckClaims: data.stuckCount,
        );
      }).toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<DamageCauseReportRow>>> fetchDamageCauseReport() async {
    try {
      final response = await _client.rpc('get_damage_cause_report').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => DamageCauseReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return _fetchDamageCauseDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<DamageCauseReportRow>>> _fetchDamageCauseDirect() async {
    try {
      final response = await _client
          .from('claims')
          .select('damage_cause, created_at, closed_at')
          .limit(10000);

      final causeMap = <String, DamageCauseData>{};
      final now = DateTime.now().toUtc();

      for (final row in response as List<dynamic>) {
        final cause = row['damage_cause'] as String;
        final createdAt = DateTime.parse(row['created_at'] as String);
        final closedAt = row['closed_at'] != null
            ? DateTime.parse(row['closed_at'] as String)
            : null;

        final data = causeMap.putIfAbsent(
          cause,
          () => DamageCauseData(cause: cause),
        );

        data.count++;
        final timeDiff = (closedAt ?? now).difference(createdAt).inHours.toDouble();
        data.totalTimeHours += timeDiff;
      }

      final total = causeMap.values.fold<int>(0, (sum, data) => sum + data.count);
      final rows = causeMap.values.map((data) {
        return DamageCauseReportRow(
          damageCause: data.cause,
          count: data.count,
          percentage: total > 0 ? data.count / total : 0.0,
          averageResolutionTimeHours: data.count > 0 ? data.totalTimeHours / data.count : null,
        );
      }).toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<GeographicReportRow>>> fetchGeographicReport({
    String? groupBy,
  }) async {
    try {
      final response = await _client.rpc('get_geographic_report', params: {
        'group_by': groupBy ?? 'province',
      }).select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => GeographicReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return _fetchGeographicDirect(groupBy: groupBy);
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<GeographicReportRow>>> _fetchGeographicDirect({
    String? groupBy,
  }) async {
    try {
      final groupByField = groupBy ?? 'province';
      final response = await _client
          .from('claims')
          .select('''
            id,
            address:addresses!claims_address_id_fkey(province, city, suburb, lat, lng)
          ''')
          .limit(10000);

      final geoMap = <String, GeographicData>{};
      final now = DateTime.now().toUtc();

      for (final row in response as List<dynamic>) {
        final address = row['address'] as Map<String, dynamic>?;
        if (address == null) continue;

        final province = address['province'] as String?;
        final city = address['city'] as String?;
        final suburb = address['suburb'] as String?;
        final lat = address['lat'] != null ? double.tryParse(address['lat'].toString()) : null;
        final lng = address['lng'] != null ? double.tryParse(address['lng'].toString()) : null;

        String? key;
        String? keyProvince;
        String? keyCity;
        String? keySuburb;

        if (groupByField == 'suburb' && suburb != null && suburb.isNotEmpty) {
          key = suburb;
          keyProvince = province;
          keyCity = city;
          keySuburb = suburb;
        } else if (groupByField == 'city' && city != null && city.isNotEmpty) {
          key = city;
          keyProvince = province;
          keyCity = city;
        } else if (province != null && province.isNotEmpty) {
          key = province;
          keyProvince = province;
        } else {
          continue; // Skip if no valid grouping field
        }

        final data = geoMap.putIfAbsent(
          key!,
          () => GeographicData(
            province: keyProvince,
            city: keyCity,
            suburb: keySuburb,
          ),
        );

        data.claimCount++;
        if (lat != null && lng != null) {
          data.latSum += lat;
          data.lngSum += lng;
          data.coordCount++;
        }
      }

      final total = geoMap.values.fold<int>(0, (sum, data) => sum + data.claimCount);
      final rows = geoMap.values.map((data) {
        return GeographicReportRow(
          province: data.province,
          city: data.city,
          suburb: data.suburb,
          claimCount: data.claimCount,
          percentage: total > 0 ? data.claimCount / total : 0.0,
          averageLat: data.coordCount > 0 ? data.latSum / data.coordCount : null,
          averageLng: data.coordCount > 0 ? data.lngSum / data.coordCount : null,
        );
      }).toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<InsurerPerformanceReportRow>>> fetchInsurerPerformanceReport() async {
    try {
      final response = await _client.rpc('get_insurer_performance_report').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => InsurerPerformanceReportRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (_) {
      return _fetchInsurerPerformanceDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<InsurerPerformanceReportRow>>> _fetchInsurerPerformanceDirect() async {
    try {
      final response = await _client
          .from('insurers')
          .select('''
            id,
            name,
            claims(id, status, created_at, closed_at, damage_cause)
          ''')
          .limit(1000);

      final insurerMap = <String, InsurerPerformanceData>{};

      for (final insurer in response as List<dynamic>) {
        final insurerId = insurer['id'] as String;
        final insurerName = insurer['name'] as String;
        final claims = insurer['claims'] as List<dynamic>? ?? [];

        final data = insurerMap.putIfAbsent(
          insurerId,
          () => InsurerPerformanceData(
            insurerId: insurerId,
            insurerName: insurerName,
          ),
        );

        final damageCauses = <String>{};
        for (final claim in claims) {
          data.totalClaims++;
          final status = claim['status'] as String? ?? 'new';
          final damageCause = claim['damage_cause'] as String? ?? 'other';
          damageCauses.add(damageCause);

          if (status == 'closed') {
            data.closedClaims++;
            final createdAt = DateTime.parse(claim['created_at'] as String);
            final closedAt = claim['closed_at'] != null
                ? DateTime.parse(claim['closed_at'] as String)
                : null;
            if (closedAt != null) {
              final resolutionTime = closedAt.difference(createdAt).inHours.toDouble();
              data.totalResolutionTimeHours += resolutionTime;
              data.resolutionCount++;
            }
          } else if (status == 'new') {
            data.newClaims++;
          } else if (status == 'scheduled') {
            data.scheduledClaims++;
          } else if (status == 'in_contact') {
            data.inContactClaims++;
          }
        }

        data.uniqueDamageCauseCount = damageCauses.length;
      }

      final rows = insurerMap.values.map((data) {
        return InsurerPerformanceReportRow(
          insurerId: data.insurerId,
          insurerName: data.insurerName,
          totalClaims: data.totalClaims,
          closedClaims: data.closedClaims,
          newClaims: data.newClaims,
          scheduledClaims: data.scheduledClaims,
          inContactClaims: data.inContactClaims,
          averageResolutionTimeHours: data.resolutionCount > 0
              ? data.totalResolutionTimeHours / data.resolutionCount
              : null,
          uniqueDamageCauseCount: data.uniqueDamageCauseCount,
        );
      }).toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<InsurerDamageCauseRow>>> fetchInsurerDamageCauseBreakdown() async {
    try {
      final response = await _client.rpc('get_insurer_damage_cause_breakdown').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => InsurerDamageCauseRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (_) {
      return _fetchInsurerDamageCauseDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<InsurerDamageCauseRow>>> _fetchInsurerDamageCauseDirect() async {
    try {
      final response = await _client
          .from('insurers')
          .select('''
            id,
            name,
            claims(damage_cause)
          ''')
          .limit(1000);

      final breakdownMap = <String, Map<String, InsurerDamageCauseData>>{};

      for (final insurer in response as List<dynamic>) {
        final insurerId = insurer['id'] as String;
        final insurerName = insurer['name'] as String;
        final claims = insurer['claims'] as List<dynamic>? ?? [];

        final causeMap = breakdownMap.putIfAbsent(
          insurerId,
          () => <String, InsurerDamageCauseData>{},
        );

        for (final claim in claims) {
          final damageCause = claim['damage_cause'] as String? ?? 'other';
          final data = causeMap.putIfAbsent(
            damageCause,
            () => InsurerDamageCauseData(
              insurerId: insurerId,
              insurerName: insurerName,
              damageCause: damageCause,
            ),
          );
          data.claimCount++;
        }
      }

      final rows = <InsurerDamageCauseRow>[];
      for (final causeMap in breakdownMap.values) {
        for (final data in causeMap.values) {
          final totalClaims = causeMap.values.fold<int>(
            0,
            (sum, d) => sum + d.claimCount,
          );
          rows.add(
            InsurerDamageCauseRow(
              insurerId: data.insurerId,
              insurerName: data.insurerName,
              damageCause: data.damageCause,
              claimCount: data.claimCount,
              percentage: totalClaims > 0 ? data.claimCount / totalClaims : 0.0,
            ),
          );
        }
      }

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<InsurerStatusBreakdownRow>>> fetchInsurerStatusBreakdown() async {
    try {
      final response = await _client.rpc('get_insurer_status_breakdown').select();
      final rows = (response as List<dynamic>)
          .map(
            (row) => InsurerStatusBreakdownRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);
      return Result.ok(rows);
    } on PostgrestException catch (_) {
      return _fetchInsurerStatusDirect();
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  Future<Result<List<InsurerStatusBreakdownRow>>> _fetchInsurerStatusDirect() async {
    try {
      final response = await _client
          .from('insurers')
          .select('''
            id,
            name,
            claims(status)
          ''')
          .limit(1000);

      final breakdownMap = <String, Map<String, InsurerStatusData>>{};

      for (final insurer in response as List<dynamic>) {
        final insurerId = insurer['id'] as String;
        final insurerName = insurer['name'] as String;
        final claims = insurer['claims'] as List<dynamic>? ?? [];

        final statusMap = breakdownMap.putIfAbsent(
          insurerId,
          () => <String, InsurerStatusData>{},
        );

        for (final claim in claims) {
          final status = claim['status'] as String? ?? 'new';
          final data = statusMap.putIfAbsent(
            status,
            () => InsurerStatusData(
              insurerId: insurerId,
              insurerName: insurerName,
              status: status,
            ),
          );
          data.claimCount++;
        }
      }

      final rows = <InsurerStatusBreakdownRow>[];
      for (final statusMap in breakdownMap.values) {
        for (final data in statusMap.values) {
          final totalClaims = statusMap.values.fold<int>(
            0,
            (sum, d) => sum + d.claimCount,
          );
          rows.add(
            InsurerStatusBreakdownRow(
              insurerId: data.insurerId,
              insurerName: data.insurerName,
              status: data.status,
              claimCount: data.claimCount,
              percentage: totalClaims > 0 ? data.claimCount / totalClaims : 0.0,
            ),
          );
        }
      }

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

// Helper classes for aggregation
class StatusDistributionData {
  StatusDistributionData({required this.status});

  final String status;
  int count = 0;
  double totalTimeHours = 0.0;
  int stuckCount = 0;
}

class DamageCauseData {
  DamageCauseData({required this.cause});

  final String cause;
  int count = 0;
  double totalTimeHours = 0.0;
}

class GeographicData {
  GeographicData({
    this.province,
    this.city,
    this.suburb,
  });

  final String? province;
  final String? city;
  final String? suburb;
  int claimCount = 0;
  double latSum = 0.0;
  double lngSum = 0.0;
  int coordCount = 0;
}

class AgentPerformanceData {
  AgentPerformanceData({required this.agentId});

  final String agentId;
  int claimsHandled = 0;
  int claimsClosed = 0;
  double totalResolutionTimeMinutes = 0.0;
  int resolutionCount = 0;
  double totalFirstContactMinutes = 0.0;
  int firstContactCount = 0;
  int compliantClaims = 0;
  int successfulContacts = 0;
  int totalContacts = 0;
}

class InsurerPerformanceData {
  InsurerPerformanceData({
    required this.insurerId,
    required this.insurerName,
  });

  final String insurerId;
  final String insurerName;
  int totalClaims = 0;
  int closedClaims = 0;
  int newClaims = 0;
  int scheduledClaims = 0;
  int inContactClaims = 0;
  double totalResolutionTimeHours = 0.0;
  int resolutionCount = 0;
  int uniqueDamageCauseCount = 0;
}

class InsurerDamageCauseData {
  InsurerDamageCauseData({
    required this.insurerId,
    required this.insurerName,
    required this.damageCause,
  });

  final String insurerId;
  final String insurerName;
  final String damageCause;
  int claimCount = 0;
}

class InsurerStatusData {
  InsurerStatusData({
    required this.insurerId,
    required this.insurerName,
    required this.status,
  });

  final String insurerId;
  final String insurerName;
  final String status;
  int claimCount = 0;
}


