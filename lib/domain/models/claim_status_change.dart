import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'claim_status_change.freezed.dart';

@freezed
abstract class ClaimStatusChange with _$ClaimStatusChange {
  const factory ClaimStatusChange({
    required String id,
    required String tenantId,
    required String claimId,
    required ClaimStatus fromStatus,
    required ClaimStatus toStatus,
    String? changedBy,
    required DateTime changedAt,
    String? reason,
  }) = _ClaimStatusChange;

  const ClaimStatusChange._();
}

