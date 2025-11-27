import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/service_provider.dart';

part 'service_provider_row.g.dart';

@JsonSerializable()
class ServiceProviderRow {
  ServiceProviderRow({
    required this.id,
    required this.tenantId,
    required this.companyName,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.referenceNumberFormat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceProviderRow.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderRowFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'company_name')
  final String companyName;

  @JsonKey(name: 'contact_name')
  final String? contactName;

  @JsonKey(name: 'contact_phone')
  final String? contactPhone;

  @JsonKey(name: 'contact_email')
  final String? contactEmail;

  @JsonKey(name: 'reference_number_format')
  final String? referenceNumberFormat;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ServiceProvider toDomain() {
    return ServiceProvider(
      id: id,
      tenantId: tenantId,
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      referenceNumberFormat: referenceNumberFormat,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}


