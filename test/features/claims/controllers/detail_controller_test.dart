import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim.dart';
import 'package:roc_app/domain/models/claim_item.dart';
import 'package:roc_app/domain/models/contact_attempt.dart';
import 'package:roc_app/domain/repositories/claim_repository.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/domain/value_objects/contact_method.dart';
import 'package:roc_app/features/claims/controller/detail_controller.dart';

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

  Claim buildClaim() {
    return Claim(
      id: 'claim-1',
      tenantId: 'tenant-1',
      claimNumber: 'ROC-1',
      insurerId: 'insurer-1',
      clientId: 'client-1',
      addressId: 'address-1',
      status: ClaimStatus.inContact,
      priority: PriorityLevel.high,
      damageCause: DamageCause.powerSurge,
      surgeProtectionAtDb: true,
      surgeProtectionAtPlug: false,
      agentId: 'agent-1',
      slaStartedAt: DateTime.utc(2025, 11, 7, 9),
      closedAt: null,
      notesPublic: null,
      notesInternal: 'Follow up with client',
      createdAt: DateTime.utc(2025, 11, 6, 9),
      updatedAt: DateTime.utc(2025, 11, 7, 11),
      items: [
        ClaimItem(
          id: 'item-1',
          claimId: 'claim-1',
          brand: 'Samsung',
          color: 'Black',
          warranty: WarrantyStatus.inWarranty,
          serialOrModel: 'QA55Q70',
          notes: 'Damaged by surge',
          createdAt: DateTime.utc(2025, 11, 7, 9),
          updatedAt: DateTime.utc(2025, 11, 7, 9),
        ),
      ],
      latestContact: ContactAttempt(
        id: 'contact-1',
        tenantId: 'tenant-1',
        claimId: 'claim-1',
        attemptedBy: 'agent-1',
        attemptedAt: DateTime.utc(2025, 11, 7, 10),
        method: ContactMethod.phone,
        outcome: ContactOutcome.answered,
        notes: 'Client confirmed availability',
      ),
    );
  }

  group('build', () {
    test('returns claim when repository succeeds', () async {
      final claim = buildClaim();
      when(() => repository.fetchById('claim-1'))
          .thenAnswer((_) async => Result.ok(claim));

      final result = await container
          .read(claimDetailControllerProvider('claim-1').future);

      expect(result, equals(claim));
      verify(() => repository.fetchById('claim-1')).called(1);
    });

    test('throws DomainError when repository fails', () async {
      final error = const NotFoundError('claim');
      when(() => repository.fetchById('missing'))
          .thenAnswer((_) async => Result.err(error));

      final provider = claimDetailControllerProvider('missing');
      await container.read(provider.notifier).refresh();

      final state = container.read(provider);
      expect(state.hasError, isTrue);
      expect(state.error, same(error));
      verify(() => repository.fetchById('missing')).called(2);
    });
  });

  group('refresh', () {
    test('reloads data', () async {
      final initial = buildClaim();
      final updated = initial.copyWith(notesInternal: 'Updated note');

      when(() => repository.fetchById('claim-1'))
          .thenAnswer((_) async => Result.ok(initial));

      final provider = claimDetailControllerProvider('claim-1');
      expect(await container.read(provider.future), equals(initial));

      when(() => repository.fetchById('claim-1'))
          .thenAnswer((_) async => Result.ok(updated));

      await container.read(provider.notifier).refresh();

      final state = container.read(provider);
      expect(state.hasValue, isTrue);
      expect(state.value, equals(updated));
    });
  });
}

