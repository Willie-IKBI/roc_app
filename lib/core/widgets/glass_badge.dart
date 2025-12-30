import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A glassmorphism badge component for status indicators.
/// 
/// Uses transparent backgrounds with colored borders and text.
/// Pill-shaped (rounded-full) design.
/// 
/// Example:
/// ```dart
/// GlassBadge.success(
///   label: 'Active',
/// )
/// ```
class GlassBadge extends StatelessWidget {
  const GlassBadge.success({
    required this.label,
    this.semanticLabel,
    super.key,
  })  : color = const Color(0xFF4CAF50), // success green
        variant = _BadgeVariant.success;

  const GlassBadge.warning({
    required this.label,
    this.semanticLabel,
    super.key,
  })  : color = const Color(0xFFFFC107), // warning yellow
        variant = _BadgeVariant.warning;

  const GlassBadge.error({
    required this.label,
    this.semanticLabel,
    super.key,
  })  : color = DesignTokens.primaryRed,
        variant = _BadgeVariant.error;

  const GlassBadge.info({
    required this.label,
    this.semanticLabel,
    super.key,
  })  : color = const Color(0xFF607D8B), // info blue-grey
        variant = _BadgeVariant.info;

  const GlassBadge.custom({
    required this.label,
    required this.color,
    this.semanticLabel,
    super.key,
  }) : variant = _BadgeVariant.custom;

  final String label;
  final Color color;
  final String? semanticLabel;
  final _BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel ?? label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceM,
          vertical: DesignTokens.spaceS,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

enum _BadgeVariant { success, warning, error, info, custom }

