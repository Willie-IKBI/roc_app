import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/env.dart';
import 'core/logging/logger.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme_mode_provider.dart';
import 'core/theme/theme_preference_provider.dart';
import 'core/utils/web_console.dart';
import 'core/widgets/glass_error_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handlers to prevent white screen crashes
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log the error
    AppLogger.error(
      'Flutter error: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
      name: 'FlutterError',
    );
    
    // In debug mode, show the default error screen
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
    
    // In production, we rely on ErrorWidget.builder to show user-friendly errors
  };

  // Set up error widget builder to show user-friendly error UI instead of white screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Always log errors to console, even in production
    if (kIsWeb) {
      WebConsole.error(
        'Flutter Error Widget: ${details.exception}\n${details.stack?.toString() ?? 'No stack trace'}',
      );
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GlassErrorState(
          title: 'Something went wrong',
          message: kDebugMode 
              ? details.exception.toString()
              : 'An unexpected error occurred. Please try refreshing the page.',
          icon: Icons.error_outline,
          onRetry: () {
            // Reload the page in web
            if (kIsWeb) {
              WebConsole.reload();
            }
          },
        ),
      ),
    );
  };

  // Handle platform errors (async errors outside Flutter)
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Platform error: $error',
      error: error,
      stackTrace: stack,
      name: 'PlatformError',
    );
    
    // Also log to browser console in production for debugging
    if (kIsWeb) {
      WebConsole.error(
        'Platform Error: $error\n${stack.toString()}',
      );
    }
    
    return true; // Handled
  };

  try {
    // CRITICAL: Log diagnostic info immediately for debugging deployment issues
    if (kIsWeb) {
      html.window.console.log('[AppInit] Starting application initialization...');
      html.window.console.log('[AppInit] Current URL: ${html.window.location.href}');
      html.window.console.log('[AppInit] Hostname: ${html.window.location.hostname}');
      
      // Check if diagnostic info is available
      try {
        final diagnostic = (html.window as dynamic).rocEnvDiagnostic;
        if (diagnostic != null) {
          html.window.console.log('[AppInit] Diagnostic info available from pre-load script');
        }
      } catch (_) {
        // Ignore if diagnostic not available
      }
    }
    
    // Verify environment variables are present (logs to console even in production)
    if (!Env.verifyEnvVars()) {
      final missingVars = <String>[];
      if (Env.supabaseUrl.isEmpty) missingVars.add('SUPABASE_URL');
      if (Env.supabaseAnonKey.isEmpty) missingVars.add('SUPABASE_ANON_KEY');
      if (Env.googleMapsApiKey.isEmpty) missingVars.add('GOOGLE_MAPS_API_KEY');
      
      final errorMsg = 'Required environment variables are missing: ${missingVars.join(", ")}. '
          'This usually means the app was not built with --dart-define-from-file=env/prod.json. '
          'Check browser console for details.';
      
      if (kIsWeb) {
        html.window.console.error('[AppInit] $errorMsg');
        html.window.console.error('[AppInit] Build command should be: flutter build web --release --dart-define-from-file=env/prod.json --base-href=/');
        html.window.console.error('[AppInit] Verify env/prod.json exists and contains all required variables');
      }
      
      throw StateError(errorMsg);
    }
    
    // Validate environment variables before initializing Supabase
    Env.validate();
    
    // Log environment variable status for debugging (logs to console in production too)
    Env.logEnvStatus();
    
    // Runtime validation to catch missing env vars in production
    Env.validateRuntime();

    final supabaseUrl = Env.supabaseUrl;
    final supabaseAnonKey = Env.supabaseAnonKey;
    
    // Additional validation before Supabase initialization
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Supabase credentials are missing. SUPABASE_URL: ${supabaseUrl.isEmpty ? "MISSING" : "OK"}, '
        'SUPABASE_ANON_KEY: ${supabaseAnonKey.isEmpty ? "MISSING" : "OK"}',
      );
    }

    // Initialize Supabase with error handling
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
        authOptions: const FlutterAuthClientOptions(
          // Enable automatic token refresh
          autoRefreshToken: true,
        ),
      );
    } catch (supabaseError, supabaseStack) {
      AppLogger.error(
        'Supabase initialization failed: $supabaseError',
        name: 'AppInit',
        error: supabaseError,
        stackTrace: supabaseStack,
      );
      
      // Log to console for debugging
      if (kIsWeb) {
        html.window.console.error(
          'Supabase initialization failed: $supabaseError\n${supabaseStack.toString()}',
        );
      }
      
      rethrow;
    }

    runApp(const ProviderScope(child: RocApp()));
  } catch (error, stackTrace) {
    // If initialization fails, show error screen
    AppLogger.error(
      'App initialization failed: $error',
      error: error,
      stackTrace: stackTrace,
      name: 'AppInit',
    );
    
    // Provide more specific error message for env var issues
    String userMessage = 'Failed to initialize the application. Please check your configuration.';
    if (error is StateError) {
      final errorStr = error.toString();
      if (errorStr.contains('environment variable') || 
          errorStr.contains('SUPABASE_URL') || 
          errorStr.contains('SUPABASE_ANON_KEY') ||
          errorStr.contains('placeholder') ||
          errorStr.contains('Configuration Error')) {
        
        // Detect if this is a placeholder value error
        final isPlaceholderError = errorStr.contains('placeholder');
        
        // Provide context-appropriate guidance based on build mode
        if (kDebugMode) {
          // Local development guidance
          userMessage = 'Configuration Error: Environment variables are missing or invalid.\n\n';
          
          if (isPlaceholderError) {
            userMessage += 'You are using placeholder values instead of real credentials.\n\n';
          }
          
          userMessage += 'For local development, use:\n'
              'flutter run -d chrome --dart-define-from-file=env/dev.json\n\n'
              'Make sure:\n'
              '1. The file env/dev.json exists\n'
              '2. It contains your actual Supabase credentials (not placeholders)\n'
              '3. See README.md for setup instructions\n\n'
              'Check the browser console (F12) for detailed error messages.';
        } else {
          // Production build guidance
          userMessage = 'Configuration Error: Environment variables are missing or invalid.\n\n';
          
          if (isPlaceholderError) {
            userMessage += 'Placeholder values were detected in the build.\n\n';
          }
          
          userMessage += 'This usually means the app was not built with production environment variables.\n\n'
              'Please check:\n'
              '1. The build command included: --dart-define-from-file=env/prod.json\n'
              '2. The file env/prod.json exists and contains all required variables (not placeholders)\n'
              '3. Check the browser console (F12) for detailed error messages';
        }
        
        if (kIsWeb) {
          html.window.console.error('[AppInit] Environment variable error detected');
          html.window.console.error('[AppInit] Error details: $error');
          if (kDebugMode) {
            html.window.console.error('[AppInit] Running in DEBUG mode - use: flutter run -d chrome --dart-define-from-file=env/dev.json');
          } else {
            html.window.console.error('[AppInit] Running in RELEASE mode - use: flutter build web --release --dart-define-from-file=env/prod.json --base-href=/');
          }
        }
      } else {
        userMessage = kDebugMode ? error.toString() : userMessage;
      }
    } else {
      userMessage = kDebugMode ? error.toString() : userMessage;
    }
    
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: GlassErrorState(
            title: 'Initialization Error',
            message: userMessage,
            icon: Icons.error_outline,
            onRetry: () {
              // Reload the page in web
              if (kIsWeb) {
                html.window.location.reload();
              }
            },
          ),
        ),
      ),
    );
  }
}

class RocApp extends ConsumerWidget {
  const RocApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themePreference = ref.watch(themePreferenceProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp.router(
      title: 'Repair on Call',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themePreference.when(
        data: (mode) => mode,
        loading: () => ThemeMode.dark,
        error: (_, __) => ThemeMode.dark,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
