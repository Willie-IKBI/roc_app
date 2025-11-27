import '../value_objects/role_type.dart';

class Profile {
  const Profile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.tenantId,
  });

  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final bool isActive;
  final String tenantId;

  RoleType get roleType => RoleType.fromJson(role);

  Profile copyWith({
    String? fullName,
    String? phone,
    bool? isActive,
    String? role,
    String? tenantId,
  }) {
    return Profile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}

