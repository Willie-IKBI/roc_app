import '../../core/utils/result.dart';
import '../models/sms_sender_settings.dart';
import '../models/sms_template.dart';

abstract class SmsAdminRepository {
  Future<Result<List<SmsTemplate>>> fetchTemplates();

  Future<Result<String>> createTemplate({
    required String name,
    String? description,
    required String body,
    bool isActive,
    bool defaultForFollowUp,
  });

  Future<Result<void>> updateTemplate({
    required String id,
    required String name,
    String? description,
    required String body,
    bool isActive,
    bool defaultForFollowUp,
  });

  Future<Result<void>> deleteTemplate(String id);

  Future<Result<void>> setDefaultTemplate({
    required String id,
    required String tenantId,
  });

  Future<Result<SmsSenderSettings>> fetchSenderSettings();

  Future<Result<void>> updateSenderSettings({
    String? senderName,
    String? senderNumber,
  });
}


