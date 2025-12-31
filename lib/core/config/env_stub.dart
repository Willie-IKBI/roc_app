import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:developer' as developer;

class Env {
  const Env._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  /// Validates that all required environment variables are present and valid
  static void validate() {
    if (supabaseUrl.isEmpty) {
      throw StateError(
        'SUPABASE_URL is required but not provided. '
        'Provide it via --dart-define=SUPABASE_URL=... or use --dart-define-from-file=env/dev.json',
      );
    }

    // Check for placeholder values before format validation
    if (_isPlaceholder(supabaseUrl)) {
      throw StateError(
        'SUPABASE_URL appears to be a placeholder value: "$supabaseUrl". '
        'Please replace it with your actual Supabase project URL. '
        'For local development, use: --dart-define-from-file=env/dev.json',
      );
    }

    if (!_isValidUrl(supabaseUrl)) {
      throw StateError(
        'SUPABASE_URL is not a valid URL: $supabaseUrl',
      );
    }

    if (supabaseAnonKey.isEmpty) {
      throw StateError(
        'SUPABASE_ANON_KEY is required but not provided. '
        'Provide it via --dart-define=SUPABASE_ANON_KEY=... or use --dart-define-from-file=env/dev.json',
      );
    }

    // Check for placeholder values before format validation
    if (_isPlaceholder(supabaseAnonKey)) {
      throw StateError(
        'SUPABASE_ANON_KEY appears to be a placeholder value: "$supabaseAnonKey". '
        'Please replace it with your actual Supabase anon key (JWT token starting with "eyJ..."). '
        'For local development, use: --dart-define-from-file=env/dev.json',
      );
    }

    if (!_isValidJwt(supabaseAnonKey)) {
      throw StateError(
        'SUPABASE_ANON_KEY does not appear to be a valid JWT token. '
        'Expected format: eyJ... (received: ${supabaseAnonKey.length} characters). '
        'Please verify you are using the correct anon key from your Supabase project settings.',
      );
    }

    // Google Maps API key is optional (only needed for web)
    if (googleMapsApiKey.isNotEmpty) {
      // Check for placeholder values
      if (_isPlaceholder(googleMapsApiKey)) {
        throw StateError(
          'GOOGLE_MAPS_API_KEY appears to be a placeholder value: "$googleMapsApiKey". '
          'Please replace it with your actual Google Maps API key. '
          'For local development, use: --dart-define-from-file=env/dev.json',
        );
      }
      
      if (googleMapsApiKey.length < 20) {
        throw StateError(
          'GOOGLE_MAPS_API_KEY appears to be invalid (too short). '
          'Google Maps API keys are typically 39 characters long.',
        );
      }
    }
    
    // Validate API key format (Google API keys typically start with AIza)
    if (googleMapsApiKey.isNotEmpty && 
        !googleMapsApiKey.startsWith('AIza') && 
        !googleMapsApiKey.startsWith('GOCSPX')) {
      // GOCSPX is for OAuth client IDs, but some users might use it
      // AIza is the standard format for Google Maps API keys
      // We'll just warn, not throw, as the format might vary
    }
  }

  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  static bool _isValidJwt(String token) {
    // Basic JWT validation: should start with "eyJ" and have 3 parts separated by dots
    final parts = token.split('.');
    return parts.length == 3 && token.startsWith('eyJ');
  }

  /// Checks if a value appears to be a placeholder rather than a real value
  /// Detects common placeholder patterns like "your_key_here", "replace-with-...", etc.
  static bool _isPlaceholder(String value) {
    if (value.isEmpty) return false;
    
    final lowerValue = value.toLowerCase();
    
    // Common placeholder patterns
    final placeholderPatterns = [
      'your_key_here',
      'your-project',
      'replace-with',
      'placeholder',
      'example',
      'your-',
      'https://your-project',
    ];
    
    // Check if value matches any placeholder pattern
    for (final pattern in placeholderPatterns) {
      if (lowerValue.contains(pattern)) {
        return true;
      }
    }
    
    // Check for values that are clearly placeholders (too short or generic)
    if (value.length < 10 && (lowerValue.contains('key') || lowerValue.contains('token'))) {
      return true;
    }
    
    return false;
  }

  /// Validates Google Maps API key and returns a user-friendly error message if invalid
  /// Returns null if valid, or an error message string if invalid
  static String? validateGoogleMapsApiKey() {
    if (googleMapsApiKey.isEmpty) {
      return 'Google Maps API key is not configured. '
          'Please set GOOGLE_MAPS_API_KEY environment variable.';
    }

    if (googleMapsApiKey.length < 20) {
      return 'Google Maps API key appears to be invalid (too short: ${googleMapsApiKey.length} characters). '
          'Google Maps API keys are typically 39 characters long.';
    }

    if (!googleMapsApiKey.startsWith('AIza') && !googleMapsApiKey.startsWith('GOCSPX')) {
      return 'Google Maps API key format may be invalid. '
          'Expected to start with "AIza" (standard API key) or "GOCSPX" (OAuth client ID).';
    }

    return null; // Valid
  }

  /// Checks if Google Maps API key is available and valid
  static bool get isGoogleMapsApiKeyValid => validateGoogleMapsApiKey() == null;

  /// Validates environment variables at runtime and logs status
  /// This is useful for debugging production issues
  /// In production, also logs to console for debugging
  static void logEnvStatus() {
    final urlStatus = supabaseUrl.isNotEmpty ? "✓ Set (${supabaseUrl.length} chars)" : "✗ Missing";
    final keyStatus = supabaseAnonKey.isNotEmpty ? "✓ Set (${supabaseAnonKey.length} chars)" : "✗ Missing";
    final mapsKeyStatus = googleMapsApiKey.isNotEmpty ? "✓ Set (${googleMapsApiKey.length} chars)" : "✗ Missing";
    
    if (kDebugMode) {
      developer.log(
        'Environment Variables Status:',
        name: 'Env',
      );
      developer.log(
        'SUPABASE_URL: $urlStatus',
        name: 'Env',
      );
      developer.log(
        'SUPABASE_ANON_KEY: $keyStatus',
        name: 'Env',
      );
      developer.log(
        'GOOGLE_MAPS_API_KEY: $mapsKeyStatus',
        name: 'Env',
      );
    }
    
    // On non-web, console logging is not available
    // Logging is done via developer.log only
  }

  /// Runtime validation that throws user-friendly errors
  /// Call this after app initialization to verify env vars are loaded
  static void validateRuntime() {
    final errors = <String>[];
    
    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL is missing');
    }
    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY is missing');
    }
    
    if (errors.isNotEmpty) {
      final errorMessage = 'Environment variables missing: ${errors.join(", ")}. '
          'The app may not have been built with production environment variables. '
          'Ensure you build with: flutter build web --release --dart-define-from-file=env/prod.json --base-href=/';
      
      // On non-web, console logging is not available
      // Error is thrown directly
      
      throw StateError(errorMessage);
    }
  }
  
  /// Verifies that environment variables are present and logs status
  /// Returns true if all required vars are present, false otherwise
  static bool verifyEnvVars() {
    final hasUrl = supabaseUrl.isNotEmpty;
    final hasKey = supabaseAnonKey.isNotEmpty;
    final hasMapsKey = googleMapsApiKey.isNotEmpty;
    
    // On non-web, console logging is not available
    // Verification is done via developer.log only
    
    return hasUrl && hasKey;
  }
}

