import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/reporting_repository_supabase.dart';
import 'package:roc_app/domain/models/daily_claim_report.dart';
import 'package:roc_app/domain/repositories/reporting_repository.dart';
import 'package:roc_app/features/reporting/controller/reporting_controller.dart';
import 'package:roc_app/features/reporting/domain/reporting_state.dart';

class _MockReportingRepository extends Mock implements ReportingRepository {}

void main() {
  late ProviderContainer container;
  late _MockReportingRepository repository;

  setUp(() {
    repository = _MockReportingRepository();
    container = ProviderContainer(
      overrides: [
        reportingRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  DailyClaimReport buildReport({
    required DateTime date,
    required int claims,
    double? avgMinutes,
    required int compliant,
    required int contacted,
  }) {
    return DailyClaimReport(
      date: date,
      claimsCaptured: claims,
      averageMinutesToFirstContact: avgMinutes,
      compliantClaims: compliant,
      contactedClaims: contacted,
    );
  }

  test('build aggregates reporting data', () async {
    final reports = [
      buildReport(
        date: DateTime.utc(2025, 11, 7),
        claims: 5,
        avgMinutes: 40,
        compliant: 4,
        contacted: 5,
      ),
      buildReport(
        date: DateTime.utc(2025, 11, 6),
        claims: 3,
        avgMinutes: 55,
        compliant: 2,
        contacted: 3,
      ),
    ];

    when(() => repository.fetchDailyReports(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
        .thenAnswer((_) async => Result.ok(reports));

    final result = await container.read(reportingControllerProvider.future);

    expect(result.totalClaims, 8);
    expect(result.averageMinutesToFirstContact, closeTo(45.625, 0.001));
    expect(result.complianceRate, closeTo(0.75, 0.001));
    expect(result.reports, reports);
    expect(result.window, ReportingWindow.last7);
  });

  test('refresh propagates errors', () async {
    final error = UnknownError('boom');
    when(() => repository.fetchDailyReports(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')))
        .thenAnswer((_) async => Result.err(error));

    final provider = reportingControllerProvider;
    await container.read(provider.notifier).refresh();
    final state = container.read(provider);

    expect(state.hasError, isTrue);
    expect(state.error, same(error));
  });
}


