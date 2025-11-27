import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/repositories/sms_admin_repository_supabase.dart';
import 'package:roc_app/domain/models/sms_sender_settings.dart';
import 'package:roc_app/domain/models/sms_template.dart';
import 'package:roc_app/domain/repositories/sms_admin_repository.dart';
import 'package:roc_app/features/admin/controller/sms_templates_controller.dart';

class _MockRepository extends Mock implements SmsAdminRepository {}

void main() {
  late ProviderContainer container;
  late _MockRepository repository;

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [
        smsAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final template = SmsTemplate(
    id: 'template-1',
    tenantId: 'tenant-1',
    name: 'Follow-up',
    description: 'Default follow up',
    body: 'Hello {client_name}',
    isActive: true,
    defaultForFollowUp: true,
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 2),
  );

  test('SmsTemplatesController loads templates', () async {
    when(() => repository.fetchTemplates())
        .thenAnswer((_) async => Result.ok([template]));

    final result =
        await container.read(smsTemplatesControllerProvider.future);

    expect(result, equals([template]));
    verify(() => repository.fetchTemplates()).called(1);
  });

  test('SmsSenderController loads settings', () async {
    final settings =
        SmsSenderSettings(senderName: 'Repair on Call', senderNumber: '+27');
    when(() => repository.fetchSenderSettings())
        .thenAnswer((_) async => Result.ok(settings));

    final result =
        await container.read(smsSenderControllerProvider.future);

    expect(result.senderName, equals('Repair on Call'));
    verify(() => repository.fetchSenderSettings()).called(1);
  });
}


