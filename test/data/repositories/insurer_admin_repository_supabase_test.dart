import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/insurer_admin_remote_data_source.dart';
import 'package:roc_app/data/models/insurer_row.dart';
import 'package:roc_app/data/repositories/insurer_admin_repository_supabase.dart';

class _MockRemote extends Mock implements InsurerAdminRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late InsurerAdminRepositorySupabase repository;

  setUp(() {
    remote = _MockRemote();
    repository = InsurerAdminRepositorySupabase(remote);
  });

  final row = InsurerRow(
    id: 'insurer-1',
    tenantId: 'tenant-1',
    name: 'InsureCo',
    contactPhone: '+27123456789',
    contactEmail: 'support@insureco.example',
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 2, 1),
  );

  group('fetchInsurers', () {
    test('returns mapped insurers on success', () async {
      when(() => remote.fetchInsurers()).thenAnswer(
        (_) async => Result.ok([row]),
      );

      final result = await repository.fetchInsurers();

      expect(result.isOk, isTrue);
      final insurers = result.data;
      expect(insurers, hasLength(1));
      expect(insurers.first.id, 'insurer-1');
      expect(insurers.first.name, 'InsureCo');
    });

    test('propagates error from remote', () async {
      final error = UnknownError(Exception('boom'));
      when(() => remote.fetchInsurers()).thenAnswer(
        (_) async => Result.err(error),
      );

      final result = await repository.fetchInsurers();

      expect(result.isErr, isTrue);
      expect(result.error, same(error));
    });
  });

  test('createInsurer delegates to remote', () async {
    when(
      () => remote.createInsurer(
        name: any(named: 'name'),
        contactPhone: any(named: 'contactPhone'),
        contactEmail: any(named: 'contactEmail'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.createInsurer(
      name: 'New Insurer',
      contactPhone: '+27000000000',
      contactEmail: 'hello@example.com',
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.createInsurer(
        name: 'New Insurer',
        contactPhone: '+27000000000',
        contactEmail: 'hello@example.com',
      ),
    ).called(1);
  });

  test('updateInsurer delegates to remote', () async {
    when(
      () => remote.updateInsurer(
        id: any(named: 'id'),
        name: any(named: 'name'),
        contactPhone: any(named: 'contactPhone'),
        contactEmail: any(named: 'contactEmail'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateInsurer(
      id: 'insurer-1',
      name: 'Updated',
      contactPhone: '+27111111111',
      contactEmail: 'new@example.com',
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.updateInsurer(
        id: 'insurer-1',
        name: 'Updated',
        contactPhone: '+27111111111',
        contactEmail: 'new@example.com',
      ),
    ).called(1);
  });

  test('deleteInsurer delegates to remote', () async {
    when(() => remote.deleteInsurer('insurer-1'))
        .thenAnswer((_) async => const Result.ok(null));

    final result = await repository.deleteInsurer('insurer-1');

    expect(result.isOk, isTrue);
    verify(() => remote.deleteInsurer('insurer-1')).called(1);
  });
}

