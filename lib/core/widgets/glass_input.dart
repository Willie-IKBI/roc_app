import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Glassmorphism input field styling helper.
/// 
/// Provides consistent styling for TextFields with glass effect.
/// Use with InputDecorationTheme or apply directly to TextField.
/// 
/// Example:
/// ```dart
/// TextField(
///   decoration: GlassInput.decoration(
///     context: context,
///     label: 'Email',
///   ),
/// )
/// 
/// // Or use the convenience factory:
/// GlassInput.text(
///   controller: _controller,
///   label: 'Email',
/// )
/// ```
class GlassInput {
  GlassInput._();

  /// Creates a TextField with glass styling.
  /// 
  /// Convenience factory for creating a fully styled TextField.
  static Widget text({
    required BuildContext context,
    required TextEditingController controller,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onTap,
    bool enabled = true,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      textCapitalization: textCapitalization,
      decoration: decoration(
        context: context,
        label: label,
        hint: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  /// Creates a TextFormField with glass styling.
  /// 
  /// Convenience factory for creating a fully styled TextFormField with validation.
  static Widget textForm({
    required BuildContext context,
    required TextEditingController controller,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onTap,
    bool enabled = true,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      textCapitalization: textCapitalization,
      decoration: decoration(
        context: context,
        label: label,
        hint: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  /// Creates an InputDecoration with glassmorphism styling.
  static InputDecoration decoration({
    required BuildContext context,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: DesignTokens.glassBase(brightness),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: DesignTokens.borderSubtle(brightness)),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignTokens.borderSubtle(brightness)),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: DesignTokens.primaryRed,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: DesignTokens.primaryRed,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: DesignTokens.primaryRed,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.textSecondary(brightness),
      ),
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: DesignTokens.textTertiary(brightness),
      ),
      helperStyle: theme.textTheme.bodySmall?.copyWith(
        color: DesignTokens.textTertiary(brightness),
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(
        color: DesignTokens.primaryRed,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceM,
      ),
    );
  }
}

