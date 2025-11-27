import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/claim_status_change.dart';
import '../../domain/value_objects/claim_enums.dart';

part 'claim_status_history_row.g.dart';

@JsonSerializable()
class ClaimStatusHistoryRow {
  ClaimStatusHistoryRow({
    required this.id,
    required this.tenantId,
    required this.claimId,
    required this.fromStatus,
    required this.toStatus,
    this.changedBy,
    required this.changedAt,
    this.reason,
  });

  factory ClaimStatusHistoryRow.fromJson(Map<String, dynamic> json) => _$ClaimStatusHistoryRowFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimStatusHistoryRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'claim_id')
  final String claimId;

  @JsonKey(name: 'from_status')
  final String fromStatus;

  @JsonKey(name: 'to_status')
  final String toStatus;

  @JsonKey(name: 'changed_by')
  final String? changedBy;

  @JsonKey(name: 'changed_at')
  final DateTime changedAt;

  final String? reason;

  ClaimStatusChange toDomain() => ClaimStatusChange(
        id: id,
        tenantId: tenantId,
        claimId: claimId,
        fromStatus: ClaimStatus.fromJson(fromStatus),
        toStatus: ClaimStatus.fromJson(toStatus),
        changedBy: changedBy,
        changedAt: changedAt,
        reason: reason,
      );
}

