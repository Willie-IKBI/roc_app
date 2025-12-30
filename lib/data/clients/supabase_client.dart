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

