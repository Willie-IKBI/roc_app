import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/domain/models/user_account.dart';
import 'package:roc_app/domain/repositories/user_admin_repository.dart';
import 'package:roc_app/domain/value_objects/role_type.dart';
import 'package:roc_app/features/admin/controller/admin_users_controller.dart';
import 'package:roc_app/data/repositories/user_admin_repository_supabase.dart';

class _MockRepository extends Mock implements UserAdminRepository {}

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  final user = UserAccount(
    id: 'user-1',
    email: 'agent@example.com',
    fullName: 'Agent Smith',
    role: RoleType.claimAgent,
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 2, 1),
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [
        userAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build loads users', () async {
    when(() => repository.fetchUsers())
        .thenAnswer((_) async => Result.ok([user]));

    final result = await container.read(adminUsersControllerProvider.future);

    expect(result, [user]);
    verify(() => repository.fetchUsers()).called(1);
  });

  test('refresh captures error when repository fails', () async {
    final error = const UnknownError('oops');
    when(() => repository.fetchUsers())
        .thenAnswer((_) async => Result.err(error));

    final notifier = container.read(adminUsersControllerProvider.notifier);
    await notifier.refresh();

    final state = container.read(adminUsersControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, same(error));
  });

  test('changeRole updates role then refreshes list', () async {
    var fetchCall = 0;
    when(() => repository.fetchUsers()).thenAnswer((_) async {
      fetchCall += 1;
      if (fetchCall == 1) {
        return Result.ok([user]);
      }
      return Result.ok([user.copyWith(role: RoleType.admin)]);
    });
    when(() => repository.updateRole(
          userId: user.id,
          role: RoleType.admin,
        )).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminUsersControllerProvider.notifier);
    await container.read(adminUsersControllerProvider.future);
    await notifier.changeRole(userId: user.id, role: RoleType.admin);

    final state = container.read(adminUsersControllerProvider);
    expect(state.value?.first.role, RoleType.admin);
  });

  test('toggleActive updates status then refreshes', () async {
    var fetchCall = 0;
    when(() => repository.fetchUsers()).thenAnswer((_) async {
      fetchCall += 1;
      if (fetchCall == 1) {
        return Result.ok([user]);
      }
      return Result.ok([user.copyWith(isActive: false)]);
    });
    when(() => repository.updateStatus(userId: user.id, isActive: false))
        .thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminUsersControllerProvider.notifier);
    await container.read(adminUsersControllerProvider.future);
    await notifier.toggleActive(userId: user.id, isActive: false);

    final state = container.read(adminUsersControllerProvider);
    expect(state.value?.first.isActive, isFalse);
  });

  test('invite delegates to repository', () async {
    when(() => repository.fetchUsers())
        .thenAnswer((_) async => Result.ok([user]));
    when(() => repository.sendInvite(
          email: 'new@example.com',
          role: RoleType.claimAgent,
        )).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminUsersControllerProvider.notifier);
    await container.read(adminUsersControllerProvider.future);
    await notifier.invite(email: 'new@example.com', role: RoleType.claimAgent);

    verify(() => repository.sendInvite(
          email: 'new@example.com',
          role: RoleType.claimAgent,
        )).called(1);
  });

  test('updateDetails updates profile then refreshes', () async {
    var fetchCall = 0;
    when(() => repository.fetchUsers()).thenAnswer((_) async {
      fetchCall += 1;
      if (fetchCall == 1) {
        return Result.ok([user]);
      }
      return Result.ok([
        user.copyWith(fullName: 'Updated Name', phone: '+27820000000')
      ]);
    });
    when(
      () => repository.updateDetails(
        userId: user.id,
        fullName: 'Updated Name',
        phone: '+27820000000',
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(adminUsersControllerProvider.notifier);
    await container.read(adminUsersControllerProvider.future);
    await notifier.updateDetails(
      userId: user.id,
      fullName: 'Updated Name',
      phone: '+27820000000',
    );

    final state = container.read(adminUsersControllerProvider);
    expect(state.value?.first.fullName, 'Updated Name');
    verify(
      () => repository.updateDetails(
        userId: user.id,
        fullName: 'Updated Name',
        phone: '+27820000000',
      ),
    ).called(1);
  });
}

