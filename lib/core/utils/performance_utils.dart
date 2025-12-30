import 'dart:html' as html;
import 'package:flutter/foundation.dart';

/// Performance utilities for web optimization.
/// 
/// Provides helpers to detect device capabilities and optimize rendering
/// for lower-end devices.
class PerformanceUtils {
  PerformanceUtils._();

  /// Detects if the device might have performance constraints.
  /// 
  /// Uses heuristics like hardware concurrency and device memory (if available)
  /// to determine if we should reduce visual effects for better performance.
  /// 
  /// Returns true if device appears to be low-end.
  static bool get isLowEndDevice {
    if (!kIsWeb) return false;

    try {
      // Check hardware concurrency (CPU cores)
      final navigator = html.window.navigator;
      final hardwareConcurrency = (navigator as dynamic).hardwareConcurrency;
      if (hardwareConcurrency != null && hardwareConcurrency < 4) {
        return true;
      }

      // Check device memory (if available)
      final deviceMemory = (navigator as dynamic).deviceMemory;
      if (deviceMemory != null && deviceMemory < 4) {
        return true;
      }

      // Check for mobile user agents (often lower-end devices)
      final userAgent = navigator.userAgent.toLowerCase();
      if (userAgent.contains('mobile') && 
          (userAgent.contains('android') || userAgent.contains('iphone'))) {
        // Mobile devices might benefit from reduced effects
        // But we'll be conservative and only flag very low-end
        return false; // Don't auto-reduce on mobile, let user preference handle it
      }
    } catch (_) {
      // If we can't detect, assume normal device
    }

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
    if (isLowEndDevice) {
      return lowEndBlur;
    }
    return defaultBlur;
  }

  /// Checks if backdrop filter is supported.
  /// 
  /// BackdropFilter requires CSS backdrop-filter support.
  /// Returns true if supported, false otherwise.
  /// 
  /// Note: Modern browsers (Chrome, Firefox, Safari) support backdrop-filter.
  /// This method assumes support for simplicity.
  static bool get isBackdropFilterSupported {
    if (!kIsWeb) return true; // Assume supported on non-web
    // Modern browsers support backdrop-filter
    // We assume support rather than trying to detect it
    return true;
  }
}

