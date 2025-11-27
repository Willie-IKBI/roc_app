import 'package:freezed_annotation/freezed_annotation.dart';

import 'estate.dart';

part 'address.freezed.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required String tenantId,
    required String clientId,
    String? estateId,
    Estate? estate,
    String? complexOrEstate,
    String? unitNumber,
    required String street,
    required String suburb,
    required String postalCode,
    String? city,
    String? province,
    @Default('South Africa') String country,
    double? latitude,
    double? longitude,
    String? googlePlaceId,
    String? notes,
    @Default(true) bool isPrimary,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Address;

  const Address._();
}

