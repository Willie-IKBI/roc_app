import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';
import '../value_objects/contact_method.dart';

part 'contact_attempt.freezed.dart';

@freezed
abstract class ContactAttempt with _$ContactAttempt {
  const factory ContactAttempt({
    required String id,
    required String tenantId,
    required String claimId,
    required String attemptedBy,
    required DateTime attemptedAt,
    required ContactMethod method,
    required ContactOutcome outcome,
    String? notes,
  }) = _ContactAttempt;

  const ContactAttempt._();
}

