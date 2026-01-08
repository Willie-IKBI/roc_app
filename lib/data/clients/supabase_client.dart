import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, Supabase, SupabaseClient, AuthException;

import '../../core/errors/domain_error.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final client = Supabase.instance.client;
  return client;
});

/// Attempts to refresh the session with retry logic
/// Returns true if refresh succeeded, false otherwise
Future<bool> refreshSessionWithRetry(
  SupabaseClient client, {
  int maxRetries = 3,
  Duration retryDelay = const Duration(seconds: 2),
}) async {
  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      final session = client.auth.currentSession;
      if (session == null) {
        developer.log(
          'No session to refresh',
          name: 'SessionRefresh',
        );
        return false;
      }

      // Check if session is expired
      final expiresAt = session.expiresAt;
      if (expiresAt != null) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (expiresAt > now) {
          developer.log(
            'Session still valid, expires in ${expiresAt - now} seconds',
            name: 'SessionRefresh',
          );
          return true;
        }
      }

      // Attempt to refresh
      developer.log(
        'Attempting to refresh session (attempt $attempt/$maxRetries)',
        name: 'SessionRefresh',
      );
      
      final response = await client.auth.refreshSession();
      
      if (response.session != null) {
        developer.log(
          'Session refreshed successfully',
          name: 'SessionRefresh',
        );
        return true;
      }
      
      developer.log(
        'Session refresh returned null session',
        name: 'SessionRefresh',
      );
      
      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      }
    } on AuthException catch (e) {
      developer.log(
        'Session refresh failed (attempt $attempt/$maxRetries): ${e.message}',
        name: 'SessionRefresh',
        error: e,
      );
      
      // Don't retry on certain errors
      if (e.message.contains('refresh_token_not_found') ||
          e.message.contains('invalid_grant')) {
        developer.log(
          'Refresh token invalid, cannot retry',
          name: 'SessionRefresh',
        );
        return false;
      }
      
      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      }
    } catch (e, stack) {
      developer.log(
        'Unexpected error during session refresh (attempt $attempt/$maxRetries): $e',
        name: 'SessionRefresh',
        error: e,
        stackTrace: stack,
      );
      
      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      }
    }
  }
  
  developer.log(
    'Session refresh failed after $maxRetries attempts',
    name: 'SessionRefresh',
  );
  return false;
}

/// Sets up proactive token refresh to prevent users from being logged out.
/// Checks every 5 minutes and refreshes tokens before they expire.
/// 
/// Refreshes tokens when they have less than 10 minutes remaining (600 seconds),
/// providing a buffer before expiry. Works with any JWT expiry time.
Timer? setupProactiveTokenRefresh(SupabaseClient client) {
  Timer? refreshTimer;
  
  refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
    try {
      final session = client.auth.currentSession;
      if (session == null) {
        // No session, stop checking
        developer.log(
          'No active session for proactive refresh',
          name: 'ProactiveRefresh',
        );
        return;
      }
      
      final expiresAt = session.expiresAt;
      if (expiresAt == null) {
        developer.log(
          'Session has no expiry time',
          name: 'ProactiveRefresh',
        );
        return;
      }
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final timeUntilExpiry = expiresAt - now;
      
      // Refresh if token expires in less than 10 minutes (600 seconds)
      // This gives us a 10-minute buffer before the 1-hour expiry
      if (timeUntilExpiry < 600 && timeUntilExpiry > 0) {
        developer.log(
          'Proactively refreshing token (expires in ${timeUntilExpiry}s)',
          name: 'ProactiveRefresh',
        );
        
        try {
          final response = await client.auth.refreshSession();
          if (response.session != null) {
            developer.log(
              'Proactive refresh successful. New expiry: ${response.session!.expiresAt}',
              name: 'ProactiveRefresh',
            );
          } else {
            developer.log(
              'Proactive refresh returned null session',
              name: 'ProactiveRefresh',
            );
          }
        } on AuthException catch (e) {
          developer.log(
            'Proactive refresh failed: ${e.message}',
            name: 'ProactiveRefresh',
            error: e,
          );
          
          // If refresh token is invalid, stop trying
          if (e.message.contains('refresh_token_not_found') ||
              e.message.contains('invalid_grant')) {
            developer.log(
              'Refresh token invalid, stopping proactive refresh',
              name: 'ProactiveRefresh',
            );
            timer.cancel();
          }
        } catch (e, stack) {
          developer.log(
            'Unexpected error during proactive refresh: $e',
            name: 'ProactiveRefresh',
            error: e,
            stackTrace: stack,
          );
        }
      } else if (timeUntilExpiry <= 0) {
        // Token already expired, try to refresh immediately
        developer.log(
          'Token already expired, attempting immediate refresh',
          name: 'ProactiveRefresh',
        );
        try {
          await refreshSessionWithRetry(client);
        } catch (e) {
          developer.log(
            'Failed to refresh expired token: $e',
            name: 'ProactiveRefresh',
            error: e,
          );
        }
      } else {
        // Token still has plenty of time, just log for debugging
        developer.log(
          'Token still valid for ${timeUntilExpiry}s (${(timeUntilExpiry / 60).toStringAsFixed(1)} minutes)',
          name: 'ProactiveRefresh',
        );
      }
    } catch (e, stack) {
      developer.log(
        'Error in proactive refresh check: $e',
        name: 'ProactiveRefresh',
        error: e,
        stackTrace: stack,
      );
    }
  });
  
  developer.log(
    'Proactive token refresh started (checks every 5 minutes)',
    name: 'ProactiveRefresh',
  );
  
  return refreshTimer;
}

/// Convenience helper for wrapping Supabase errors into [DomainError]s.
DomainError mapPostgrestException(PostgrestException exception) {
  final code = exception.code ?? '';
  if (code == '42501' || code == 'PGRST302') {
    return const PermissionDeniedError();
  }
  if (code == 'PGRST301' || code == 'PGRST304') {
    return AuthError(code: code, detail: exception.message);
  }
  if (code == 'PGRST103') {
    return NotFoundError(exception.message);
  }

  return UnknownError(exception);
}

