import 'package:json_annotation/json_annotation.dart';

part 'brand.g.dart';

@JsonSerializable()
class Brand {
  const Brand({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);

  final String id;
  final String tenantId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Brand copyWith({String? name}) {
    return Brand(
      id: id,
      tenantId: tenantId,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
