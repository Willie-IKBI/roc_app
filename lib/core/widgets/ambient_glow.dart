import 'dart:ui';

import 'package:flutter/material.dart';

/// Ambient glow orb widget for background effects.
/// 
/// Creates a blurred circular gradient that can be positioned absolutely
/// to create depth and atmosphere. Used for red and violet accent glows.
/// 
/// Example:
/// ```dart
/// Stack(
///   children: [
///     AmbientGlow(
///       radius: 320,
///       color: DesignTokens.primaryRed.withValues(alpha: 0.2),
///       top: -180,
///       right: -140,
///     ),
///   ],
/// )
/// ```
class AmbientGlow extends StatelessWidget {
  const AmbientGlow({
    required this.radius,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.blurSigma,
    super.key,
  });

  /// Radius of the glow orb.
  final double radius;

  /// Color of the glow (typically with low opacity).
  final Color color;

  /// Top position offset.
  final double? top;

  /// Bottom position offset.
  final double? bottom;

  /// Left position offset.
  final double? left;

  /// Right position offset.
  final double? right;

  /// Blur sigma for the glow effect. Defaults to a heavy blur (80).
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    final effectiveBlurSigma = blurSigma ?? 80.0;

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: IgnorePointer(
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: effectiveBlurSigma,
              sigmaY: effectiveBlurSigma,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

