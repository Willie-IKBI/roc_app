import 'package:flutter/foundation.dart';

import '../errors/domain_error.dart';

@immutable
class Result<T> {
  const Result._(this._data, this._error);

  final T? _data;
  final DomainError? _error;

  const Result.ok(T data) : this._(data, null);

  const Result.err(DomainError error) : this._(null, error);

  bool get isOk => _error == null;
  bool get isErr => _error != null;

  T get data {
    if (isErr) {
      throw StateError('Tried to access data on an error Result');
    }
    return _data as T;
  }

  DomainError get error {
    if (_error == null) {
      throw StateError('Tried to access error on an ok Result');
    }
    return _error;
  }

  R fold<R>(R Function(T data) onData, R Function(DomainError error) onError) {
    if (isOk) {
      return onData(data);
    }
    return onError(error);
  }

  Result<R> map<R>(R Function(T data) transform) {
    if (isErr) {
      return Result.err(error);
    }
    return Result.ok(transform(data));
  }

  static Future<Result<T>> guard<T>(Future<T> Function() run) async {
    try {
      final value = await run();
      return Result.ok(value);
    } catch (err) {
      return Result.err(UnknownError(err));
    }
  }
}

