import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';

@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,
    required String tenantId,
    required String firstName,
    required String lastName,
    required String primaryPhone,
    String? altPhone,
    String? email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Client;

  const Client._();

  String get fullName => '$firstName $lastName'.trim();
}

