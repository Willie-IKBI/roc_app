import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/client.dart';

part 'client_row.g.dart';

@JsonSerializable()
class ClientRow {
  ClientRow({
    required this.id,
    required this.tenantId,
    required this.firstName,
    required this.lastName,
    required this.primaryPhone,
    this.altPhone,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientRow.fromJson(Map<String, dynamic> json) => _$ClientRowFromJson(json);

  Map<String, dynamic> toJson() => _$ClientRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'primary_phone')
  final String primaryPhone;

  @JsonKey(name: 'alt_phone')
  final String? altPhone;

  final String? email;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Client toDomain() => Client(
        id: id,
        tenantId: tenantId,
        firstName: firstName,
        lastName: lastName,
        primaryPhone: primaryPhone,
        altPhone: altPhone,
        email: email,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

