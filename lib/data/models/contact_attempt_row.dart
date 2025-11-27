import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/contact_attempt.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../../domain/value_objects/contact_method.dart';

part 'contact_attempt_row.g.dart';

@JsonSerializable()
class ContactAttemptRow {
  ContactAttemptRow({
    required this.id,
    required this.tenantId,
    required this.claimId,
    required this.attemptedBy,
    required this.attemptedAt,
    required this.method,
    required this.outcome,
    this.notes,
  });

  factory ContactAttemptRow.fromJson(Map<String, dynamic> json) =>
      _$ContactAttemptRowFromJson(json);

  Map<String, dynamic> toJson() => _$ContactAttemptRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'claim_id')
  final String claimId;

  @JsonKey(name: 'attempted_by')
  final String attemptedBy;

  @JsonKey(name: 'attempted_at')
  final DateTime attemptedAt;

  final String method;

  final String outcome;

  final String? notes;

  ContactAttempt toDomain() => ContactAttempt(
        id: id,
        tenantId: tenantId,
        claimId: claimId,
        attemptedBy: attemptedBy,
        attemptedAt: attemptedAt,
        method: ContactMethod.fromJson(method),
        outcome: ContactOutcome.fromJson(outcome),
        notes: notes,
      );
}

