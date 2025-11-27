enum ClaimStatus {
  newClaim('new'),
  inContact('in_contact'),
  awaitingClient('awaiting_client'),
  scheduled('scheduled'),
  workInProgress('work_in_progress'),
  onHold('on_hold'),
  closed('closed'),
  cancelled('cancelled');

  const ClaimStatus(this.value);

  final String value;

  static ClaimStatus fromJson(String raw) => ClaimStatus.values.firstWhere(
        (status) => status.value == raw,
        orElse: () => ClaimStatus.newClaim,
      );
}

enum ContactOutcome {
  answered('answered'),
  noAnswer('no_answer'),
  badNumber('bad_number'),
  leftVoicemail('left_voicemail'),
  smsSent('sms_sent'),
  callBackRequested('call_back_requested');

  const ContactOutcome(this.value);

  final String value;

  static ContactOutcome fromJson(String raw) => ContactOutcome.values.firstWhere(
        (outcome) => outcome.value == raw,
        orElse: () => ContactOutcome.answered,
      );
}

enum DamageCause {
  powerSurge('power_surge'),
  lightningDamage('lightning_damage'),
  liquidDamage('liquid_damage'),
  electricalBreakdown('electrical_breakdown'),
  mechanicalBreakdown('mechanical_breakdown'),
  theft('theft'),
  fire('fire'),
  accidentalImpactDamage('accidental_impact_damage'),
  stormDamage('storm_damage'),
  wearAndTear('wear_and_tear'),
  oldAge('old_age'),
  negligence('negligence'),
  resultantDamage('resultant_damage'),
  other('other');

  const DamageCause(this.value);

  final String value;

  static DamageCause fromJson(String raw) => DamageCause.values.firstWhere(
        (cause) => cause.value == raw,
        orElse: () => DamageCause.other,
      );
}

enum WarrantyStatus {
  inWarranty('in_warranty'),
  outOfWarranty('out_of_warranty'),
  unknown('unknown');

  const WarrantyStatus(this.value);

  final String value;

  static WarrantyStatus fromJson(String raw) => WarrantyStatus.values.firstWhere(
        (status) => status.value == raw,
        orElse: () => WarrantyStatus.unknown,
      );
}

enum PriorityLevel {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent');

  const PriorityLevel(this.value);

  final String value;

  static PriorityLevel fromJson(String raw) => PriorityLevel.values.firstWhere(
        (level) => level.value == raw,
        orElse: () => PriorityLevel.normal,
      );
}

