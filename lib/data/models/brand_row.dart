import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/brand.dart';

part 'brand_row.g.dart';

@JsonSerializable()
class BrandRow {
  BrandRow({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandRow.fromJson(Map<String, dynamic> json) =>
      _$BrandRowFromJson(json);

  Map<String, dynamic> toJson() => _$BrandRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  final String name;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Brand toDomain() => Brand(
    id: id,
    tenantId: tenantId,
    name: name,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
