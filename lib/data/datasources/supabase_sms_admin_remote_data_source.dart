import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/sms_template_row.dart';
import 'sms_admin_remote_data_source.dart';

final smsAdminRemoteDataSourceProvider =
    Provider<SmsAdminRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSmsAdminRemoteDataSource(client);
});

class SupabaseSmsAdminRemoteDataSource implements SmsAdminRemoteDataSource {
  SupabaseSmsAdminRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<List<SmsTemplateRow>>> fetchTemplates() async {
    try {
      final response = await _client
          .from('sms_templates')
          .select(
            'id, tenant_id, name, description, body, is_active, default_for_follow_up, created_at, updated_at',
          )
          .order('name');

      final rows = (response as List<dynamic>)
          .map(
            (row) => SmsTemplateRow.fromJson(
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String>> createTemplate({
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name.trim(),
        'description':
            description != null && description.trim().isNotEmpty
                ? description.trim()
                : null,
        'body': body,
        'is_active': isActive,
        'default_for_follow_up': defaultForFollowUp,
      };

      final response = await _client
          .from('sms_templates')
          .insert(payload)
          .select('id')
          .single();

      return Result.ok(response['id'] as String);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateTemplate({
    required String id,
    required String name,
    String? description,
    required String body,
    bool isActive = true,
    bool defaultForFollowUp = false,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name.trim(),
        'description':
            description != null && description.trim().isNotEmpty
                ? description.trim()
                : null,
        'body': body,
        'is_active': isActive,
        'default_for_follow_up': defaultForFollowUp,
      };

      await _client.from('sms_templates').update(payload).eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> deleteTemplate(String id) async {
    try {
      await _client.from('sms_templates').delete().eq('id', id);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> setDefaultTemplate({
    required String templateId,
    required String tenantId,
  }) async {
    try {
      await _client
          .from('sms_templates')
          .update({'default_for_follow_up': false})
          .eq('tenant_id', tenantId);

      await _client
          .from('sms_templates')
          .update({'default_for_follow_up': true, 'is_active': true})
          .eq('id', templateId);

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> fetchSenderSettings() async {
    try {
      final response = await _client
          .from('tenants')
          .select('sms_sender_name, sms_sender_number')
          .maybeSingle();

      if (response == null) {
        return Result.err(const NotFoundError('Tenant settings'));
      }

      return Result.ok(Map<String, dynamic>.from(response as Map));
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateSenderSettings({
    String? senderName,
    String? senderNumber,
  }) async {
    try {
      await _client.from('tenants').update({
        'sms_sender_name': senderName?.trim(),
        'sms_sender_number': senderNumber?.trim(),
      });
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}


