import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../logging/logger.dart';
import 'glass_error_state.dart';

/// An error boundary widget that catches errors in the widget tree
/// and displays a user-friendly error UI instead of crashing.
/// 
/// This widget wraps a child and catches any errors that occur during
/// the child's build or lifecycle methods.
/// 
/// Example:
/// ```dart
/// ErrorBoundary(
///   child: MyWidget(),
///   onError: (error, stackTrace) {
///     // Log error or report to error tracking service
///   },
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    required this.child,
    this.onError,
    this.fallback,
    super.key,
  });

  /// The widget to wrap with error boundary
  final Widget child;

  /// Callback when an error is caught
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Custom error widget to display. If null, uses default GlassErrorState
  final Widget Function(Object error, StackTrace stackTrace)? fallback;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  bool _hasError = false;

  @override
  void didCatchError(Object error, StackTrace stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _hasError = true;
    });

    // Log the error
    AppLogger.error(
      'Error boundary caught error: $error',
      error: error,
      stackTrace: stackTrace,
      name: 'ErrorBoundary',
    );

    // Also log to browser console in production for debugging
    if (kIsWeb) {
      html.window.console.error(
        'ErrorBoundary: $error\n${stackTrace.toString()}',
      );
    }

    // Call custom error handler if provided
    widget.onError?.call(error, stackTrace);
  }

  void _handleRetry() {
    // Try to clear the error first
    setState(() {
      _error = null;
      _stackTrace = null;
      _hasError = false;
    });
    
    // If still in error state after a delay, reload the page
    if (kIsWeb) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _hasError) {
          html.window.location.reload();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      // Use custom fallback if provided
      if (widget.fallback != null) {
        return widget.fallback!(_error!, _stackTrace ?? StackTrace.current);
      }

      // Default error UI
      return GlassErrorState(
        title: 'Something went wrong',
        message: kDebugMode
            ? _error.toString()
            : 'An unexpected error occurred. Please try again.',
        icon: Icons.error_outline,
        onRetry: _handleRetry,
      );
    }

    return widget.child;
  }
}

