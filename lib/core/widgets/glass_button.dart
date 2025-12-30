import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A glassmorphism button with rounded-full shape.
/// 
/// Supports primary (red), secondary (ghost), and outlined variants.
/// All buttons use pill-shaped (rounded-full) design.
/// 
/// ## Variants
/// 
/// - **Primary**: Red background for primary actions
/// - **Secondary**: Ghost/transparent for secondary actions
/// - **Outlined**: Border-only style
/// 
/// ## Usage Examples
/// 
/// ```dart
/// // Primary action button
/// GlassButton.primary(
///   onPressed: () => save(),
///   semanticLabel: 'Save changes',
///   child: const Text('Save'),
/// )
/// 
/// // Secondary action
/// GlassButton.secondary(
///   onPressed: () => cancel(),
///   child: const Text('Cancel'),
/// )
/// 
/// // Icon button
/// GlassButton.ghost(
///   onPressed: () => edit(),
///   semanticLabel: 'Edit item',
///   padding: const EdgeInsets.all(DesignTokens.spaceS),
///   child: const Icon(Icons.edit),
/// )
/// ```
/// 
/// ## Best Practices
/// 
/// - Always provide `semanticLabel` for icon-only buttons
/// - Use primary for the main action, secondary/ghost for alternatives
/// - Ensure touch targets are at least 48dp (use padding if needed)
/// - Disable buttons by setting `onPressed: null`
class GlassButton extends StatelessWidget {
  const GlassButton.primary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    super.key,
  })  : variant = _ButtonVariant.primary,
        outlined = false;

  const GlassButton.secondary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    super.key,
  })  : variant = _ButtonVariant.secondary,
        outlined = false;

  const GlassButton.ghost({
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    super.key,
  })  : variant = _ButtonVariant.ghost,
        outlined = false;

  const GlassButton.outlined({
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    super.key,
  })  : variant = _ButtonVariant.secondary,
        outlined = true;

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final _ButtonVariant variant;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isEnabled = onPressed != null;

    final backgroundColor = _getBackgroundColor(brightness, isEnabled);
    final foregroundColor = _getForegroundColor(brightness, isEnabled);
    final borderColor = outlined
        ? DesignTokens.borderVisible(brightness)
        : Colors.transparent;

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: isEnabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceL,
                  vertical: 14,
                ),
            constraints: const BoxConstraints(
              minHeight: 48, // WCAG AA minimum touch target
              minWidth: 48,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(
                color: borderColor,
                width: outlined ? 1 : 0,
              ),
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.labelLarge!.copyWith(
                color: foregroundColor,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(Brightness brightness, bool isEnabled) {
    if (!isEnabled) {
      return DesignTokens.glassBase(brightness).withValues(alpha: 0.3);
    }

    switch (variant) {
      case _ButtonVariant.primary:
        return DesignTokens.primaryRed;
      case _ButtonVariant.secondary:
        return Colors.transparent;
      case _ButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(Brightness brightness, bool isEnabled) {
    if (!isEnabled) {
      return DesignTokens.textTertiary(brightness);
    }

    switch (variant) {
      case _ButtonVariant.primary:
        return DesignTokens.textPrimaryDark;
      case _ButtonVariant.secondary:
        return DesignTokens.textSecondary(brightness);
      case _ButtonVariant.ghost:
        return DesignTokens.textSecondary(brightness);
    }
  }
}

enum _ButtonVariant { primary, secondary, ghost }

