import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_summary.dart';
import 'package:roc_app/domain/repositories/claim_repository.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/features/claims/controller/queue_controller.dart';

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

  ClaimSummary buildSummary({ClaimStatus status = ClaimStatus.newClaim}) {
    return ClaimSummary(
      claimId: 'claim-1',
      claimNumber: 'ROC-1',
      clientFullName: 'Thandi Nkosi',
      primaryPhone: '+27123456789',
      insurerName: 'InsureCo',
      status: status,
      priority: PriorityLevel.normal,
      slaStartedAt: DateTime.utc(2025, 11, 7, 9),
      elapsed: const Duration(minutes: 42),
      latestContactAt: DateTime.utc(2025, 11, 7, 10),
      latestContactOutcome: 'answered',
      slaTarget: const Duration(minutes: 240),
      attemptCount: 2,
      retryInterval: const Duration(minutes: 120),
      nextRetryAt: DateTime.utc(2025, 11, 7, 11, 30),
      readyForRetry: false,
      addressShort: '15 Sunset Road, Bryanston',
    );
  }

  group('build', () {
    test('returns mapped data when repository succeeds', () async {
      final summary = buildSummary(status: ClaimStatus.inContact);
      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([summary]));

      final result = await container
          .read(claimsQueueControllerProvider(status: ClaimStatus.inContact).future);

      expect(result, equals([summary]));
      verify(() => repository.fetchQueue(status: ClaimStatus.inContact)).called(1);
    });

    test('throws DomainError when repository fails', () async {
      final error = const PermissionDeniedError();
      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.err(error));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.notifier).refresh();

      final state = container.read(provider);
      expect(state.hasError, isTrue);
      expect(state.error, same(error));
      verify(() => repository.fetchQueue(status: null)).called(2);
    });
  });

  group('refresh', () {
    test('updates state with latest data', () async {
      final initial = buildSummary(status: ClaimStatus.newClaim);
      final refreshed = buildSummary(status: ClaimStatus.closed);

      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([initial]));

      final provider = claimsQueueControllerProvider();
      expect(await container.read(provider.future), equals([initial]));

      when(() => repository.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([refreshed]));

      await container.read(provider.notifier).refresh();

      final state = container.read(provider);
      expect(state.hasValue, isTrue);
      expect(state.value, equals([refreshed]));
    });
  });
}

