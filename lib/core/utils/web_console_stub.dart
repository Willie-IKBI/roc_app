/// Web console utilities (non-web stub implementation)
class WebConsole {
  WebConsole._();

  /// Log an error to the browser console (no-op on non-web)
  static void error(String message) {
    // No-op on non-web platforms
  }

  /// Log a message to the browser console (no-op on non-web)
  static void log(String message) {
    // No-op on non-web platforms
  }

  /// Reload the current page (no-op on non-web)
  static void reload() {
    // No-op on non-web platforms
  }
}

