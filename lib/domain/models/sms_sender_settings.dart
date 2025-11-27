class SmsSenderSettings {
  const SmsSenderSettings({
    required this.senderName,
    required this.senderNumber,
  });

  final String? senderName;
  final String? senderNumber;

  bool get isConfigured =>
      (senderName != null && senderName!.trim().isNotEmpty) ||
      (senderNumber != null && senderNumber!.trim().isNotEmpty);

  SmsSenderSettings copyWith({
    String? senderName,
    String? senderNumber,
  }) {
    return SmsSenderSettings(
      senderName: senderName ?? this.senderName,
      senderNumber: senderNumber ?? this.senderNumber,
    );
  }
}


