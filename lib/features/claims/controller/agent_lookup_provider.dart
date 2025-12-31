import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/agent_lookup_repository_supabase.dart';

part 'agent_lookup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<String?> agentName(Ref ref, String? agentId) async {
  if (agentId == null) {
    return null;
  }

  final repository = ref.watch(agentLookupRepositoryProvider);
  final result = await repository.fetchAgentName(agentId);

  if (result.isErr) {
    // Propagate error as AsyncError (no silent failure)
    throw result.error;
  }

  return result.data;
}


