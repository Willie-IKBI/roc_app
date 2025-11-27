enum RoleType {
  admin('admin'),
  claimAgent('claim_agent');

  const RoleType(this.value);

  final String value;

  static RoleType fromJson(String raw) {
    return RoleType.values.firstWhere(
      (role) => role.value == raw,
      orElse: () => RoleType.claimAgent,
    );
  }

  String get label {
    switch (this) {
      case RoleType.admin:
        return 'Admin';
      case RoleType.claimAgent:
        return 'Claim agent';
    }
  }
}

