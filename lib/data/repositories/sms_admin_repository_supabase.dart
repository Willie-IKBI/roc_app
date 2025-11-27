import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/result.dart';
import '../../domain/models/sms_sender_settings.dart';
import '../../domain/models/sms_template.dart';
import '../../domain/repositories/sms_admin_repository.dart';
import '../datasources/sms_admin_remote_data_source.dart';
import '../datasources/supabase_sms_admin_remote_data_source.dart';

final smsAdminRepositoryProvider = Provider<SmsAdminRepository>((ref) {
  final remote = ref.watch(smsAdminRemoteDataSourceProvider);
  return SmsAdminRepositorySupabase(remote);
});

class SmsAdminRepositorySupabase implements SmsAdminRepository {
  SmsAdminRepositorySupabase(this._remote);

  final SmsAdminRemoteDataSource _remote;

  @override
  Future<Result<List<SmsTemplate>>> fetchTemplates() async {
    final response = await _remote.fetchTemplates();
    if (response.isErr) {
      return Result.err(response.error);
    }
    return Result.ok(
      response.data.map((row) => row.toDomain()).toList(growable: false),
    );
  }

  @override
  Future<Result<String>> createTemplate({
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) {
    return _remote.createTemplate(
      name: name,
      description: description,
      body: body,
      isActive: isActive,
      defaultForFollowUp: defaultForFollowUp,
    );
  }

  @override
  Future<Result<void>> updateTemplate({
    required String id,
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) {
    return _remote.updateTemplate(
      id: id,
      name: name,
      description: description,
      body: body,
      isActive: isActive,
      defaultForFollowUp: defaultForFollowUp,
    );
  }

  @override
  Future<Result<void>> deleteTemplate(String id) {
    return _remote.deleteTemplate(id);
  }

  @override
  Future<Result<void>> setDefaultTemplate({
    required String id,
    required String tenantId,
  }) {
    return _remote.setDefaultTemplate(
      templateId: id,
      tenantId: tenantId,
    );
  }

  @override
  Future<Result<SmsSenderSettings>> fetchSenderSettings() async {
    final response = await _remote.fetchSenderSettings();
    if (response.isErr) {
      return Result.err(response.error);
    }
    final data = response.data;
    return Result.ok(
      SmsSenderSettings(
        senderName: data['sms_sender_name'] as String?,
        senderNumber: data['sms_sender_number'] as String?,
      ),
    );
  }

  @override
  Future<Result<void>> updateSenderSettings({
    String? senderName,
    String? senderNumber,
  }) {
    return _remote.updateSenderSettings(
      senderName: senderName,
      senderNumber: senderNumber,
    );
  }
}


