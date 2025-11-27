import '../../domain/models/insurer.dart';

class InsurerRow {
  const InsurerRow({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.contactPhone,
    required this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InsurerRow.fromJson(Map<String, dynamic> json) {
    return InsurerRow(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      name: (json['name'] as String).trim(),
      contactPhone: (json['contact_phone'] as String? ?? '').trim().isEmpty
          ? null
          : (json['contact_phone'] as String).trim(),
      contactEmail: (json['contact_email'] as String? ?? '').trim().isEmpty
          ? null
          : (json['contact_email'] as String).trim(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String tenantId;
  final String name;
  final String? contactPhone;
  final String? contactEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  Insurer toDomain() => Insurer(
        id: id,
        tenantId: tenantId,
        name: name,
        contactPhone: contactPhone,
        contactEmail: contactEmail,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

