import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Dark glassmorphism color scheme for Repair On Call.
/// 
/// Uses #050505 canvas, zinc surfaces with transparency, and red accents
/// (#dc2626, #ef4444) for a futuristic, high-contrast design.
final ColorScheme rocDarkColorScheme = ColorScheme.dark(
  primary: DesignTokens.primaryRed,
  onPrimary: DesignTokens.textPrimaryDark,
  primaryContainer: DesignTokens.primaryRedLight,
  onPrimaryContainer: DesignTokens.textPrimaryDark,
  secondary: DesignTokens.glassHighlightDark,
  onSecondary: DesignTokens.textPrimaryDark,
  secondaryContainer: DesignTokens.glassActiveDark,
  onSecondaryContainer: DesignTokens.textPrimaryDark,
  tertiary: DesignTokens.glassHighlightDark,
  onTertiary: DesignTokens.textPrimaryDark,
  error: DesignTokens.primaryRed,
  onError: DesignTokens.textPrimaryDark,
  surface: DesignTokens.glassBaseDark,
  onSurface: DesignTokens.textPrimaryDark,
  surfaceContainerHighest: DesignTokens.glassActiveDark,
  surfaceContainerHigh: DesignTokens.glassHighlightDark,
  surfaceContainer: DesignTokens.glassBaseDark,
  surfaceContainerLow: DesignTokens.glassBaseDark,
  surfaceContainerLowest: DesignTokens.canvasDark,
  outline: DesignTokens.borderVisibleDark,
  outlineVariant: DesignTokens.borderSubtleDark,
  shadow: DesignTokens.shadowColor,
  surfaceTint: DesignTokens.primaryRed,
  inverseSurface: DesignTokens.textPrimaryDark,
  onInverseSurface: DesignTokens.canvasDark,
  inversePrimary: DesignTokens.primaryRedLight,
  scrim: DesignTokens.canvasDark,
  surfaceBright: DesignTokens.glassHighlightDark,
  surfaceDim: DesignTokens.glassBaseDark,
);

