import '../../core/utils/result.dart';
import '../models/agent_option.dart';

/// Repository for agent lookup operations (name by ID, list of agents for dropdowns)
abstract class AgentLookupRepository {
  /// Fetch agent name by ID
  /// 
  /// Returns the agent's full name if found, null if not found.
  /// Errors are propagated (no silent failures).
  Future<Result<String?>> fetchAgentName(String agentId);

  /// Fetch all active agents as options (for dropdowns, etc.)
  /// 
  /// [limit] - Maximum number of agents to fetch (default: 200, max: 500)
  /// Returns list of active agents ordered by name.
  /// Returns empty list if no agents found (not an error).
  Future<Result<List<AgentOption>>> fetchAgentOptions({
    int limit = 200,
  });
}

