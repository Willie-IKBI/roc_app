import '../../core/utils/result.dart';
import '../models/sms_template_row.dart';

abstract class SmsAdminRemoteDataSource {
  Future<Result<List<SmsTemplateRow>>> fetchTemplates();

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
    required String templateId,
    required String tenantId,
  });

  Future<Result<Map<String, dynamic>>> fetchSenderSettings();

  Future<Result<void>> updateSenderSettings({
    String? senderName,
    String? senderNumber,
  });
}


