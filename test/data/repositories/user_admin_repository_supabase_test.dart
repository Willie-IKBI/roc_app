import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/user_admin_remote_data_source.dart';
import 'package:roc_app/data/models/profile_row.dart';
import 'package:roc_app/data/repositories/user_admin_repository_supabase.dart';
import 'package:roc_app/domain/value_objects/role_type.dart';

class _MockRemote extends Mock implements UserAdminRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late UserAdminRepositorySupabase repository;

  setUp(() {
    remote = _MockRemote();
    repository = UserAdminRepositorySupabase(remote);
  });

  test('fetchUsers maps rows to domain', () async {
    final row = ProfileRow(
      id: 'user-1',
      tenantId: 'tenant-1',
      fullName: 'Jane Doe',
      phone: '+27123456789',
      email: 'jane@example.com',
      role: RoleType.admin.value,
      isActive: true,
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );
    when(() => remote.fetchUsers())
        .thenAnswer((_) async => Result.ok([row]));

    final result = await repository.fetchUsers();

    expect(result.isOk, isTrue);
    final users = result.data;
    expect(users, hasLength(1));
    final user = users.first;
    expect(user.id, equals('user-1'));
    expect(user.role, equals(RoleType.admin));
    expect(user.isActive, isTrue);
  });

  test('fetchUsers propagates error', () async {
    final error = UnknownError(Exception('boom'));
    when(() => remote.fetchUsers())
        .thenAnswer((_) async => Result.err(error));

    final result = await repository.fetchUsers();

    expect(result.isErr, isTrue);
    expect(result.error, same(error));
  });

  test('updateRole delegates to remote', () async {
    when(() => remote.updateRole(userId: 'user-1', role: RoleType.claimAgent))
        .thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateRole(
      userId: 'user-1',
      role: RoleType.claimAgent,
    );

    expect(result.isOk, isTrue);
    verify(() => remote.updateRole(userId: 'user-1', role: RoleType.claimAgent))
        .called(1);
  });

  test('updateStatus delegates to remote', () async {
    when(() => remote.updateStatus(userId: 'user-1', isActive: false))
        .thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateStatus(
      userId: 'user-1',
      isActive: false,
    );

    expect(result.isOk, isTrue);
    verify(() => remote.updateStatus(userId: 'user-1', isActive: false))
        .called(1);
  });

  test('sendInvite delegates to remote', () async {
    when(() => remote.sendInvite(email: 'agent@example.com', role: RoleType.claimAgent))
        .thenAnswer((_) async => const Result.ok(null));

    final result = await repository.sendInvite(
      email: 'agent@example.com',
      role: RoleType.claimAgent,
    );

    expect(result.isOk, isTrue);
    verify(() => remote.sendInvite(email: 'agent@example.com', role: RoleType.claimAgent))
        .called(1);
  });

  test('updateDetails delegates to remote', () async {
    when(() => remote.updateDetails(
          userId: 'user-1',
          fullName: 'Jane Doe',
          phone: '+27123456789',
        )).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateDetails(
      userId: 'user-1',
      fullName: 'Jane Doe',
      phone: '+27123456789',
    );

    expect(result.isOk, isTrue);
    verify(() => remote.updateDetails(
          userId: 'user-1',
          fullName: 'Jane Doe',
          phone: '+27123456789',
        )).called(1);
  });
}

