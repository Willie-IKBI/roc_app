import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'design_tokens.dart';
import 'roc_color_scheme.dart';
import 'roc_dark_color_scheme.dart';
import 'theme_preference_provider.dart';

part 'theme_mode_provider.g.dart';

/// Safe wrapper for GoogleFonts.inter() that falls back to system font on error.
/// This prevents AssetManifest.json errors during Flutter web development.
TextStyle _safeGoogleFont({
  required FontWeight fontWeight,
  required Color color,
  double? letterSpacing,
}) {
  try {
    return GoogleFonts.inter(
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  } catch (e) {
    // Fallback to system font if Google Fonts fails to load
    return TextStyle(
      fontFamily: 'Inter',
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

/// Provides the current ThemeData based on the user's theme preference.
/// 
/// Watches ThemePreferenceProvider and returns the appropriate light or dark
/// theme with proper typography (Inter for body, Fira Code for monospace).
@riverpod
ThemeData themeMode(Ref ref) {
  final themePreference = ref.watch(themePreferenceProvider);
  final brightness = themePreference.when(
    data: (mode) => mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    loading: () => Brightness.dark, // Default to dark while loading
    error: (_, __) => Brightness.dark, // Default to dark on error
  );

  final baseTheme = brightness == Brightness.dark
      ? _buildDarkTheme()
      : _buildLightTheme();

  return baseTheme;
}

/// Builds the dark glassmorphism theme.
ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: rocDarkColorScheme,
    scaffoldBackgroundColor: DesignTokens.canvasDark,
    canvasColor: DesignTokens.canvasDark,
    splashColor: DesignTokens.primaryRed.withValues(alpha: 0.12),
    focusColor: DesignTokens.primaryRed.withValues(alpha: 0.20),
    dividerTheme: DividerThemeData(color: DesignTokens.borderSubtleDark),
    cardTheme: CardThemeData(
      color: DesignTokens.glassBaseDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: BorderSide(color: DesignTokens.borderSubtleDark, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: DesignTokens.textPrimaryDark,
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
        textStyle: _safeGoogleFont(
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
        elevation: 0,
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
        textStyle: _safeGoogleFont(
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.textSecondaryDark,
        side: BorderSide(
          color: DesignTokens.borderVisibleDark,
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceL,
          vertical: 14,
        ),
        textStyle: _safeGoogleFont(
          fontWeight: FontWeight.w500,
          color: DesignTokens.textSecondaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DesignTokens.textSecondaryDark,
        textStyle: _safeGoogleFont(
          fontWeight: FontWeight.w500,
          color: DesignTokens.textSecondaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.bold,
        letterSpacing: DesignTokens.letterSpacingTight,
      ),
      displayMedium: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.bold,
        letterSpacing: DesignTokens.letterSpacingTight,
      ),
      displaySmall: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingTight,
      ),
      headlineMedium: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingTight,
      ),
      headlineSmall: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingTight,
      ),
      titleLarge: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      titleMedium: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w500,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      titleSmall: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      bodyLarge: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w400,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      bodyMedium: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w400,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      bodySmall: _safeGoogleFont(
        color: DesignTokens.textSecondaryDark,
        fontWeight: FontWeight.w400,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      labelLarge: _safeGoogleFont(
        color: DesignTokens.textPrimaryDark,
        fontWeight: FontWeight.w600,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      labelMedium: _safeGoogleFont(
        color: DesignTokens.textSecondaryDark,
        fontWeight: FontWeight.w500,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
      labelSmall: _safeGoogleFont(
        color: DesignTokens.textTertiaryDark,
        fontWeight: FontWeight.w500,
        letterSpacing: DesignTokens.letterSpacingNormal,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.glassBaseDark,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: DesignTokens.borderSubtleDark),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignTokens.borderSubtleDark),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: DesignTokens.primaryRed,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      labelStyle: _safeGoogleFont(
        fontWeight: FontWeight.w400,
        color: DesignTokens.textSecondaryDark,
      ),
      hintStyle: _safeGoogleFont(
        fontWeight: FontWeight.w400,
        color: DesignTokens.textTertiaryDark,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DesignTokens.glassActiveDark,
      contentTextStyle: _safeGoogleFont(
        fontWeight: FontWeight.w400,
        color: DesignTokens.textPrimaryDark,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: DesignTokens.glassBaseDark,
      selectedColor: DesignTokens.primaryRed,
      secondarySelectedColor: DesignTokens.glassHighlightDark,
      labelStyle: _safeGoogleFont(
        fontWeight: FontWeight.w400,
        color: DesignTokens.textPrimaryDark,
      ),
      secondaryLabelStyle: _safeGoogleFont(
        fontWeight: FontWeight.w400,
        color: DesignTokens.textPrimaryDark,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
      ),
    ),
  );
}

/// Builds the light theme.
ThemeData _buildLightTheme() {
  String? fontFamily;
  try {
    fontFamily = GoogleFonts.inter().fontFamily;
  } catch (e) {
    // Fallback to system font if Google Fonts fails to load
    fontFamily = 'Inter';
  }
  return rocLightTheme.copyWith(
    textTheme: rocLightTheme.textTheme.apply(
      fontFamily: fontFamily,
    ),
  );
}

/// Provides the light theme.
@riverpod
ThemeData lightTheme(Ref ref) {
  return _buildLightTheme();
}

/// Provides the dark theme.
@riverpod
ThemeData darkTheme(Ref ref) {
  return _buildDarkTheme();
}

