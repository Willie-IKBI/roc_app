import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/sms_admin_remote_data_source.dart';
import 'package:roc_app/data/models/sms_template_row.dart';
import 'package:roc_app/data/repositories/sms_admin_repository_supabase.dart';

class _MockRemote extends Mock implements SmsAdminRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late SmsAdminRepositorySupabase repository;

  setUp(() {
    remote = _MockRemote();
    repository = SmsAdminRepositorySupabase(remote);
  });

  final row = SmsTemplateRow(
    id: 'template-1',
    tenantId: 'tenant-1',
    name: 'Follow-up',
    description: 'Default follow-up message',
    body: 'Hi {client_name}, we tried to reach you.',
    isActive: true,
    defaultForFollowUp: true,
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 2),
  );

  test('fetchTemplates maps rows to domain', () async {
    when(() => remote.fetchTemplates())
        .thenAnswer((_) async => Result.ok([row]));

    final result = await repository.fetchTemplates();

    expect(result.isOk, isTrue);
    final templates = result.data;
    expect(templates, hasLength(1));
    expect(templates.first.name, equals('Follow-up'));
    expect(templates.first.defaultForFollowUp, isTrue);
  });

  test('fetchTemplates propagates error', () async {
    final error = UnknownError(Exception('boom'));
    when(() => remote.fetchTemplates())
        .thenAnswer((_) async => Result.err(error));

    final result = await repository.fetchTemplates();

    expect(result.isErr, isTrue);
    expect(result.error, same(error));
  });

  test('setDefaultTemplate delegates to remote', () async {
    when(
      () => remote.setDefaultTemplate(
        templateId: 'template-1',
        tenantId: 'tenant-1',
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.setDefaultTemplate(
      id: 'template-1',
      tenantId: 'tenant-1',
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.setDefaultTemplate(
        templateId: 'template-1',
        tenantId: 'tenant-1',
      ),
    ).called(1);
  });

  test('fetchSenderSettings maps response to domain', () async {
    when(() => remote.fetchSenderSettings()).thenAnswer(
      (_) async => Result.ok(
        {
          'sms_sender_name': 'Repair on Call',
          'sms_sender_number': '+27115550000',
        },
      ),
    );

    final result = await repository.fetchSenderSettings();

    expect(result.isOk, isTrue);
    final settings = result.data;
    expect(settings.senderName, equals('Repair on Call'));
    expect(settings.senderNumber, equals('+27115550000'));
    expect(settings.isConfigured, isTrue);
  });

  test('updateSenderSettings delegates to remote', () async {
    when(
      () => remote.updateSenderSettings(
        senderName: 'Repair on Call',
        senderNumber: '+27115550000',
      ),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await repository.updateSenderSettings(
      senderName: 'Repair on Call',
      senderNumber: '+27115550000',
    );

    expect(result.isOk, isTrue);
    verify(
      () => remote.updateSenderSettings(
        senderName: 'Repair on Call',
        senderNumber: '+27115550000',
      ),
    ).called(1);
  });
}


