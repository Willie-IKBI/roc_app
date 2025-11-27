import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/models/sms_sender_settings.dart';
import '../../../domain/models/sms_template.dart';
import '../../../data/repositories/sms_admin_repository_supabase.dart';

part 'sms_templates_controller.g.dart';

@riverpod
class SmsTemplatesController extends _$SmsTemplatesController {
  @override
  Future<List<SmsTemplate>> build() async {
    return _load();
  }

  Future<List<SmsTemplate>> _load() async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.fetchTemplates();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<Result<String>> create({
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.createTemplate(
      name: name,
      description: description,
      body: body,
      isActive: isActive,
      defaultForFollowUp: defaultForFollowUp,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> updateTemplate({
    required String id,
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.updateTemplate(
      id: id,
      name: name,
      description: description,
      body: body,
      isActive: isActive,
      defaultForFollowUp: defaultForFollowUp,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> delete(String id) async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.deleteTemplate(id);
    if (result.isOk) {
      await refresh();
    }
    return result;
  }

  Future<Result<void>> setDefault(SmsTemplate template) async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.setDefaultTemplate(
      id: template.id,
      tenantId: template.tenantId,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }
}

@riverpod
class SmsSenderController extends _$SmsSenderController {
  @override
  Future<SmsSenderSettings> build() async {
    return _load();
  }

  Future<SmsSenderSettings> _load() async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.fetchSenderSettings();
    if (result.isErr) {
      throw result.error;
    }
    return result.data;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<Result<void>> saveSender({
    String? senderName,
    String? senderNumber,
  }) async {
    final repository = ref.read(smsAdminRepositoryProvider);
    final result = await repository.updateSenderSettings(
      senderName: senderName,
      senderNumber: senderNumber,
    );
    if (result.isOk) {
      await refresh();
    }
    return result;
  }
}

