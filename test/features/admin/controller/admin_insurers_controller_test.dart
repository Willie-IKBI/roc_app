import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/domain/models/insurer.dart';
import 'package:roc_app/domain/repositories/insurer_admin_repository.dart';
import 'package:roc_app/features/admin/controller/insurers_controller.dart';
import 'package:roc_app/data/repositories/insurer_admin_repository_supabase.dart';

class _MockRepository extends Mock implements InsurerAdminRepository {}

void main() {
  late ProviderContainer container;
  late _MockRepository repository;
  final insurer = Insurer(
    id: 'insurer-1',
    tenantId: 'tenant-1',
    name: 'InsureCo',
    contactPhone: '+27123456789',
    contactEmail: 'support@insureco.example',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 2, 1),
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [
        insurerAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build loads insurers', () async {
    when(() => repository.fetchInsurers())
        .thenAnswer((_) async => Result.ok([insurer]));

    final result =
        await container.read(adminInsurersControllerProvider.future);

    expect(result, [insurer]);
    verify(() => repository.fetchInsurers()).called(1);
  });

  test('refresh captures error when repository fails', () async {
    final error = const UnknownError('oops');
    when(() => repository.fetchInsurers())
        .thenAnswer((_) async => Result.err(error));

    final notifier = container.read(adminInsurersControllerProvider.notifier);
    await notifier.refresh();

    final state = container.read(adminInsurersControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, same(error));
  });

  test('createInsurer delegates then refreshes', () async {
    when(() => repository.fetchInsurers())
        .thenAnswer((_) async => Result.ok([insurer]));
    when(
      () => repository.createInsurer(
        name: any(named: 'name'),
        contactPhone: any(named: 'contactPhone'),
        contactEmail: any(named: 'contactEmail'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminInsurersControllerProvider.notifier);
    await container.read(adminInsurersControllerProvider.future);
    await notifier.createInsurer(
      name: 'New Insurer',
      contactPhone: '+27000000000',
      contactEmail: 'hello@example.com',
    );

    verify(
      () => repository.createInsurer(
        name: 'New Insurer',
        contactPhone: '+27000000000',
        contactEmail: 'hello@example.com',
      ),
    ).called(1);
  });

  test('updateInsurer delegates then refreshes', () async {
    when(() => repository.fetchInsurers())
        .thenAnswer((_) async => Result.ok([insurer]));
    when(
      () => repository.updateInsurer(
        id: any(named: 'id'),
        name: any(named: 'name'),
        contactPhone: any(named: 'contactPhone'),
        contactEmail: any(named: 'contactEmail'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminInsurersControllerProvider.notifier);
    await container.read(adminInsurersControllerProvider.future);
    await notifier.updateInsurer(
      id: 'insurer-1',
      name: 'Updated',
      contactPhone: '+27111111111',
      contactEmail: 'updated@example.com',
    );

    verify(
      () => repository.updateInsurer(
        id: 'insurer-1',
        name: 'Updated',
        contactPhone: '+27111111111',
        contactEmail: 'updated@example.com',
      ),
    ).called(1);
  });

  test('deleteInsurer delegates then refreshes', () async {
    when(() => repository.fetchInsurers())
        .thenAnswer((_) async => Result.ok([insurer]));
    when(() => repository.deleteInsurer('insurer-1'))
        .thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminInsurersControllerProvider.notifier);
    await container.read(adminInsurersControllerProvider.future);
    await notifier.deleteInsurer('insurer-1');

    verify(() => repository.deleteInsurer('insurer-1')).called(1);
  });
}

