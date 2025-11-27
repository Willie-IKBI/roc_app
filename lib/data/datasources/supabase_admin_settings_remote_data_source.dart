import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/domain_error.dart';
import '../../core/utils/result.dart';
import '../clients/supabase_client.dart';
import '../models/queue_settings_row.dart';
import '../models/sla_rule_row.dart';
import 'admin_settings_remote_data_source.dart';

final adminSettingsRemoteDataSourceProvider =
    Provider<AdminSettingsRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAdminSettingsRemoteDataSource(client);
});

class SupabaseAdminSettingsRemoteDataSource
    implements AdminSettingsRemoteDataSource {
  SupabaseAdminSettingsRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<SlaRuleRow>> fetchSlaRule() async {
    try {
      final response = await _client
          .from('sla_rules')
          .select(
            'id, tenant_id, time_to_first_contact_minutes, breach_highlight, created_at, updated_at',
          )
          .maybeSingle();

      if (response == null) {
        return Result.err(
          const NotFoundError('SLA rule'),
        );
      }

      final row =
          SlaRuleRow.fromJson(Map<String, dynamic>.from(response as Map));
      return Result.ok(row);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateSlaRule({
    required int timeToFirstContactMinutes,
    required bool breachHighlight,
  }) async {
    try {
      await _client.from('sla_rules').upsert({
        'time_to_first_contact_minutes': timeToFirstContactMinutes,
        'breach_highlight': breachHighlight,
      });
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<QueueSettingsRow>> fetchQueueSettings() async {
    try {
      final response = await _client
          .from('claim_queue_settings')
          .select(
            'id, tenant_id, retry_limit, retry_interval_minutes, created_at, updated_at',
          )
          .maybeSingle();

      if (response == null) {
        return Result.err(
          const NotFoundError('Queue settings'),
        );
      }

      final row = QueueSettingsRow.fromJson(
        Map<String, dynamic>.from(response as Map),
      );
      return Result.ok(row);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateQueueSettings({
    required int retryLimit,
    required int retryIntervalMinutes,
  }) async {
    try {
      await _client.from('claim_queue_settings').upsert({
        'retry_limit': retryLimit,
        'retry_interval_minutes': retryIntervalMinutes,
      });
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      return Result.err(mapPostgrestException(err));
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

