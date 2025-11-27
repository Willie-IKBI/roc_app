import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/service_provider_admin_repository_supabase.dart';
import 'package:roc_app/domain/models/service_provider.dart';
import 'package:roc_app/domain/repositories/service_provider_admin_repository.dart';
import 'package:roc_app/features/admin/controller/service_providers_controller.dart';

class _MockRepository extends Mock
    implements ServiceProviderAdminRepository {}

void main() {
  late ProviderContainer container;
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [
        serviceProviderAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final provider = ServiceProvider(
    id: 'provider-1',
    tenantId: 'tenant-1',
    companyName: 'Appliance Fixers',
    contactName: 'Kabelo M',
    contactPhone: '+27115550001',
    contactEmail: 'ops@example.com',
    referenceNumberFormat: 'AF-{claim_number}',
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 2),
  );

  test('build loads providers', () async {
    when(() => repository.fetchProviders())
        .thenAnswer((_) async => Result.ok([provider]));

    final result =
        await container.read(serviceProvidersControllerProvider.future);

    expect(result, equals([provider]));
    verify(() => repository.fetchProviders()).called(1);
  });

  test('create triggers refresh when successful', () async {
    when(() => repository.fetchProviders())
        .thenAnswer((_) async => Result.ok([provider]));
    when(
      () => repository.createProvider(
        companyName: any(named: 'companyName'),
        contactName: any(named: 'contactName'),
        contactPhone: any(named: 'contactPhone'),
        contactEmail: any(named: 'contactEmail'),
        referenceNumberFormat: any(named: 'referenceNumberFormat'),
      ),
    ).thenAnswer((_) async => const Result.ok('provider-2'));

    final notifier =
        container.read(serviceProvidersControllerProvider.notifier);
    await notifier.create(companyName: 'Another Co');

    verify(() => repository.createProvider(
          companyName: 'Another Co',
          contactName: null,
          contactPhone: null,
          contactEmail: null,
          referenceNumberFormat: null,
        )).called(1);
    verify(() => repository.fetchProviders()).called(greaterThanOrEqualTo(2));
  });
}


