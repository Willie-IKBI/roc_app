class Validators {
  Validators._();

  /// Validates claim number - require at least 3 alphanumeric / separators.
  static String? validateClaimNumber(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Claim number is required';
    }
    if (trimmed.length < 3) {
      return 'Claim number is too short';
    }
    final regex = RegExp(r'^[a-zA-Z0-9\-/]+$');
    if (!regex.hasMatch(trimmed)) {
      return 'Use letters, numbers, slashes or hyphens only';
    }
    return null;
  }

  /// South African phone validation (+27 or 0 followed by 9 digits).
  static String? validateSouthAfricanPhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Phone number is required';
    }
    final regex = RegExp(r'^(?:\+27|0)[1-9]\d{8}$');
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid South African number (e.g. 0821234567 or +27821234567)';
    }
    return null;
  }

  static String? validateOptionalSouthAfricanPhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return validateSouthAfricanPhone(trimmed);
  }

  static String? validateOptionalEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}

