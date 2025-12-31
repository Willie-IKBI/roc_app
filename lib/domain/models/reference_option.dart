import 'package:flutter/foundation.dart';

/// Lightweight model for reference data options (dropdowns, lookups, etc.)
/// Used across multiple features for consistent id/label pairs.
@immutable
class ReferenceOption {
  const ReferenceOption({required this.id, required this.label});

  final String id;
  final String label;
}

