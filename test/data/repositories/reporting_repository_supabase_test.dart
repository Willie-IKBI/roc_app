import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/reporting_remote_data_source.dart';
import 'package:roc_app/data/models/daily_claim_report_row.dart';
import 'package:roc_app/data/repositories/reporting_repository_supabase.dart';

class _MockReportingRemoteDataSource extends Mock
    implements ReportingRemoteDataSource {}

void main() {
  late _MockReportingRemoteDataSource remote;
  late ReportingRepositorySupabase repository;

  setUp(() {
    remote = _MockReportingRemoteDataSource();
    repository = ReportingRepositorySupabase(remote);
  });

  final row = DailyClaimReportRow(
    reportDate: DateTime.utc(2025, 11, 7),
    claimsCaptured: 5,
    avgMinutesToFirstContact: 45.5,
    compliantClaims: 4,
    contactedClaims: 5,
  );

  test('fetchDailyReports maps rows to domain', () async {
    final startDate = DateTime.utc(2025, 11, 1);
    final endDate = DateTime.utc(2025, 11, 7);
    when(() => remote.fetchDailyReports(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
        .thenAnswer((_) async => Result.ok([row]));

    final result = await repository.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
    );

    expect(result.isOk, isTrue);
    expect(result.data, hasLength(1));
    final report = result.data.first;
    expect(report.date, row.reportDate);
    expect(report.claimsCaptured, 5);
    expect(report.averageMinutesToFirstContact, 45.5);
    verify(() => remote.fetchDailyReports(startDate: startDate, endDate: endDate)).called(1);
  });

  test('fetchDailyReports propagates error', () async {
    final startDate = DateTime.utc(2025, 11, 1);
    final endDate = DateTime.utc(2025, 11, 7);
    final error = UnknownError(Exception('boom'));
    when(() => remote.fetchDailyReports(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
        .thenAnswer((_) async => Result.err(error));

    final result = await repository.fetchDailyReports(
      startDate: startDate,
      endDate: endDate,
    );

    expect(result.isErr, isTrue);
    expect(result.error, same(error));
  });
}


