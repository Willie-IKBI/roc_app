import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/service_provider_admin_remote_data_source.dart';
import 'package:roc_app/data/models/service_provider_row.dart';
import 'package:roc_app/data/repositories/service_provider_admin_repository_supabase.dart';

class _MockRemote extends Mock
    implements ServiceProviderAdminRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ServiceProviderAdminRepositorySupabase repository;

  setUp(() {
    remote = _MockRemote();
    repository = ServiceProviderAdminRepositorySupabase(remote);
  });

  final row = ServiceProviderRow(
    id: 'provider-1',
    tenantId: 'tenant-1',
    companyName: 'Appliance Fixers',
    contactName: 'Kabelo M',
    contactPhone: '+27115550001',
    contactEmail: 'ops@appliancefixers.example',
    referenceNumberFormat: 'AF-{claim_number}',
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 2),
  );

  test('fetchProviders maps rows to domain', () async {
    when(() => remote.fetchProviders())
        .thenAnswer((_) async => Result.ok([row]));

    final result = await repository.fetchProviders();

    expect(result.isOk, isTrue);
    expect(result.data, hasLength(1));
    final provider = result.data.first;
    expect(provider.companyName, equals('Appliance Fixers'));
    expect(provider.contactEmail, equals('ops@appliancefixers.example'));
  });

  test('fetchProviders propagates error', () async {
    final error = UnknownError(Exception('boom'));
    when(() => remote.fetchProviders())
        .thenAnswer((_) async => Result.err(error));

    final result = await repository.fetchProviders();

    expect(result.isErr, isTrue);
    expect(result.error, same(error));
  });

  test('createProvider delegates to remote', () async {
    when(
      () => remote.createProvider(
        companyName: 'New Co',
        contactName: null,
        contactPhone: null,
        contactEmail: null,
        referenceNumberFormat: null,
      ),
    ).thenAnswer((_) async => const Result.ok('provider-2'));

    final result = await repository.createProvider(
      companyName: 'New Co',
      contactName: null,
      contactPhone: null,
      contactEmail: null,
      referenceNumberFormat: null,
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.createProvider(
        companyName: 'New Co',
        contactName: null,
        contactPhone: null,
        contactEmail: null,
        referenceNumberFormat: null,
      ),
    ).called(1);
  });

  test('updateProvider delegates to remote', () async {
    when(
      () => remote.updateProvider(
        id: 'provider-1',
        companyName: 'Appliance Fixers',
        contactName: 'Kabelo',
        contactPhone: '+2711',
        contactEmail: 'ops@example.com',
        referenceNumberFormat: 'AF-{claim_number}',
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateProvider(
      id: 'provider-1',
      companyName: 'Appliance Fixers',
      contactName: 'Kabelo',
      contactPhone: '+2711',
      contactEmail: 'ops@example.com',
      referenceNumberFormat: 'AF-{claim_number}',
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.updateProvider(
        id: 'provider-1',
        companyName: 'Appliance Fixers',
        contactName: 'Kabelo',
        contactPhone: '+2711',
        contactEmail: 'ops@example.com',
        referenceNumberFormat: 'AF-{claim_number}',
      ),
    ).called(1);
  });

  test('deleteProvider delegates to remote', () async {
    when(() => remote.deleteProvider('provider-1'))
        .thenAnswer((_) async => const Result.ok(null));

    final result = await repository.deleteProvider('provider-1');
    expect(result.isOk, isTrue);
    verify(() => remote.deleteProvider('provider-1')).called(1);
  });
}


