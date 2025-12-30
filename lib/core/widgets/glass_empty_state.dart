import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import 'glass_card.dart';

/// A reusable empty state widget with glass styling.
/// 
/// Displays an icon, title, and description in a glass card.
/// Used throughout the app for empty states (no data, no results, etc.).
/// 
/// Example:
/// ```dart
/// GlassEmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No claims yet',
///   description: 'New claims will appear here once captured.',
/// )
/// ```
class GlassEmptyState extends StatelessWidget {
  const GlassEmptyState({
    required this.icon,
    required this.title,
    this.description,
    this.action,
    super.key,
  });

  /// Icon to display.
  final IconData icon;

  /// Title text.
  final String title;

  /// Optional description text.
  final String? description;

  /// Optional action button.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(DesignTokens.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: DesignTokens.textTertiary(brightness),
            ),
            const SizedBox(height: DesignTokens.spaceL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary(brightness),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: DesignTokens.spaceL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

