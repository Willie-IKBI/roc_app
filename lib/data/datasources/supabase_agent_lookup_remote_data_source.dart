import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException, SupabaseClient;

import '../../core/logging/logger.dart';
import 'agent_lookup_remote_data_source.dart';

class SupabaseAgentLookupRemoteDataSource implements AgentLookupRemoteDataSource {
  SupabaseAgentLookupRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Map<String, dynamic>?> fetchAgentName(String agentId) async {
    try {
      final data = await _client
          .from('profiles')
          .select('full_name')
          .eq('id', agentId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return Map<String, dynamic>.from(data as Map);
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch agent name: ${e.message}',
        name: 'SupabaseAgentLookupRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching agent name: $e',
        name: 'SupabaseAgentLookupRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAgentOptions({
    int limit = 200,
  }) async {
    try {
      final pageSize = limit.clamp(1, 500);

      final data = await _client
          .from('profiles')
          .select('id, full_name, is_active')
          .eq('is_active', true)
          .order('full_name', ascending: true)
          .order('id', ascending: true) // Tie-breaker for deterministic ordering
          .limit(pageSize);

      final rows = data as List<dynamic>;
      return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch agent options: ${e.message}',
        name: 'SupabaseAgentLookupRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching agent options: $e',
        name: 'SupabaseAgentLookupRemoteDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

