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

