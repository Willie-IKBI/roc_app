import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/domain/models/queue_settings.dart';
import 'package:roc_app/domain/repositories/admin_settings_repository.dart';
import 'package:roc_app/features/admin/controller/queue_settings_controller.dart';
import 'package:roc_app/data/repositories/admin_settings_repository_supabase.dart';

class _MockRepository extends Mock implements AdminSettingsRepository {}

void main() {
  late ProviderContainer container;
  late _MockRepository repository;

  final settings = QueueSettings(
    id: 'queue-1',
    tenantId: 'tenant-1',
    retryLimit: 3,
    retryIntervalMinutes: 120,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 2, 1),
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [
        adminSettingsRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build loads queue settings', () async {
    when(() => repository.fetchQueueSettings())
        .thenAnswer((_) async => Result.ok(settings));

    final result =
        await container.read(queueSettingsControllerProvider.future);

    expect(result, settings);
    verify(() => repository.fetchQueueSettings()).called(1);
  });

  test('refresh captures error', () async {
    final error = const UnknownError('oops');
    when(() => repository.fetchQueueSettings())
        .thenAnswer((_) async => Result.err(error));

    final notifier = container.read(queueSettingsControllerProvider.notifier);
    await notifier.refresh();

    final state = container.read(queueSettingsControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, same(error));
  });

  test('update delegates to repository then refreshes', () async {
    when(() => repository.fetchQueueSettings())
        .thenAnswer((_) async => Result.ok(settings));
    when(
      () => repository.updateQueueSettings(
        retryLimit: any(named: 'retryLimit'),
        retryIntervalMinutes: any(named: 'retryIntervalMinutes'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(queueSettingsControllerProvider.notifier);
    await container.read(queueSettingsControllerProvider.future);
    await notifier.save(
      retryLimit: 4,
      retryIntervalMinutes: 90,
    );

    verify(
      () => repository.updateQueueSettings(
        retryLimit: 4,
        retryIntervalMinutes: 90,
      ),
    ).called(1);
  });
}

