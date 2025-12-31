/// Interface for agent lookup remote data source
/// 
/// Provides methods to fetch agent data from remote storage (Supabase)
abstract class AgentLookupRemoteDataSource {
  /// Fetch agent name by ID
  /// 
  /// Returns raw data from Supabase (Map with 'full_name' field)
  /// Returns null if agent not found.
  Future<Map<String, dynamic>?> fetchAgentName(String agentId);

  /// Fetch all active agents
  /// 
  /// Returns raw data from Supabase (List<Map<String, dynamic>>)
  /// Minimal payload: id, full_name, is_active
  Future<List<Map<String, dynamic>>> fetchAgentOptions({
    int limit = 200,
  });
}

