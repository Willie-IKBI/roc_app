import 'dart:html' as html;

/// Web console utilities (web-only implementation)
class WebConsole {
  WebConsole._();

  /// Log an error to the browser console
  static void error(String message) {
    html.window.console.error(message);
  }

  /// Log a message to the browser console
  static void log(String message) {
    html.window.console.log(message);
  }

  /// Reload the current page
  static void reload() {
    html.window.location.reload();
  }

  /// Get the current URL
  static String get currentUrl => html.window.location.href;

  /// Get the hostname
  static String get hostname => html.window.location.hostname ?? '';
}

