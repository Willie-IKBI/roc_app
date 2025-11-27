import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/clients/supabase_client.dart';

part 'agent_lookup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<String?> agentName(Ref ref, String? agentId) async {
  if (agentId == null) {
    return null;
  }

  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('profiles')
      .select('full_name')
      .eq('id', agentId)
      .maybeSingle();

  if (data == null) {
    return null;
  }

  final map = Map<String, dynamic>.from(data as Map);
  final name = (map['full_name'] as String?)?.trim();
  if (name == null || name.isEmpty) {
    return null;
  }
  return name;
}


