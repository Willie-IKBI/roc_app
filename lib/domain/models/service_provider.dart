import 'package:json_annotation/json_annotation.dart';

part 'service_provider.g.dart';

@JsonSerializable()
class ServiceProvider {
  const ServiceProvider({
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

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);

  final String id;
  final String tenantId;
  final String companyName;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? referenceNumberFormat;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceProvider copyWith({
    String? companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? referenceNumberFormat,
  }) {
    return ServiceProvider(
      id: id,
      tenantId: tenantId,
      companyName: companyName ?? this.companyName,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      referenceNumberFormat:
          referenceNumberFormat ?? this.referenceNumberFormat,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

