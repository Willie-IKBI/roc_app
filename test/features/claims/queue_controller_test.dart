import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_summary.dart';
import 'package:roc_app/domain/models/paginated_result.dart';
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

  ClaimSummary buildSummary({
    String claimId = 'claim-1',
    ClaimStatus status = ClaimStatus.newClaim,
  }) {
    return ClaimSummary(
      claimId: claimId,
      claimNumber: 'ROC-$claimId',
      clientFullName: 'Test Client',
      primaryPhone: '+27123456789',
      insurerName: 'Test Insurer',
      status: status,
      priority: PriorityLevel.normal,
      slaStartedAt: DateTime.utc(2025, 1, 15, 10),
      elapsed: const Duration(minutes: 42),
      latestContactAt: DateTime.utc(2025, 1, 15, 11),
      latestContactOutcome: 'answered',
      slaTarget: const Duration(minutes: 240),
      attemptCount: 2,
      retryInterval: const Duration(minutes: 120),
      nextRetryAt: DateTime.utc(2025, 1, 15, 12, 30),
      readyForRetry: false,
      addressShort: '123 Test St',
    );
  }

  group('ClaimsQueueController', () {
    test('loads first page successfully', () async {
      final items = [buildSummary(claimId: 'claim-1'), buildSummary(claimId: 'claim-2')];
      final page = PaginatedResult<ClaimSummary>(
        items: items,
        nextCursor: 'cursor-1',
        hasMore: true,
      );

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(page));

      final provider = claimsQueueControllerProvider();
      // The build method returns the final state
      final returnedState = await container.read(provider.future);
      
      expect(returnedState.items, equals(items));
      expect(returnedState.nextCursor, equals('cursor-1'));
      expect(returnedState.hasMore, isTrue);
      expect(returnedState.isLoading, isFalse);
      expect(returnedState.error, isNull);
      verify(() => repository.fetchQueuePage(cursor: null, limit: 50, status: null)).called(1);
    });

    test('loadNextPage appends items to existing list', () async {
      final firstPageItems = [buildSummary(claimId: 'claim-1')];
      final secondPageItems = [buildSummary(claimId: 'claim-2'), buildSummary(claimId: 'claim-3')];

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: firstPageItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      when(() => repository.fetchQueuePage(
            cursor: 'cursor-1',
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: secondPageItems,
            nextCursor: 'cursor-2',
            hasMore: false,
          )));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.future);

      final controller = container.read(provider.notifier);
      await controller.loadNextPage();

      // Read state from controller after loadNextPage
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(3));
      expect(state?.items[0].claimId, equals('claim-1'));
      expect(state?.items[1].claimId, equals('claim-2'));
      expect(state?.items[2].claimId, equals('claim-3'));
      expect(state?.nextCursor, equals('cursor-2'));
      expect(state?.hasMore, isFalse);
      expect(state?.isLoadingMore, isFalse);
    });

    test('error during loadNextPage preserves existing items', () async {
      final firstPageItems = [buildSummary(claimId: 'claim-1')];
      final error = const NetworkError('Connection failed');

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: firstPageItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      when(() => repository.fetchQueuePage(
            cursor: 'cursor-1',
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.err(error));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.future);

      final controller = container.read(provider.notifier);
      await controller.loadNextPage();

      // Read state directly from controller
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(1));
      expect(state?.items[0].claimId, equals('claim-1'));
      expect(state?.error, equals(error));
      expect(state?.isLoadingMore, isFalse);
    });

    test('refresh resets to first page', () async {
      final initialItems = [buildSummary(claimId: 'claim-1')];
      final refreshedItems = [buildSummary(claimId: 'claim-2')];

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: initialItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.future);

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: refreshedItems,
            nextCursor: 'cursor-2',
            hasMore: false,
          )));

      final controller = container.read(provider.notifier);
      await controller.refresh();

      // Read state from controller after refresh
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(1));
      expect(state?.items[0].claimId, equals('claim-2'));
      expect(state?.nextCursor, equals('cursor-2'));
      expect(state?.hasMore, isFalse);
    });

    test('loadNextPage does nothing when already loading', () async {
      final items = [buildSummary(claimId: 'claim-1')];

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: items,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.future);

      final controller = container.read(provider.notifier);
      // Set loading more state manually
      container.read(provider.notifier).state = AsyncValue.data(
        container.read(provider).asData!.value.copyWith(isLoadingMore: true),
      );

      await controller.loadNextPage();

      // Should not call repository again
      verifyNever(() => repository.fetchQueuePage(
            cursor: 'cursor-1',
            limit: 50,
            status: null,
          ));
    });

    test('loadNextPage does nothing when no more data', () async {
      final items = [buildSummary(claimId: 'claim-1')];

      when(() => repository.fetchQueuePage(
            cursor: null,
            limit: 50,
            status: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: items,
            nextCursor: null,
            hasMore: false,
          )));

      final provider = claimsQueueControllerProvider();
      await container.read(provider.future);

      final controller = container.read(provider.notifier);
      await controller.loadNextPage();

      // Should not call repository again
      verify(() => repository.fetchQueuePage(
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
            status: any(named: 'status'),
          )).called(1); // Only the initial load
    });
  });
}

