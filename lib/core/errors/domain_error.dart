sealed class DomainError {
  const DomainError();

  String get message;
}

class NetworkError extends DomainError {
  const NetworkError([this.cause]);

  final Object? cause;

  @override
  String get message => 'Network request failed';
}

class AuthError extends DomainError {
  const AuthError({required this.code, this.detail});

  final String code;
  final String? detail;

  @override
  String get message => detail ?? 'Authentication failed ($code)';
}

class PermissionDeniedError extends DomainError {
  const PermissionDeniedError([this.detail]);

  final String? detail;

  @override
  String get message => detail ?? 'You do not have permission to perform this action';
}

class NotFoundError extends DomainError {
  const NotFoundError([this.resource]);

  final String? resource;

  @override
  String get message => resource == null
      ? 'Requested resource not found'
      : '$resource not found';
}

class ValidationError extends DomainError {
  const ValidationError(this.detail);

  final String detail;

  @override
  String get message => detail;
}

class UnknownError extends DomainError {
  const UnknownError([this.cause]);

  final Object? cause;

  @override
  String get message => 'Unexpected error occurred';
}

/// Converts any error object to a user-friendly error message.
/// 
/// This function prevents leaking internal error details to end users.
/// In debug mode, it may include more details, but in production it
/// always returns safe, user-friendly messages.
String getUserFriendlyErrorMessage(Object error, {bool isDebugMode = false}) {
  // If it's already a DomainError, use its message
  if (error is DomainError) {
    return error.message;
  }
  
  // In debug mode, we can show more details for development
  if (isDebugMode) {
    final errorStr = error.toString();
    // Check for common error patterns and provide helpful messages
    if (errorStr.contains('Network') || errorStr.contains('connection')) {
      return 'Network error: Unable to connect to the server. Please check your internet connection.';
    }
    if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (errorStr.contains('permission') || errorStr.contains('denied')) {
      return 'You do not have permission to perform this action.';
    }
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'The requested resource was not found.';
    }
    // For debug mode, return the error string but sanitized
    return 'Error: ${errorStr.length > 200 ? errorStr.substring(0, 200) + "..." : errorStr}';
  }
  
  // In production, return generic user-friendly messages
  final errorStr = error.toString().toLowerCase();
  if (errorStr.contains('network') || errorStr.contains('connection') || errorStr.contains('socket')) {
    return 'Unable to connect to the server. Please check your internet connection and try again.';
  }
  if (errorStr.contains('timeout')) {
    return 'The request took too long. Please try again.';
  }
  if (errorStr.contains('permission') || errorStr.contains('denied') || errorStr.contains('unauthorized')) {
    return 'You do not have permission to perform this action.';
  }
  if (errorStr.contains('not found') || errorStr.contains('404')) {
    return 'The requested resource was not found.';
  }
  if (errorStr.contains('validation') || errorStr.contains('invalid')) {
    return 'Invalid input. Please check your data and try again.';
  }
  
  // Default safe message for production
  return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
}

