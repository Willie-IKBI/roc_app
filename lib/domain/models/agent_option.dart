import 'package:flutter/foundation.dart';

/// Lightweight model for agent lookup options (dropdowns, lookups, etc.)
/// Used for displaying agent names in UI components.
@immutable
class AgentOption {
  const AgentOption({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  final String id;
  final String name;
  final bool isActive;

  /// Display label for UI (same as name)
  String get label => name;
}

