import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_summary.dart';
import 'package:roc_app/domain/repositories/claim_repository.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/features/dashboard/controller/dashboard_controller.dart';

class _MockClaimRepository extends Mock implements ClaimRepository {}

void main() {
  late ProviderContainer container;
  late _MockClaimRepository repository;

  setUp(() {
    repository = _MockClaimRepository();
    container = ProviderContainer(overrides: [
      claimRepositoryProvider.overrideWithValue(repository),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  ClaimSummary buildSummary({
    required String id,
    required ClaimStatus status,
    required PriorityLevel priority,
    Duration elapsed = const Duration(hours: 1),
    DateTime? latestContact,
  }) {
    final nextRetry = latestContact?.add(const Duration(minutes: 120));
    return ClaimSummary(
      claimId: id,
      claimNumber: 'ROC-$id',
      clientFullName: 'Client $id',
      primaryPhone: '+271234567$id',
      insurerName: 'InsureCo',
      status: status,
      priority: priority,
      slaStartedAt: DateTime.utc(2025, 11, 7, 8).add(Duration(minutes: int.parse(id))),
      elapsed: elapsed,
      latestContactAt: latestContact,
      latestContactOutcome: latestContact == null ? null : 'answered',
      slaTarget: const Duration(minutes: 240),
      attemptCount: 1,
      retryInterval: const Duration(minutes: 120),
      nextRetryAt: nextRetry,
      readyForRetry: latestContact == null,
      addressShort: '123 Main St, City',
    );
  }

  group('DashboardController', () {
    test('build aggregates dashboard metrics on success', () async {
      final urgentOverdue = buildSummary(
        id: '1',
        status: ClaimStatus.inContact,
        priority: PriorityLevel.urgent,
        elapsed: const Duration(hours: 5),
        latestContact: null,
      );
      final normalFresh = buildSummary(
        id: '2',
        status: ClaimStatus.newClaim,
        priority: PriorityLevel.normal,
        elapsed: const Duration(hours: 1),
        latestContact: DateTime.now(),
      );

      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([urgentOverdue, normalFresh]));

      final state = await container.read(dashboardControllerProvider.future);

      expect(state.totalActiveClaims, 2);
      expect(state.overdueCount, 1);
      expect(state.followUpCount, 1);
      expect(state.summaryCount(ClaimStatus.inContact), 1);
      expect(state.priorityCount(PriorityLevel.urgent), 1);
      expect(state.recentClaims.first.claimId, '2');
      verify(() => repository.fetchQueue(status: null)).called(1);
    });

    test('throws DomainError when repository fails', () async {
      const error = UnknownError('failed');
      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => const Result.err(error));

      final provider = dashboardControllerProvider;
      await container.read(provider.notifier).refresh();
      final state = container.read(provider);
      expect(state.hasError, isTrue);
      expect(state.error, same(error));
    });

    test('refresh reloads data', () async {
      final initial = buildSummary(
        id: '1',
        status: ClaimStatus.newClaim,
        priority: PriorityLevel.normal,
      );
      final updated = buildSummary(
        id: '2',
        status: ClaimStatus.inContact,
        priority: PriorityLevel.high,
        elapsed: const Duration(hours: 6),
        latestContact: null,
      );

      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([initial]));

      final provider = dashboardControllerProvider;
      expect(await container.read(provider.future), isNotNull);

      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([updated]));

      await container.read(provider.notifier).refresh();

      final state = container.read(provider);
      expect(state.hasValue, isTrue);
      expect(state.value?.totalActiveClaims, 1);
      expect(state.value?.overdueCount, 1);
    });
  });
}

