import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Logger wrapper for the application with support for different log levels.
/// Can be extended with Sentry integration for production error tracking.
class AppLogger {
  AppLogger._();

  static const String _defaultName = 'AppLogger';

  /// Log a debug message (development only)
  static void debug(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name ?? _defaultName,
        level: 0,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log an info message
  static void info(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 800,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a warning message
  static void warn(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  static void error(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name ?? _defaultName,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    
    // TODO: Add Sentry integration here for production error tracking
    // if (kReleaseMode) {
    //   Sentry.captureException(error ?? Exception(message), stackTrace: stackTrace);
    // }
  }
}

