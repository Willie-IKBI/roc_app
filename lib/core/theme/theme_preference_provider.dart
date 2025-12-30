import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_preference_provider.g.dart';

/// Provider for theme preference (light/dark mode) with SharedPreferences persistence.
@riverpod
class ThemePreference extends _$ThemePreference {
  static const String _key = 'theme_mode';
  static const String _lightValue = 'light';
  static const String _darkValue = 'dark';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == _darkValue) {
      return ThemeMode.dark;
    } else if (saved == _lightValue) {
      return ThemeMode.light;
    }
    // Default to dark for glassmorphism design
    return ThemeMode.dark;
  }

  /// Set theme mode and persist to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = mode == ThemeMode.dark ? _darkValue : _lightValue;
    await prefs.setString(_key, value);
    state = AsyncData(mode);
  }

  /// Toggle between light and dark themes
  Future<void> toggle() async {
    final current = await future;
    final newMode = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

