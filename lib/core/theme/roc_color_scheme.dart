import 'package:flutter/material.dart';

@immutable
class RocColors {
  const RocColors._();

  // Core palette
  static const Color primary = Color(0xFFD8232A); // ROC Red
  static const Color primaryAccent = Color(0xFFE53935); // Secondary red accent
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color charcoal = Color(0xFF333333);
  static const Color lightGrey = Color(0xFFF4F4F4);

  // Functional palette
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF607D8B);

  // Decorative derived tones
  static const Color outline = Color(0xFFB3B3B3);
  static const Color shadow = Color(0x33000000);
}

/// Semantic helpers for functional messaging.
@immutable
class RocSemanticColors {
  const RocSemanticColors._();

  static const Color success = RocColors.success;
  static const Color warning = RocColors.warning;
  static const Color neutral = RocColors.info;
}

final ColorScheme rocColorScheme = ColorScheme.light(
  primary: RocColors.primary,
  onPrimary: RocColors.white,
  primaryContainer: RocColors.primaryAccent,
  onPrimaryContainer: RocColors.white,
  secondary: RocColors.charcoal,
  onSecondary: RocColors.white,
  secondaryContainer: RocColors.info,
  onSecondaryContainer: RocColors.white,
  tertiary: RocColors.info,
  onTertiary: RocColors.white,
  error: RocColors.primaryAccent,
  onError: RocColors.white,
  surface: RocColors.white,
  onSurface: RocColors.charcoal,
  outline: RocColors.outline,
  outlineVariant: const Color(0xFFE0E0E0),
  shadow: RocColors.shadow,
  surfaceTint: RocColors.primary,
  inverseSurface: RocColors.charcoal,
  onInverseSurface: RocColors.white,
  inversePrimary: RocColors.primaryAccent,
  scrim: RocColors.black,
).copyWith(
  surfaceContainerHighest: RocColors.lightGrey,
  surfaceContainerHigh: RocColors.lightGrey,
  surfaceContainer: RocColors.lightGrey,
  surfaceContainerLow: RocColors.white,
  surfaceContainerLowest: RocColors.white,
  surfaceBright: RocColors.white,
  surfaceDim: RocColors.lightGrey,
);

final ThemeData rocTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: rocColorScheme,
  scaffoldBackgroundColor: RocColors.white,
  canvasColor: RocColors.white,
  splashColor: RocColors.primary.withValues(alpha: 0.12),
  focusColor: RocColors.primary.withValues(alpha: 0.20),
  dividerTheme: const DividerThemeData(color: RocColors.lightGrey),
  cardTheme: const CardThemeData(
    color: RocColors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    shadowColor: RocColors.shadow,
    margin: EdgeInsets.zero,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: RocColors.black,
    foregroundColor: RocColors.white,
    elevation: 0,
    centerTitle: false,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: RocColors.primary,
      foregroundColor: RocColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RocColors.primary,
      foregroundColor: RocColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: RocColors.charcoal,
      side: const BorderSide(color: RocColors.charcoal, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: RocColors.black, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: RocColors.black, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(color: RocColors.black, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(color: RocColors.black, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(color: RocColors.black, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(color: RocColors.white, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(color: RocColors.charcoal, fontWeight: FontWeight.w500),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: RocColors.lightGrey,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: RocColors.lightGrey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: RocColors.primary, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    labelStyle: TextStyle(color: RocColors.charcoal),
    hintStyle: TextStyle(color: Color(0xFF7A7A7A)),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: RocColors.charcoal,
    contentTextStyle: TextStyle(color: RocColors.white),
    behavior: SnackBarBehavior.floating,
  ),
  chipTheme: const ChipThemeData(
    backgroundColor: RocColors.lightGrey,
    selectedColor: RocColors.primary,
    secondarySelectedColor: RocColors.info,
    labelStyle: TextStyle(color: RocColors.charcoal),
    secondaryLabelStyle: TextStyle(color: RocColors.white),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: StadiumBorder(),
  ),
);

