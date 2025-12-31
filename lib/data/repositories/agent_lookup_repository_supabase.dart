import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/agent_option.dart';
import '../../domain/repositories/agent_lookup_repository.dart';
import '../clients/supabase_client.dart';
import '../datasources/agent_lookup_remote_data_source.dart';
import '../datasources/supabase_agent_lookup_remote_data_source.dart';

final agentLookupRepositoryProvider = Provider<AgentLookupRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseAgentLookupRemoteDataSource(client);
  return AgentLookupRepositorySupabase(dataSource);
});

class AgentLookupRepositorySupabase implements AgentLookupRepository {
  AgentLookupRepositorySupabase(this._remote);

  final AgentLookupRemoteDataSource _remote;

  @override
  Future<Result<String?>> fetchAgentName(String agentId) async {
    try {
      final data = await _remote.fetchAgentName(agentId);

      if (data == null) {
        return const Result.ok(null);
      }

      final name = (data['full_name'] as String?)?.trim();
      if (name == null || name.isEmpty) {
        return const Result.ok(null);
      }

      return Result.ok(name);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch agent name: $e',
        name: 'AgentLookupRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch agent name: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Agent not found');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  @override
  Future<Result<List<AgentOption>>> fetchAgentOptions({
    int limit = 200,
  }) async {
    try {
      final rows = await _remote.fetchAgentOptions(limit: limit);

      final options = rows
          .map((row) {
            final id = row['id'] as String?;
            final fullName = row['full_name'] as String?;
            final isActive = (row['is_active'] as bool?) ?? true;

            if (id == null || fullName == null || fullName.trim().isEmpty) {
              return null; // Skip invalid rows
            }

            return AgentOption(
              id: id,
              name: fullName.trim(),
              isActive: isActive,
            );
          })
          .whereType<AgentOption>()
          .toList();

      return Result.ok(options);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch agent options: $e',
        name: 'AgentLookupRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      DomainError error;
      if (e is PostgrestException) {
        error = NetworkError(e);
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }
}

