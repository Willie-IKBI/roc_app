import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A glassmorphism card widget with backdrop blur and rounded corners.
/// 
/// This widget creates a frosted glass effect using BackdropFilter with
/// optimized blur values for performance. It includes a subtle border and
/// rounded corners matching the design system.
/// 
/// Example:
/// ```dart
/// GlassCard(
///   child: Text('Content here'),
/// )
/// ```
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma,
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  /// The widget to display inside the card.
  final Widget child;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Border radius. Defaults to [DesignTokens.radiusLarge] (rounded-3xl).
  final BorderRadius? borderRadius;

  /// Blur sigma value. Defaults to [DesignTokens.blurLarge] (optimized for performance).
  final double? blurSigma;

  /// Background color. Defaults to [DesignTokens.glassBaseDark] for dark theme.
  final Color? backgroundColor;

  /// Border color. Defaults to [DesignTokens.borderSubtleDark] for dark theme.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(DesignTokens.radiusLarge);
    final effectiveBlurSigma = blurSigma ?? DesignTokens.blurLarge;
    final effectiveBackgroundColor = backgroundColor ??
        DesignTokens.glassBase(brightness);
    final effectiveBorderColor = borderColor ??
        DesignTokens.borderSubtle(brightness);

    return RepaintBoundary(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: effectiveBorderColor,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: effectiveBlurSigma, sigmaY: effectiveBlurSigma),
            child: Container(
              padding: padding ?? const EdgeInsets.all(DesignTokens.spaceM),
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: effectiveBorderRadius,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

