import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A general-purpose glass container with configurable opacity and blur.
/// 
/// This widget provides a flexible glass surface that can be used for
/// various UI elements. It's optimized for performance with RepaintBoundary.
/// 
/// Example:
/// ```dart
/// GlassContainer(
///   opacity: 0.4,
///   blurSigma: 12,
///   child: Text('Content'),
/// )
/// ```
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    required this.child,
    this.opacity = 0.4,
    this.blurSigma,
    this.borderRadius,
    this.borderColor,
    this.padding,
    this.margin,
    this.width,
    this.height,
    super.key,
  });

  /// The widget to display inside the container.
  final Widget child;

  /// Background opacity (0.0 to 1.0). Defaults to 0.4.
  final double opacity;

  /// Blur sigma value. Defaults to [DesignTokens.blurLarge].
  final double? blurSigma;

  /// Border radius. Defaults to [DesignTokens.radiusLarge].
  final BorderRadius? borderRadius;

  /// Border color. Defaults to theme-aware border color.
  final Color? borderColor;

  /// Padding inside the container.
  final EdgeInsetsGeometry? padding;

  /// Margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Optional width constraint.
  final double? width;

  /// Optional height constraint.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final effectiveBlurSigma = blurSigma ?? DesignTokens.blurLarge;
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(DesignTokens.radiusLarge);
    final effectiveBorderColor = borderColor ??
        DesignTokens.borderSubtle(brightness);
    final effectiveBackgroundColor = DesignTokens.glassBase(brightness)
        .withValues(alpha: opacity);

    Widget container = RepaintBoundary(
      child: Container(
        width: width,
        height: height,
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
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurSigma,
              sigmaY: effectiveBlurSigma,
            ),
            child: Container(
              padding: padding,
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

    return container;
  }
}

