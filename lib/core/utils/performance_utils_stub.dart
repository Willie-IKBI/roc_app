import 'package:flutter/foundation.dart';

/// Performance utilities for web optimization.
/// 
/// Provides helpers to detect device capabilities and optimize rendering
/// for lower-end devices.
class PerformanceUtils {
  PerformanceUtils._();

  /// Detects if the device might have performance constraints.
  /// 
  /// On non-web platforms, always returns false (assumes normal device).
  static bool get isLowEndDevice {
    // On non-web, assume normal device
    return false;
  }

  /// Gets optimized blur sigma value based on device capabilities.
  /// 
  /// Returns a reduced blur value for low-end devices to improve performance.
  /// 
  /// [defaultBlur] - The default blur sigma value (e.g., 12.0)
  /// [lowEndBlur] - The reduced blur for low-end devices (e.g., 8.0)
  static double getOptimizedBlur({
    required double defaultBlur,
    double lowEndBlur = 8.0,
  }) {
    // On non-web, always return default blur
    return defaultBlur;
  }

  /// Checks if backdrop filter is supported.
  /// 
  /// BackdropFilter requires CSS backdrop-filter support.
  /// Returns true if supported, false otherwise.
  /// 
  /// Note: On non-web, assume support (Flutter handles it).
  static bool get isBackdropFilterSupported {
    // On non-web, assume supported (Flutter handles it)
    return true;
  }
}

