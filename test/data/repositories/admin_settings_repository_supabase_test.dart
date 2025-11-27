import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/admin_settings_remote_data_source.dart';
import 'package:roc_app/data/models/queue_settings_row.dart';
import 'package:roc_app/data/models/sla_rule_row.dart';
import 'package:roc_app/data/repositories/admin_settings_repository_supabase.dart';

class _MockRemote extends Mock implements AdminSettingsRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late AdminSettingsRepositorySupabase repository;

  setUp(() {
    remote = _MockRemote();
    repository = AdminSettingsRepositorySupabase(remote);
  });

  group('fetchSlaRule', () {
    final row = SlaRuleRow(
      id: 'sla-1',
      tenantId: 'tenant-1',
      timeToFirstContactMinutes: 240,
      breachHighlight: true,
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );

    test('returns mapped rule on success', () async {
      when(() => remote.fetchSlaRule())
          .thenAnswer((_) async => Result.ok(row));

      final result = await repository.fetchSlaRule();

      expect(result.isOk, isTrue);
      expect(result.data.timeToFirstContactMinutes, 240);
    });

    test('propagates error from remote', () async {
      final error = UnknownError(Exception('boom'));
      when(() => remote.fetchSlaRule()).thenAnswer(
        (_) async => Result.err(error),
      );

      final result = await repository.fetchSlaRule();

      expect(result.isErr, isTrue);
      expect(result.error, same(error));
    });
  });

  test('updateSlaRule delegates to remote', () async {
    when(
      () => remote.updateSlaRule(
        timeToFirstContactMinutes: any(named: 'timeToFirstContactMinutes'),
        breachHighlight: any(named: 'breachHighlight'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateSlaRule(
      timeToFirstContactMinutes: 180,
      breachHighlight: true,
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.updateSlaRule(
        timeToFirstContactMinutes: 180,
        breachHighlight: true,
      ),
    ).called(1);
  });

  group('fetchQueueSettings', () {
    final row = QueueSettingsRow(
      id: 'queue-1',
      tenantId: 'tenant-1',
      retryLimit: 3,
      retryIntervalMinutes: 120,
      createdAt: DateTime.utc(2024, 1, 1),
      updatedAt: DateTime.utc(2024, 2, 1),
    );

    test('returns mapped settings on success', () async {
      when(() => remote.fetchQueueSettings())
          .thenAnswer((_) async => Result.ok(row));

      final result = await repository.fetchQueueSettings();

      expect(result.isOk, isTrue);
      expect(result.data.retryLimit, 3);
    });

    test('propagates error from remote', () async {
      final error = const PermissionDeniedError();
      when(() => remote.fetchQueueSettings()).thenAnswer(
        (_) async => Result.err(error),
      );

      final result = await repository.fetchQueueSettings();

      expect(result.isErr, isTrue);
      expect(result.error, same(error));
    });
  });

  test('updateQueueSettings delegates to remote', () async {
    when(
      () => remote.updateQueueSettings(
        retryLimit: any(named: 'retryLimit'),
        retryIntervalMinutes: any(named: 'retryIntervalMinutes'),
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateQueueSettings(
      retryLimit: 4,
      retryIntervalMinutes: 90,
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.updateQueueSettings(
        retryLimit: 4,
        retryIntervalMinutes: 90,
      ),
    ).called(1);
  });
}

