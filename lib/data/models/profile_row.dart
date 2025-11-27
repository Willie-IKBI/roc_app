import '../../domain/models/user_account.dart';
import '../../domain/value_objects/role_type.dart';

class ProfileRow {
  const ProfileRow({
    required this.id,
    required this.tenantId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileRow.fromJson(Map<String, dynamic> json) {
    return ProfileRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      fullName: (json['full_name'] as String?)?.trim() ?? '',
      phone: (json['phone'] as String?)?.trim(),
      email: (json['email'] as String?)?.trim() ?? '',
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String tenantId;
  final String fullName;
  final String? phone;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAccount toDomain() {
    return UserAccount(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      role: RoleType.fromJson(role),
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

