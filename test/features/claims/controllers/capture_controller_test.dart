import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_draft.dart';
import 'package:roc_app/domain/repositories/claim_repository.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/features/claims/controller/capture_controller.dart';

class _MockClaimRepository extends Mock implements ClaimRepository {}

void main() {
  late ProviderContainer container;
  late _MockClaimRepository repository;
  final draft = ClaimDraft(
    tenantId: 'tenant-1',
    claimNumber: 'ROC-1',
    insurerId: 'insurer-1',
    clientId: 'client-1',
    addressId: 'address-1',
    items: const [ClaimItemDraft(brand: 'Samsung', warranty: WarrantyStatus.inWarranty)],
  );

  setUpAll(() {
    registerFallbackValue(draft);
  });

  setUp(() {
    repository = _MockClaimRepository();
    container = ProviderContainer(overrides: [
      claimRepositoryProvider.overrideWithValue(repository),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  test('submit emits AsyncData with claim id on success', () async {
    when(() => repository.createClaim(draft: any(named: 'draft')))
        .thenAnswer((_) async => const Result.ok('claim-1'));

    final provider = claimCaptureControllerProvider;
    expect(await container.read(provider.future), isNull);

    await container.read(provider.notifier).submit(draft);

    final state = container.read(provider);
    expect(state.hasValue, isTrue);
    expect(state.value, equals('claim-1'));
    verify(() => repository.createClaim(draft: draft)).called(1);
  });

  test('submit emits AsyncError when repository fails', () async {
    final error = const ValidationError('invalid data');
    when(() => repository.createClaim(draft: any(named: 'draft')))
        .thenAnswer((_) async => Result.err(error));

    final provider = claimCaptureControllerProvider;
    await container.read(provider.future);

    await container.read(provider.notifier).submit(draft);

    final state = container.read(provider);
    expect(state.hasError, isTrue);
    expect(state.error, equals(error));
    verify(() => repository.createClaim(draft: draft)).called(1);
  });

  test('reset clears state back to null', () async {
    when(() => repository.createClaim(draft: any(named: 'draft')))
        .thenAnswer((_) async => const Result.ok('claim-1'));

    final notifier = container.read(claimCaptureControllerProvider.notifier);
    await notifier.submit(draft);
    expect(container.read(claimCaptureControllerProvider).value, 'claim-1');

    notifier.reset();

    final state = container.read(claimCaptureControllerProvider);
    expect(state.hasValue, isTrue);
    expect(state.value, isNull);
  });
}

