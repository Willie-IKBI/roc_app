enum ContactMethod {
  phone('phone', 'Phone call'),
  sms('sms', 'SMS'),
  whatsapp('whatsapp', 'WhatsApp');

  const ContactMethod(this.value, this.label);

  final String value;
  final String label;

  static ContactMethod fromJson(String raw) {
    return ContactMethod.values.firstWhere(
      (method) => method.value == raw,
      orElse: () => ContactMethod.phone,
    );
  }
}

extension ContactMethodX on ContactMethod {
  String toJson() => value;
}
