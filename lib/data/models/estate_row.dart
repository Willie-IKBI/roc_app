import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/estate.dart';

part 'estate_row.g.dart';

@JsonSerializable()
class EstateRow {
  EstateRow({
    required this.id,
    required this.tenantId,
    required this.name,
    this.suburb,
    this.city,
    this.province,
    this.postalCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EstateRow.fromJson(Map<String, dynamic> json) =>
      _$EstateRowFromJson(json);

  Map<String, dynamic> toJson() => _$EstateRowToJson(this);

  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final String name;

  final String? suburb;

  final String? city;

  final String? province;

  @JsonKey(name: 'postal_code')
  final String? postalCode;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Estate toDomain() => Estate(
        id: id,
        tenantId: tenantId,
        name: name,
        suburb: suburb,
        city: city,
        province: province,
        postalCode: postalCode,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

