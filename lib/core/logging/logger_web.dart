import 'dart:developer' as developer;
import 'dart:html' as html;
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
    
    // Also log to browser console in production for debugging
    if (kIsWeb) {
      try {
        final loggerName = name ?? _defaultName;
        final errorStr = error?.toString() ?? '';
        final stackStr = stackTrace?.toString() ?? '';
        html.window.console.error(
          '[$loggerName] $message${errorStr.isNotEmpty ? '\nError: $errorStr' : ''}${stackStr.isNotEmpty ? '\n$stackStr' : ''}',
        );
      } catch (_) {
        // Ignore if console is not available
      }
    }
    
    // Production error tracking integration
    // To enable Sentry:
    // 1. Add sentry_flutter to pubspec.yaml: sentry_flutter: ^8.0.0
    // 2. Initialize Sentry in main.dart before runApp()
    // 3. Uncomment the code below and import sentry_flutter
    if (kReleaseMode) {
      _reportErrorToTrackingService(
        message: message,
        name: name,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Reports errors to external tracking service (e.g., Sentry)
  /// 
  /// This method can be extended to integrate with Sentry, Firebase Crashlytics,
  /// or other error tracking services.
  /// 
  /// Example Sentry integration:
  /// ```dart
  /// import 'package:sentry_flutter/sentry_flutter.dart';
  /// 
  /// static void _reportErrorToTrackingService({
  ///   required String message,
  ///   String? name,
  ///   Object? error,
  ///   StackTrace? stackTrace,
  /// }) {
  ///   Sentry.captureException(
  ///     error ?? Exception(message),
  ///     stackTrace: stackTrace,
  ///     hint: Hint.withMap({
  ///       'logger': name ?? _defaultName,
  ///       'message': message,
  ///     }),
  ///   );
  /// }
  /// ```
  static void _reportErrorToTrackingService({
    required String message,
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Placeholder for error tracking service integration
    // Currently, errors are only logged via developer.log
    // To enable production error tracking, implement the integration above
  }
}

