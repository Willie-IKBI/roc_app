import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/assignments_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_summary.dart';
import 'package:roc_app/domain/models/paginated_result.dart';
import 'package:roc_app/domain/repositories/assignments_repository.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/features/assignments/controller/assignment_controller.dart';

class _MockAssignmentsRepository extends Mock implements AssignmentsRepository {}

void main() {
  late ProviderContainer container;
  late _MockAssignmentsRepository repository;

  setUp(() {
    repository = _MockAssignmentsRepository();
    container = ProviderContainer(overrides: [
      assignmentsRepositoryProvider.overrideWithValue(repository),
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

  group('AssignableJobsController', () {
    test('loads first page with filters', () async {
      final items = [buildSummary(claimId: 'claim-1')];
      final page = PaginatedResult<ClaimSummary>(
        items: items,
        nextCursor: 'cursor-1',
        hasMore: true,
      );
      final dateFrom = DateTime.utc(2025, 1, 15);
      final dateTo = DateTime.utc(2025, 1, 16);

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: ClaimStatus.newClaim,
            assignedFilter: false,
            technicianId: 'tech-1',
            dateFrom: dateFrom,
            dateTo: dateTo,
          )).thenAnswer((_) async => Result.ok(page));

      final provider = assignableJobsControllerProvider(
        statusFilter: ClaimStatus.newClaim,
        assignedFilter: false,
        technicianIdFilter: 'tech-1',
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      // The build method returns the final state
      final returnedState = await container.read(provider.future);
      
      expect(returnedState.items, equals(items));
      expect(returnedState.nextCursor, equals('cursor-1'));
      expect(returnedState.hasMore, isTrue);
      expect(returnedState.isLoading, isFalse);
      expect(returnedState.statusFilter, equals(ClaimStatus.newClaim));
      expect(returnedState.assignedFilter, isFalse);
      expect(returnedState.technicianIdFilter, equals('tech-1'));
      verify(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: ClaimStatus.newClaim,
            assignedFilter: false,
            technicianId: 'tech-1',
            dateFrom: dateFrom,
            dateTo: dateTo,
          )).called(1);
    });

    test('filters reset cursor on updateFilters', () async {
      final firstPageItems = [buildSummary(claimId: 'claim-1')];
      final filteredItems = [buildSummary(claimId: 'claim-2')];

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: null,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: firstPageItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      final provider = assignableJobsControllerProvider();
      await container.read(provider.future);

      when(() => repository.fetchAssignableJobsPage(
            cursor: null, // Cursor reset when filters change
            limit: 50,
            status: ClaimStatus.scheduled,
            assignedFilter: true,
            technicianId: null,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: filteredItems,
            nextCursor: 'cursor-2',
            hasMore: false,
          )));

      final controller = container.read(provider.notifier);
      await controller.updateFilters(
        statusFilter: ClaimStatus.scheduled,
        assignedFilter: true,
      );

      // Read state from controller after updateFilters
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(1));
      expect(state?.items[0].claimId, equals('claim-2'));
      expect(state?.nextCursor, equals('cursor-2'));
      expect(state?.statusFilter, equals(ClaimStatus.scheduled));
      expect(state?.assignedFilter, isTrue);
    });

    test('loadNextPage appends items with current filters', () async {
      final firstPageItems = [buildSummary(claimId: 'claim-1')];
      final secondPageItems = [buildSummary(claimId: 'claim-2')];
      final dateFrom = DateTime.utc(2025, 1, 15);

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: null,
            dateFrom: dateFrom,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: firstPageItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      when(() => repository.fetchAssignableJobsPage(
            cursor: 'cursor-1',
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: null,
            dateFrom: dateFrom,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: secondPageItems,
            nextCursor: null,
            hasMore: false,
          )));

      final provider = assignableJobsControllerProvider(dateFrom: dateFrom);
      await container.read(provider.future);

      final controller = container.read(provider.notifier);
      await controller.loadNextPage();

      // Read state from controller after loadNextPage
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(2));
      expect(state?.hasMore, isFalse);
      expect(state?.nextCursor, isNull);
      // Verify filters are preserved
      expect(state?.dateFrom, equals(dateFrom));
    });

    test('error during loadNextPage preserves existing items', () async {
      final firstPageItems = [buildSummary(claimId: 'claim-1')];
      final error = const NetworkError('Connection failed');

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: null,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: firstPageItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      when(() => repository.fetchAssignableJobsPage(
            cursor: 'cursor-1',
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: null,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.err(error));

      final provider = assignableJobsControllerProvider();
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

    test('refresh resets to first page with current filters', () async {
      final initialItems = [buildSummary(claimId: 'claim-1')];
      final refreshedItems = [buildSummary(claimId: 'claim-2')];
      final technicianId = 'tech-1';

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: technicianId,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: initialItems,
            nextCursor: 'cursor-1',
            hasMore: true,
          )));

      final provider = assignableJobsControllerProvider(technicianIdFilter: technicianId);
      await container.read(provider.future);

      when(() => repository.fetchAssignableJobsPage(
            cursor: null,
            limit: 50,
            status: null,
            assignedFilter: null,
            technicianId: technicianId,
            dateFrom: null,
            dateTo: null,
          )).thenAnswer((_) async => Result.ok(PaginatedResult(
            items: refreshedItems,
            nextCursor: null,
            hasMore: false,
          )));

      final controller = container.read(provider.notifier);
      await controller.refresh();

      // Read state from controller after refresh
      final state = controller.state.asData?.value;
      expect(state?.items.length, equals(1));
      expect(state?.items[0].claimId, equals('claim-2'));
      expect(state?.technicianIdFilter, equals(technicianId));
    });
  });
}

