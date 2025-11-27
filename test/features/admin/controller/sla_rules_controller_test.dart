import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/domain/models/sla_rule.dart';
import 'package:roc_app/domain/repositories/admin_settings_repository.dart';
import 'package:roc_app/features/admin/controller/sla_rules_controller.dart';
import 'package:roc_app/data/repositories/admin_settings_repository_supabase.dart';

class _MockRepository extends Mock implements AdminSettingsRepository {}

void main() {
  late ProviderContainer container;
  late _MockRepository repository;

  final rule = SlaRule(
    id: 'sla-1',
    tenantId: 'tenant-1',
    timeToFirstContactMinutes: 240,
    breachHighlight: true,
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

  test('build loads SLA rule', () async {
    when(() => repository.fetchSlaRule())
        .thenAnswer((_) async => Result.ok(rule));

    final result = await container.read(slaRulesControllerProvider.future);

    expect(result, rule);
    verify(() => repository.fetchSlaRule()).called(1);
  });

  test('refresh captures error', () async {
    final error = const UnknownError('oops');
    when(() => repository.fetchSlaRule())
        .thenAnswer((_) async => Result.err(error));

    final notifier = container.read(slaRulesControllerProvider.notifier);
    await notifier.refresh();

    final state = container.read(slaRulesControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, same(error));
  });

  test('update delegates to repository then refreshes', () async {
    when(() => repository.fetchSlaRule())
        .thenAnswer((_) async => Result.ok(rule));
    when(
      () => repository.updateSlaRule(
        timeToFirstContactMinutes: any(named: 'timeToFirstContactMinutes'),
        breachHighlight: any(named: 'breachHighlight'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final notifier = container.read(slaRulesControllerProvider.notifier);
    await container.read(slaRulesControllerProvider.future);
    await notifier.save(
      timeToFirstContactMinutes: 180,
      breachHighlight: false,
    );

    verify(
      () => repository.updateSlaRule(
        timeToFirstContactMinutes: 180,
        breachHighlight: false,
      ),
    ).called(1);
  });
}

