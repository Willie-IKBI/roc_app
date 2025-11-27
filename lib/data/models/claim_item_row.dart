import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/claim_item.dart';
import '../../domain/value_objects/claim_enums.dart';

part 'claim_item_row.g.dart';

@JsonSerializable()
class ClaimItemRow {
  ClaimItemRow({
    required this.id,
    required this.tenantId,
    required this.claimId,
    required this.brand,
    this.color,
    required this.warranty,
    this.serialOrModel,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClaimItemRow.fromJson(Map<String, dynamic> json) => _$ClaimItemRowFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimItemRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'claim_id')
  final String claimId;

  final String brand;

  final String? color;

  final String warranty;

  @JsonKey(name: 'serial_or_model')
  final String? serialOrModel;

  final String? notes;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ClaimItem toDomain() => ClaimItem(
        id: id,
        claimId: claimId,
        brand: brand,
        color: color,
        warranty: WarrantyStatus.fromJson(warranty),
        serialOrModel: serialOrModel,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

