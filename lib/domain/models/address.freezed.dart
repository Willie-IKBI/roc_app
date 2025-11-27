// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Address {

 String get id; String get tenantId; String get clientId; String? get estateId; Estate? get estate; String? get complexOrEstate; String? get unitNumber; String get street; String get suburb; String get postalCode; String? get city; String? get province; String get country; double? get latitude; double? get longitude; String? get googlePlaceId; String? get notes; bool get isPrimary; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.estate, estate) || other.estate == estate)&&(identical(other.complexOrEstate, complexOrEstate) || other.complexOrEstate == complexOrEstate)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.street, street) || other.street == street)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,clientId,estateId,estate,complexOrEstate,unitNumber,street,suburb,postalCode,city,province,country,latitude,longitude,googlePlaceId,notes,isPrimary,createdAt,updatedAt]);

@override
String toString() {
  return 'Address(id: $id, tenantId: $tenantId, clientId: $clientId, estateId: $estateId, estate: $estate, complexOrEstate: $complexOrEstate, unitNumber: $unitNumber, street: $street, suburb: $suburb, postalCode: $postalCode, city: $city, province: $province, country: $country, latitude: $latitude, longitude: $longitude, googlePlaceId: $googlePlaceId, notes: $notes, isPrimary: $isPrimary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String clientId, String? estateId, Estate? estate, String? complexOrEstate, String? unitNumber, String street, String suburb, String postalCode, String? city, String? province, String country, double? latitude, double? longitude, String? googlePlaceId, String? notes, bool isPrimary, DateTime createdAt, DateTime updatedAt
});


$EstateCopyWith<$Res>? get estate;

}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? clientId = null,Object? estateId = freezed,Object? estate = freezed,Object? complexOrEstate = freezed,Object? unitNumber = freezed,Object? street = null,Object? suburb = null,Object? postalCode = null,Object? city = freezed,Object? province = freezed,Object? country = null,Object? latitude = freezed,Object? longitude = freezed,Object? googlePlaceId = freezed,Object? notes = freezed,Object? isPrimary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,estate: freezed == estate ? _self.estate : estate // ignore: cast_nullable_to_non_nullable
as Estate?,complexOrEstate: freezed == complexOrEstate ? _self.complexOrEstate : complexOrEstate // ignore: cast_nullable_to_non_nullable
as String?,unitNumber: freezed == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String?,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suburb: null == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EstateCopyWith<$Res>? get estate {
    if (_self.estate == null) {
    return null;
  }

  return $EstateCopyWith<$Res>(_self.estate!, (value) {
    return _then(_self.copyWith(estate: value));
  });
}
}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String clientId,  String? estateId,  Estate? estate,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String postalCode,  String? city,  String? province,  String country,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes,  bool isPrimary,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.tenantId,_that.clientId,_that.estateId,_that.estate,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.postalCode,_that.city,_that.province,_that.country,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes,_that.isPrimary,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String clientId,  String? estateId,  Estate? estate,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String postalCode,  String? city,  String? province,  String country,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes,  bool isPrimary,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.tenantId,_that.clientId,_that.estateId,_that.estate,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.postalCode,_that.city,_that.province,_that.country,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes,_that.isPrimary,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String clientId,  String? estateId,  Estate? estate,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String postalCode,  String? city,  String? province,  String country,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes,  bool isPrimary,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.tenantId,_that.clientId,_that.estateId,_that.estate,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.postalCode,_that.city,_that.province,_that.country,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes,_that.isPrimary,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Address extends Address {
  const _Address({required this.id, required this.tenantId, required this.clientId, this.estateId, this.estate, this.complexOrEstate, this.unitNumber, required this.street, required this.suburb, required this.postalCode, this.city, this.province, this.country = 'South Africa', this.latitude, this.longitude, this.googlePlaceId, this.notes, this.isPrimary = true, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String tenantId;
@override final  String clientId;
@override final  String? estateId;
@override final  Estate? estate;
@override final  String? complexOrEstate;
@override final  String? unitNumber;
@override final  String street;
@override final  String suburb;
@override final  String postalCode;
@override final  String? city;
@override final  String? province;
@override@JsonKey() final  String country;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? googlePlaceId;
@override final  String? notes;
@override@JsonKey() final  bool isPrimary;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.estate, estate) || other.estate == estate)&&(identical(other.complexOrEstate, complexOrEstate) || other.complexOrEstate == complexOrEstate)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.street, street) || other.street == street)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,clientId,estateId,estate,complexOrEstate,unitNumber,street,suburb,postalCode,city,province,country,latitude,longitude,googlePlaceId,notes,isPrimary,createdAt,updatedAt]);

@override
String toString() {
  return 'Address(id: $id, tenantId: $tenantId, clientId: $clientId, estateId: $estateId, estate: $estate, complexOrEstate: $complexOrEstate, unitNumber: $unitNumber, street: $street, suburb: $suburb, postalCode: $postalCode, city: $city, province: $province, country: $country, latitude: $latitude, longitude: $longitude, googlePlaceId: $googlePlaceId, notes: $notes, isPrimary: $isPrimary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String clientId, String? estateId, Estate? estate, String? complexOrEstate, String? unitNumber, String street, String suburb, String postalCode, String? city, String? province, String country, double? latitude, double? longitude, String? googlePlaceId, String? notes, bool isPrimary, DateTime createdAt, DateTime updatedAt
});


@override $EstateCopyWith<$Res>? get estate;

}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? clientId = null,Object? estateId = freezed,Object? estate = freezed,Object? complexOrEstate = freezed,Object? unitNumber = freezed,Object? street = null,Object? suburb = null,Object? postalCode = null,Object? city = freezed,Object? province = freezed,Object? country = null,Object? latitude = freezed,Object? longitude = freezed,Object? googlePlaceId = freezed,Object? notes = freezed,Object? isPrimary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,estate: freezed == estate ? _self.estate : estate // ignore: cast_nullable_to_non_nullable
as Estate?,complexOrEstate: freezed == complexOrEstate ? _self.complexOrEstate : complexOrEstate // ignore: cast_nullable_to_non_nullable
as String?,unitNumber: freezed == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String?,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suburb: null == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EstateCopyWith<$Res>? get estate {
    if (_self.estate == null) {
    return null;
  }

  return $EstateCopyWith<$Res>(_self.estate!, (value) {
    return _then(_self.copyWith(estate: value));
  });
}
}

// dart format on
