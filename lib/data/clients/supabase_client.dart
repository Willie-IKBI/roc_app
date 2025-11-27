import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, Supabase, SupabaseClient;

import '../../core/errors/domain_error.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final client = Supabase.instance.client;
  return client;
});

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

