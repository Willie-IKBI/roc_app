import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/address.dart';
import 'estate_row.dart';

part 'address_row.g.dart';

@JsonSerializable()
class AddressRow {
  AddressRow({
    required this.id,
    required this.tenantId,
    required this.clientId,
    this.estateId,
    this.estate,
    this.complexOrEstate,
    this.unitNumber,
    required this.street,
    required this.suburb,
    required this.postalCode,
    this.city,
    this.province,
    this.country = 'South Africa',
    this.latitude,
    this.longitude,
    this.googlePlaceId,
    this.notes,
    this.isPrimary = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressRow.fromJson(Map<String, dynamic> json) => _$AddressRowFromJson(json);

  Map<String, dynamic> toJson() => _$AddressRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'client_id')
  final String clientId;

  @JsonKey(name: 'estate_id')
  final String? estateId;

  final EstateRow? estate;

  @JsonKey(name: 'complex_or_estate')
  final String? complexOrEstate;

  @JsonKey(name: 'unit_number')
  final String? unitNumber;

  final String street;

  final String suburb;

  @JsonKey(name: 'postal_code')
  final String postalCode;

  final String? city;

  final String? province;

  final String? country;

  final double? latitude;

  final double? longitude;

  @JsonKey(name: 'google_place_id')
  final String? googlePlaceId;

  final String? notes;

  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Address toDomain() => Address(
        id: id,
        tenantId: tenantId,
        clientId: clientId,
        estateId: estateId,
        estate: estate?.toDomain(),
        complexOrEstate: complexOrEstate,
        unitNumber: unitNumber,
        street: street,
        suburb: suburb,
        postalCode: postalCode,
        city: city,
        province: province,
        country: country ?? 'South Africa',
        latitude: latitude,
        longitude: longitude,
        googlePlaceId: googlePlaceId,
        notes: notes,
        isPrimary: isPrimary,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

