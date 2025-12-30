import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import 'glass_button.dart';
import 'glass_card.dart';

/// A reusable error state widget with glass styling.
/// 
/// Displays an error icon, title, message, and retry button in a glass card.
/// Used throughout the app for error states.
/// 
/// Example:
/// ```dart
/// GlassErrorState(
///   title: 'Unable to load data',
///   message: error.toString(),
///   onRetry: () => ref.read(controllerProvider.notifier).refresh(),
/// )
/// ```
class GlassErrorState extends StatelessWidget {
  const GlassErrorState({
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
    super.key,
  });

  /// Error title.
  final String title;

  /// Error message.
  final String message;

  /// Callback when retry button is pressed.
  final VoidCallback onRetry;

  /// Icon to display. Defaults to error_outline.
  final IconData icon;

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
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spaceL),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceS),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: DesignTokens.textSecondary(brightness),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceL),
            GlassButton.primary(
              onPressed: onRetry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: DesignTokens.spaceS),
                  Text('Retry'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

