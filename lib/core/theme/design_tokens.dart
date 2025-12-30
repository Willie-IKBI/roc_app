import 'package:flutter/material.dart';

/// Design tokens for the Repair On Call glassmorphism design system.
/// 
/// These tokens provide a centralized source of truth for colors, spacing,
/// typography, borders, shadows, and other design constants used throughout
/// the application. All tokens are theme-aware and adapt to light/dark modes.
@immutable
class DesignTokens {
  const DesignTokens._();

  // ============================================================================
  // Colors - Dark Theme
  // ============================================================================

  /// Canvas/body background color - deep black (#050505, not pure black)
  static const Color canvasDark = Color(0xFF050505);

  /// Glass surface base - zinc-900 with 40% opacity
  static const Color glassBaseDark = Color(0x6617171A); // zinc-900/40

  /// Glass surface highlight - zinc-800 with 50% opacity
  static const Color glassHighlightDark = Color(0x8027242F); // zinc-800/50

  /// Glass surface active - zinc-800 with 80% opacity or white with 5% opacity
  static const Color glassActiveDark = Color(0xCC27242F); // zinc-800/80

  /// Primary brand red - #dc2626 (Tailwind red-600)
  static const Color primaryRed = Color(0xFFDC2626);

  /// Primary brand red light - #ef4444 (Tailwind red-500)
  static const Color primaryRedLight = Color(0xFFEF4444);

  /// Text primary - white
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Text secondary - zinc-400
  static const Color textSecondaryDark = Color(0xFFA1A1AA);

  /// Text tertiary/meta - zinc-500
  static const Color textTertiaryDark = Color(0xFF71717A);

  /// Border subtle - white with 5% opacity
  static const Color borderSubtleDark = Color(0x0DFFFFFF); // white/5

  /// Border visible - white with 10% opacity
  static const Color borderVisibleDark = Color(0x1AFFFFFF); // white/10

  // ============================================================================
  // Colors - Light Theme
  // ============================================================================

  /// Canvas/body background color - soft off-white (reduced from pure white)
  static const Color canvasLight = Color(0xFFFAFAFA);

  /// Glass surface base - light grey with 95% opacity for better contrast
  static const Color glassBaseLight = Color(0xF2F0F0F0); // #F0F0F0 with 95% opacity (0xF2 = 242/255 ≈ 95%)

  /// Glass surface highlight - slightly darker grey
  static const Color glassHighlightLight = Color(0xFFE8E8E8);

  /// Glass surface active - darker grey (slightly adjusted)
  static const Color glassActiveLight = Color(0xFFD8D8D8);

  /// Text primary - softer black (reduced contrast)
  static const Color textPrimaryLight = Color(0xFF2A2A2A);

  /// Text secondary - medium grey
  static const Color textSecondaryLight = Color(0xFF666666);

  /// Text tertiary - light grey
  static const Color textTertiaryLight = Color(0xFF999999);

  /// Border subtle - more visible grey
  static const Color borderSubtleLight = Color(0xFFD0D0D0);

  /// Border visible - more visible medium grey
  static const Color borderVisibleLight = Color(0xFFB0B0B0);

  // ============================================================================
  // Spacing
  // ============================================================================

  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  // ============================================================================
  // Border Radius
  // ============================================================================

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0; // rounded-3xl
  static const double radiusPill = 999.0; // rounded-full

  // ============================================================================
  // Blur
  // ============================================================================

  /// Small blur - 8px (optimized for performance)
  static const double blurSmall = 8.0;

  /// Medium blur - 16px
  static const double blurMedium = 16.0;

  /// Large blur - 24px (backdrop-blur-xl, optimized to 12 for performance)
  static const double blurLarge = 12.0; // Reduced from 24 for performance

  // ============================================================================
  // Shadows
  // ============================================================================

  /// Red glow shadow - red-500 with 20% opacity
  static const Color shadowRedGlow = Color(0x33EF4444); // red-500/20

  /// Standard shadow color
  static const Color shadowColor = Color(0x33000000); // black/20

  // ============================================================================
  // Typography
  // ============================================================================

  /// Letter spacing for headings (tracking-tight)
  static const double letterSpacingTight = -0.5;

  /// Letter spacing for body text
  static const double letterSpacingNormal = 0.0;

  /// Monospace text opacity (for IDs, dates, numbers)
  static const double monospaceOpacity = 0.7;

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Get glass base color based on theme brightness
  static Color glassBase(Brightness brightness) {
    return brightness == Brightness.dark ? glassBaseDark : glassBaseLight;
  }

  /// Get glass highlight color based on theme brightness
  static Color glassHighlight(Brightness brightness) {
    return brightness == Brightness.dark
        ? glassHighlightDark
        : glassHighlightLight;
  }

  /// Get glass active color based on theme brightness
  static Color glassActive(Brightness brightness) {
    return brightness == Brightness.dark ? glassActiveDark : glassActiveLight;
  }

  /// Get text primary color based on theme brightness
  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;
  }

  /// Get text secondary color based on theme brightness
  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.dark
        ? textSecondaryDark
        : textSecondaryLight;
  }

  /// Get text tertiary color based on theme brightness
  static Color textTertiary(Brightness brightness) {
    return brightness == Brightness.dark
        ? textTertiaryDark
        : textTertiaryLight;
  }

  /// Get border subtle color based on theme brightness
  static Color borderSubtle(Brightness brightness) {
    return brightness == Brightness.dark
        ? borderSubtleDark
        : borderSubtleLight;
  }

  /// Get border visible color based on theme brightness
  static Color borderVisible(Brightness brightness) {
    return brightness == Brightness.dark
        ? borderVisibleDark
        : borderVisibleLight;
  }

  /// Get canvas color based on theme brightness
  static Color canvas(Brightness brightness) {
    return brightness == Brightness.dark ? canvasDark : canvasLight;
  }
}

