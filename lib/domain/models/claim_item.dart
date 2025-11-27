import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'claim_item.freezed.dart';

@freezed
abstract class ClaimItem with _$ClaimItem {
  const factory ClaimItem({
    required String id,
    required String claimId,
    required String brand,
    String? color,
    @Default(WarrantyStatus.unknown) WarrantyStatus warranty,
    String? serialOrModel,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ClaimItem;

  const ClaimItem._();
}

