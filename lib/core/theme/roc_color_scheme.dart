import 'package:flutter/material.dart';
import 'design_tokens.dart';

@immutable
class RocColors {
  const RocColors._();

  // Core palette - using design tokens for consistency
  static const Color primary = DesignTokens.primaryRed; // ROC Red
  static const Color primaryAccent = DesignTokens.primaryRedLight; // Secondary red accent
  static const Color black = Color(0xFF000000);
  static const Color white = DesignTokens.textPrimaryDark;
  static const Color charcoal = DesignTokens.textPrimaryLight;
  static const Color lightGrey = DesignTokens.glassBaseLight;

  // Functional palette
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF607D8B);

  // Decorative derived tones - using design tokens
  static const Color outline = DesignTokens.borderVisibleLight;
  static const Color shadow = DesignTokens.shadowColor;
}

/// Semantic helpers for functional messaging.
@immutable
class RocSemanticColors {
  const RocSemanticColors._();

  static const Color success = RocColors.success;
  static const Color warning = RocColors.warning;
  static const Color neutral = RocColors.info;
}

/// Light theme color scheme using design tokens.
final ColorScheme rocColorScheme = ColorScheme.light(
  primary: DesignTokens.primaryRed,
  onPrimary: DesignTokens.textPrimaryDark,
  primaryContainer: DesignTokens.primaryRedLight,
  onPrimaryContainer: DesignTokens.textPrimaryDark,
  secondary: DesignTokens.textPrimaryLight,
  onSecondary: DesignTokens.textPrimaryDark,
  secondaryContainer: const Color(0xFF607D8B), // info color
  onSecondaryContainer: DesignTokens.textPrimaryDark,
  tertiary: const Color(0xFF607D8B), // info color
  onTertiary: DesignTokens.textPrimaryDark,
  error: DesignTokens.primaryRedLight,
  onError: DesignTokens.textPrimaryDark,
  surface: DesignTokens.canvasLight,
  onSurface: DesignTokens.textPrimaryLight,
  outline: DesignTokens.borderVisibleLight,
  outlineVariant: DesignTokens.borderSubtleLight,
  shadow: DesignTokens.shadowColor,
  surfaceTint: DesignTokens.primaryRed,
  inverseSurface: DesignTokens.textPrimaryLight,
  onInverseSurface: DesignTokens.canvasLight,
  inversePrimary: DesignTokens.primaryRedLight,
  scrim: DesignTokens.canvasDark,
).copyWith(
  surfaceContainerHighest: DesignTokens.glassBaseLight,
  surfaceContainerHigh: DesignTokens.glassBaseLight,
  surfaceContainer: DesignTokens.glassBaseLight,
  surfaceContainerLow: DesignTokens.canvasLight,
  surfaceContainerLowest: DesignTokens.canvasLight,
  surfaceBright: DesignTokens.canvasLight,
  surfaceDim: DesignTokens.glassBaseLight,
);

/// Light theme using design tokens.
final ThemeData rocLightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: rocColorScheme,
  scaffoldBackgroundColor: DesignTokens.canvasLight,
  canvasColor: DesignTokens.canvasLight,
  splashColor: DesignTokens.primaryRed.withValues(alpha: 0.12),
  focusColor: DesignTokens.primaryRed.withValues(alpha: 0.20),
  dividerTheme: DividerThemeData(color: DesignTokens.borderSubtleLight),
  cardTheme: CardThemeData(
    color: DesignTokens.glassBaseLight,
    surfaceTintColor: Colors.transparent,
    elevation: 2,
    shadowColor: DesignTokens.shadowColor,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      side: BorderSide(
        color: DesignTokens.borderSubtleLight,
        width: 1,
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DesignTokens.canvasLight,
    foregroundColor: DesignTokens.textPrimaryLight,
    elevation: 0,
    centerTitle: false,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: DesignTokens.primaryRed,
      foregroundColor: DesignTokens.textPrimaryDark,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: 14,
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DesignTokens.primaryRed,
      foregroundColor: DesignTokens.textPrimaryDark,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: 14,
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: DesignTokens.textPrimaryLight,
      side: BorderSide(
        color: DesignTokens.textPrimaryLight,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: DesignTokens.textPrimaryDark,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: DesignTokens.textPrimaryLight,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: DesignTokens.glassBaseLight,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: DesignTokens.borderSubtleLight),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: DesignTokens.borderSubtleLight),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: DesignTokens.primaryRed,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
    ),
    labelStyle: TextStyle(color: DesignTokens.textPrimaryLight),
    hintStyle: TextStyle(color: DesignTokens.textTertiaryLight),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: DesignTokens.glassActiveLight,
    contentTextStyle: TextStyle(color: DesignTokens.textPrimaryLight),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: DesignTokens.glassBaseLight,
    selectedColor: DesignTokens.primaryRed,
    secondarySelectedColor: const Color(0xFF607D8B), // info color
    labelStyle: TextStyle(color: DesignTokens.textPrimaryLight),
    secondaryLabelStyle: TextStyle(color: DesignTokens.textPrimaryDark),
    padding: const EdgeInsets.symmetric(
      horizontal: DesignTokens.spaceM,
      vertical: DesignTokens.spaceS,
    ),
    shape: StadiumBorder(),
  ),
);

/// Legacy export for backward compatibility.
@Deprecated('Use rocLightTheme instead')
final ThemeData rocTheme = rocLightTheme;

