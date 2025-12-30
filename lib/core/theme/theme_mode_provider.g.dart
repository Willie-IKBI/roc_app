// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current ThemeData based on the user's theme preference.
///
/// Watches ThemePreferenceProvider and returns the appropriate light or dark
/// theme with proper typography (Inter for body, Fira Code for monospace).

@ProviderFor(themeMode)
const themeModeProvider = ThemeModeProvider._();

/// Provides the current ThemeData based on the user's theme preference.
///
/// Watches ThemePreferenceProvider and returns the appropriate light or dark
/// theme with proper typography (Inter for body, Fira Code for monospace).

final class ThemeModeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the current ThemeData based on the user's theme preference.
  ///
  /// Watches ThemePreferenceProvider and returns the appropriate light or dark
  /// theme with proper typography (Inter for body, Fira Code for monospace).
  const ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return themeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$themeModeHash() => r'51c609aa3448002f79a49df3f057935358d0685a';

/// Provides the light theme.

@ProviderFor(lightTheme)
const lightThemeProvider = LightThemeProvider._();

/// Provides the light theme.

final class LightThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the light theme.
  const LightThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return lightTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$lightThemeHash() => r'd34cdbcaba068e2095429c3fcb387d38bd8570e6';

/// Provides the dark theme.

@ProviderFor(darkTheme)
const darkThemeProvider = DarkThemeProvider._();

/// Provides the dark theme.

final class DarkThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the dark theme.
  const DarkThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return darkTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$darkThemeHash() => r'3455491f073f2f6e62ac0c05bcb45d5a6f6bbd7a';
