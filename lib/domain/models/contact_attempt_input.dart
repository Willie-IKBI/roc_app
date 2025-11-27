import '../value_objects/contact_method.dart';
import '../value_objects/claim_enums.dart';

class ContactAttemptInput {
  const ContactAttemptInput({
    required this.method,
    required this.outcome,
    this.notes,
    this.sendSmsTemplate = false,
    this.smsTemplateId,
  });

  final ContactMethod method;
  final ContactOutcome outcome;
  final String? notes;
  final bool sendSmsTemplate;
  final String? smsTemplateId;
}
