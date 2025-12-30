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
        'Provide it via --dart-define=SUPABASE_URL=...',
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
        'Provide it via --dart-define=SUPABASE_ANON_KEY=...',
      );
    }

    if (!_isValidJwt(supabaseAnonKey)) {
      throw StateError(
        'SUPABASE_ANON_KEY does not appear to be a valid JWT token. '
        'Expected format: eyJ...',
      );
    }

    // Google Maps API key is optional (only needed for web)
    if (googleMapsApiKey.isNotEmpty && googleMapsApiKey.length < 20) {
      throw StateError(
        'GOOGLE_MAPS_API_KEY appears to be invalid (too short). '
        'Google Maps API keys are typically 39 characters long.',
      );
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
}

