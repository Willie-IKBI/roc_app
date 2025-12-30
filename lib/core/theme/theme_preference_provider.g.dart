// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_preference_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for theme preference (light/dark mode) with SharedPreferences persistence.

@ProviderFor(ThemePreference)
const themePreferenceProvider = ThemePreferenceProvider._();

/// Provider for theme preference (light/dark mode) with SharedPreferences persistence.
final class ThemePreferenceProvider
    extends $AsyncNotifierProvider<ThemePreference, ThemeMode> {
  /// Provider for theme preference (light/dark mode) with SharedPreferences persistence.
  const ThemePreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themePreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themePreferenceHash();

  @$internal
  @override
  ThemePreference create() => ThemePreference();
}

String _$themePreferenceHash() => r'e157305787cd28eb0596d11a22402208d189e4ab';

/// Provider for theme preference (light/dark mode) with SharedPreferences persistence.

abstract class _$ThemePreference extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
