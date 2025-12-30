// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressRow _$AddressRowFromJson(Map<String, dynamic> json) => AddressRow(
  id: json['id'] as String,
  tenantId: json['tenant_id'] as String,
  clientId: json['client_id'] as String,
  estateId: json['estate_id'] as String?,
  estate: json['estate'] == null
      ? null
      : EstateRow.fromJson(json['estate'] as Map<String, dynamic>),
  complexOrEstate: json['complex_or_estate'] as String?,
  unitNumber: json['unit_number'] as String?,
  street: json['street'] as String,
  suburb: json['suburb'] as String,
  postalCode: json['postal_code'] as String,
  city: json['city'] as String?,
  province: json['province'] as String?,
  country: json['country'] as String? ?? 'South Africa',
  latitude: (json['lat'] as num?)?.toDouble(),
  longitude: (json['lng'] as num?)?.toDouble(),
  googlePlaceId: json['google_place_id'] as String?,
  notes: json['notes'] as String?,
  isPrimary: json['is_primary'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AddressRowToJson(AddressRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'client_id': instance.clientId,
      'estate_id': instance.estateId,
      'estate': instance.estate,
      'complex_or_estate': instance.complexOrEstate,
      'unit_number': instance.unitNumber,
      'street': instance.street,
      'suburb': instance.suburb,
      'postal_code': instance.postalCode,
      'city': instance.city,
      'province': instance.province,
      'country': instance.country,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'google_place_id': instance.googlePlaceId,
      'notes': instance.notes,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
