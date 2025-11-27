// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimItemDraft {

 String get brand; String? get color; WarrantyStatus get warranty; String? get serialOrModel; String? get notes;
/// Create a copy of ClaimItemDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimItemDraftCopyWith<ClaimItemDraft> get copyWith => _$ClaimItemDraftCopyWithImpl<ClaimItemDraft>(this as ClaimItemDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimItemDraft&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.color, color) || other.color == color)&&(identical(other.warranty, warranty) || other.warranty == warranty)&&(identical(other.serialOrModel, serialOrModel) || other.serialOrModel == serialOrModel)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,brand,color,warranty,serialOrModel,notes);

@override
String toString() {
  return 'ClaimItemDraft(brand: $brand, color: $color, warranty: $warranty, serialOrModel: $serialOrModel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ClaimItemDraftCopyWith<$Res>  {
  factory $ClaimItemDraftCopyWith(ClaimItemDraft value, $Res Function(ClaimItemDraft) _then) = _$ClaimItemDraftCopyWithImpl;
@useResult
$Res call({
 String brand, String? color, WarrantyStatus warranty, String? serialOrModel, String? notes
});




}
/// @nodoc
class _$ClaimItemDraftCopyWithImpl<$Res>
    implements $ClaimItemDraftCopyWith<$Res> {
  _$ClaimItemDraftCopyWithImpl(this._self, this._then);

  final ClaimItemDraft _self;
  final $Res Function(ClaimItemDraft) _then;

/// Create a copy of ClaimItemDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brand = null,Object? color = freezed,Object? warranty = null,Object? serialOrModel = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,warranty: null == warranty ? _self.warranty : warranty // ignore: cast_nullable_to_non_nullable
as WarrantyStatus,serialOrModel: freezed == serialOrModel ? _self.serialOrModel : serialOrModel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimItemDraft].
extension ClaimItemDraftPatterns on ClaimItemDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimItemDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimItemDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimItemDraft value)  $default,){
final _that = this;
switch (_that) {
case _ClaimItemDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimItemDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimItemDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimItemDraft() when $default != null:
return $default(_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ClaimItemDraft():
return $default(_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ClaimItemDraft() when $default != null:
return $default(_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimItemDraft extends ClaimItemDraft {
  const _ClaimItemDraft({required this.brand, this.color, this.warranty = WarrantyStatus.unknown, this.serialOrModel, this.notes}): super._();
  

@override final  String brand;
@override final  String? color;
@override@JsonKey() final  WarrantyStatus warranty;
@override final  String? serialOrModel;
@override final  String? notes;

/// Create a copy of ClaimItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimItemDraftCopyWith<_ClaimItemDraft> get copyWith => __$ClaimItemDraftCopyWithImpl<_ClaimItemDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimItemDraft&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.color, color) || other.color == color)&&(identical(other.warranty, warranty) || other.warranty == warranty)&&(identical(other.serialOrModel, serialOrModel) || other.serialOrModel == serialOrModel)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,brand,color,warranty,serialOrModel,notes);

@override
String toString() {
  return 'ClaimItemDraft(brand: $brand, color: $color, warranty: $warranty, serialOrModel: $serialOrModel, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ClaimItemDraftCopyWith<$Res> implements $ClaimItemDraftCopyWith<$Res> {
  factory _$ClaimItemDraftCopyWith(_ClaimItemDraft value, $Res Function(_ClaimItemDraft) _then) = __$ClaimItemDraftCopyWithImpl;
@override @useResult
$Res call({
 String brand, String? color, WarrantyStatus warranty, String? serialOrModel, String? notes
});




}
/// @nodoc
class __$ClaimItemDraftCopyWithImpl<$Res>
    implements _$ClaimItemDraftCopyWith<$Res> {
  __$ClaimItemDraftCopyWithImpl(this._self, this._then);

  final _ClaimItemDraft _self;
  final $Res Function(_ClaimItemDraft) _then;

/// Create a copy of ClaimItemDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brand = null,Object? color = freezed,Object? warranty = null,Object? serialOrModel = freezed,Object? notes = freezed,}) {
  return _then(_ClaimItemDraft(
brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,warranty: null == warranty ? _self.warranty : warranty // ignore: cast_nullable_to_non_nullable
as WarrantyStatus,serialOrModel: freezed == serialOrModel ? _self.serialOrModel : serialOrModel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ClientInput {

 String get firstName; String get lastName; String get primaryPhone; String? get altPhone; String? get email;
/// Create a copy of ClientInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientInputCopyWith<ClientInput> get copyWith => _$ClientInputCopyWithImpl<ClientInput>(this as ClientInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientInput&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.altPhone, altPhone) || other.altPhone == altPhone)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,primaryPhone,altPhone,email);

@override
String toString() {
  return 'ClientInput(firstName: $firstName, lastName: $lastName, primaryPhone: $primaryPhone, altPhone: $altPhone, email: $email)';
}


}

/// @nodoc
abstract mixin class $ClientInputCopyWith<$Res>  {
  factory $ClientInputCopyWith(ClientInput value, $Res Function(ClientInput) _then) = _$ClientInputCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String primaryPhone, String? altPhone, String? email
});




}
/// @nodoc
class _$ClientInputCopyWithImpl<$Res>
    implements $ClientInputCopyWith<$Res> {
  _$ClientInputCopyWithImpl(this._self, this._then);

  final ClientInput _self;
  final $Res Function(ClientInput) _then;

/// Create a copy of ClientInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? primaryPhone = null,Object? altPhone = freezed,Object? email = freezed,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,altPhone: freezed == altPhone ? _self.altPhone : altPhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientInput].
extension ClientInputPatterns on ClientInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientInput value)  $default,){
final _that = this;
switch (_that) {
case _ClientInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientInput value)?  $default,){
final _that = this;
switch (_that) {
case _ClientInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String primaryPhone,  String? altPhone,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientInput() when $default != null:
return $default(_that.firstName,_that.lastName,_that.primaryPhone,_that.altPhone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String primaryPhone,  String? altPhone,  String? email)  $default,) {final _that = this;
switch (_that) {
case _ClientInput():
return $default(_that.firstName,_that.lastName,_that.primaryPhone,_that.altPhone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String primaryPhone,  String? altPhone,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _ClientInput() when $default != null:
return $default(_that.firstName,_that.lastName,_that.primaryPhone,_that.altPhone,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _ClientInput extends ClientInput {
  const _ClientInput({required this.firstName, required this.lastName, required this.primaryPhone, this.altPhone, this.email}): super._();
  

@override final  String firstName;
@override final  String lastName;
@override final  String primaryPhone;
@override final  String? altPhone;
@override final  String? email;

/// Create a copy of ClientInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientInputCopyWith<_ClientInput> get copyWith => __$ClientInputCopyWithImpl<_ClientInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientInput&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.altPhone, altPhone) || other.altPhone == altPhone)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,primaryPhone,altPhone,email);

@override
String toString() {
  return 'ClientInput(firstName: $firstName, lastName: $lastName, primaryPhone: $primaryPhone, altPhone: $altPhone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ClientInputCopyWith<$Res> implements $ClientInputCopyWith<$Res> {
  factory _$ClientInputCopyWith(_ClientInput value, $Res Function(_ClientInput) _then) = __$ClientInputCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String primaryPhone, String? altPhone, String? email
});




}
/// @nodoc
class __$ClientInputCopyWithImpl<$Res>
    implements _$ClientInputCopyWith<$Res> {
  __$ClientInputCopyWithImpl(this._self, this._then);

  final _ClientInput _self;
  final $Res Function(_ClientInput) _then;

/// Create a copy of ClientInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? primaryPhone = null,Object? altPhone = freezed,Object? email = freezed,}) {
  return _then(_ClientInput(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,altPhone: freezed == altPhone ? _self.altPhone : altPhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AddressInput {

 String? get estateId; String? get complexOrEstate; String? get unitNumber; String get street; String get suburb; String get city; String get province; String get postalCode; double? get latitude; double? get longitude; String? get googlePlaceId; String? get notes;
/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressInputCopyWith<AddressInput> get copyWith => _$AddressInputCopyWithImpl<AddressInput>(this as AddressInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressInput&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.complexOrEstate, complexOrEstate) || other.complexOrEstate == complexOrEstate)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.street, street) || other.street == street)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,estateId,complexOrEstate,unitNumber,street,suburb,city,province,postalCode,latitude,longitude,googlePlaceId,notes);

@override
String toString() {
  return 'AddressInput(estateId: $estateId, complexOrEstate: $complexOrEstate, unitNumber: $unitNumber, street: $street, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, googlePlaceId: $googlePlaceId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $AddressInputCopyWith<$Res>  {
  factory $AddressInputCopyWith(AddressInput value, $Res Function(AddressInput) _then) = _$AddressInputCopyWithImpl;
@useResult
$Res call({
 String? estateId, String? complexOrEstate, String? unitNumber, String street, String suburb, String city, String province, String postalCode, double? latitude, double? longitude, String? googlePlaceId, String? notes
});




}
/// @nodoc
class _$AddressInputCopyWithImpl<$Res>
    implements $AddressInputCopyWith<$Res> {
  _$AddressInputCopyWithImpl(this._self, this._then);

  final AddressInput _self;
  final $Res Function(AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? estateId = freezed,Object? complexOrEstate = freezed,Object? unitNumber = freezed,Object? street = null,Object? suburb = null,Object? city = null,Object? province = null,Object? postalCode = null,Object? latitude = freezed,Object? longitude = freezed,Object? googlePlaceId = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,complexOrEstate: freezed == complexOrEstate ? _self.complexOrEstate : complexOrEstate // ignore: cast_nullable_to_non_nullable
as String?,unitNumber: freezed == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String?,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suburb: null == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressInput].
extension AddressInputPatterns on AddressInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressInput value)  $default,){
final _that = this;
switch (_that) {
case _AddressInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressInput value)?  $default,){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? estateId,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String city,  String province,  String postalCode,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.estateId,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.city,_that.province,_that.postalCode,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? estateId,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String city,  String province,  String postalCode,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _AddressInput():
return $default(_that.estateId,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.city,_that.province,_that.postalCode,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? estateId,  String? complexOrEstate,  String? unitNumber,  String street,  String suburb,  String city,  String province,  String postalCode,  double? latitude,  double? longitude,  String? googlePlaceId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.estateId,_that.complexOrEstate,_that.unitNumber,_that.street,_that.suburb,_that.city,_that.province,_that.postalCode,_that.latitude,_that.longitude,_that.googlePlaceId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _AddressInput extends AddressInput {
  const _AddressInput({this.estateId, this.complexOrEstate, this.unitNumber, required this.street, required this.suburb, required this.city, required this.province, required this.postalCode, this.latitude, this.longitude, this.googlePlaceId, this.notes}): super._();
  

@override final  String? estateId;
@override final  String? complexOrEstate;
@override final  String? unitNumber;
@override final  String street;
@override final  String suburb;
@override final  String city;
@override final  String province;
@override final  String postalCode;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? googlePlaceId;
@override final  String? notes;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressInputCopyWith<_AddressInput> get copyWith => __$AddressInputCopyWithImpl<_AddressInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressInput&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.complexOrEstate, complexOrEstate) || other.complexOrEstate == complexOrEstate)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.street, street) || other.street == street)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.googlePlaceId, googlePlaceId) || other.googlePlaceId == googlePlaceId)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,estateId,complexOrEstate,unitNumber,street,suburb,city,province,postalCode,latitude,longitude,googlePlaceId,notes);

@override
String toString() {
  return 'AddressInput(estateId: $estateId, complexOrEstate: $complexOrEstate, unitNumber: $unitNumber, street: $street, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, googlePlaceId: $googlePlaceId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$AddressInputCopyWith<$Res> implements $AddressInputCopyWith<$Res> {
  factory _$AddressInputCopyWith(_AddressInput value, $Res Function(_AddressInput) _then) = __$AddressInputCopyWithImpl;
@override @useResult
$Res call({
 String? estateId, String? complexOrEstate, String? unitNumber, String street, String suburb, String city, String province, String postalCode, double? latitude, double? longitude, String? googlePlaceId, String? notes
});




}
/// @nodoc
class __$AddressInputCopyWithImpl<$Res>
    implements _$AddressInputCopyWith<$Res> {
  __$AddressInputCopyWithImpl(this._self, this._then);

  final _AddressInput _self;
  final $Res Function(_AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? estateId = freezed,Object? complexOrEstate = freezed,Object? unitNumber = freezed,Object? street = null,Object? suburb = null,Object? city = null,Object? province = null,Object? postalCode = null,Object? latitude = freezed,Object? longitude = freezed,Object? googlePlaceId = freezed,Object? notes = freezed,}) {
  return _then(_AddressInput(
estateId: freezed == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String?,complexOrEstate: freezed == complexOrEstate ? _self.complexOrEstate : complexOrEstate // ignore: cast_nullable_to_non_nullable
as String?,unitNumber: freezed == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String?,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,suburb: null == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,googlePlaceId: freezed == googlePlaceId ? _self.googlePlaceId : googlePlaceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ServiceProviderInput {

 String get companyName; String? get contactName; String? get contactPhone; String? get contactEmail; String? get referenceNumber;
/// Create a copy of ServiceProviderInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceProviderInputCopyWith<ServiceProviderInput> get copyWith => _$ServiceProviderInputCopyWithImpl<ServiceProviderInput>(this as ServiceProviderInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceProviderInput&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,contactName,contactPhone,contactEmail,referenceNumber);

@override
String toString() {
  return 'ServiceProviderInput(companyName: $companyName, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, referenceNumber: $referenceNumber)';
}


}

/// @nodoc
abstract mixin class $ServiceProviderInputCopyWith<$Res>  {
  factory $ServiceProviderInputCopyWith(ServiceProviderInput value, $Res Function(ServiceProviderInput) _then) = _$ServiceProviderInputCopyWithImpl;
@useResult
$Res call({
 String companyName, String? contactName, String? contactPhone, String? contactEmail, String? referenceNumber
});




}
/// @nodoc
class _$ServiceProviderInputCopyWithImpl<$Res>
    implements $ServiceProviderInputCopyWith<$Res> {
  _$ServiceProviderInputCopyWithImpl(this._self, this._then);

  final ServiceProviderInput _self;
  final $Res Function(ServiceProviderInput) _then;

/// Create a copy of ServiceProviderInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? contactName = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? referenceNumber = freezed,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceProviderInput].
extension ServiceProviderInputPatterns on ServiceProviderInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceProviderInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceProviderInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceProviderInput value)  $default,){
final _that = this;
switch (_that) {
case _ServiceProviderInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceProviderInput value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceProviderInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String? contactName,  String? contactPhone,  String? contactEmail,  String? referenceNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceProviderInput() when $default != null:
return $default(_that.companyName,_that.contactName,_that.contactPhone,_that.contactEmail,_that.referenceNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String? contactName,  String? contactPhone,  String? contactEmail,  String? referenceNumber)  $default,) {final _that = this;
switch (_that) {
case _ServiceProviderInput():
return $default(_that.companyName,_that.contactName,_that.contactPhone,_that.contactEmail,_that.referenceNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String? contactName,  String? contactPhone,  String? contactEmail,  String? referenceNumber)?  $default,) {final _that = this;
switch (_that) {
case _ServiceProviderInput() when $default != null:
return $default(_that.companyName,_that.contactName,_that.contactPhone,_that.contactEmail,_that.referenceNumber);case _:
  return null;

}
}

}

/// @nodoc


class _ServiceProviderInput extends ServiceProviderInput {
  const _ServiceProviderInput({required this.companyName, this.contactName, this.contactPhone, this.contactEmail, this.referenceNumber}): super._();
  

@override final  String companyName;
@override final  String? contactName;
@override final  String? contactPhone;
@override final  String? contactEmail;
@override final  String? referenceNumber;

/// Create a copy of ServiceProviderInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceProviderInputCopyWith<_ServiceProviderInput> get copyWith => __$ServiceProviderInputCopyWithImpl<_ServiceProviderInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceProviderInput&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.referenceNumber, referenceNumber) || other.referenceNumber == referenceNumber));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,contactName,contactPhone,contactEmail,referenceNumber);

@override
String toString() {
  return 'ServiceProviderInput(companyName: $companyName, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, referenceNumber: $referenceNumber)';
}


}

/// @nodoc
abstract mixin class _$ServiceProviderInputCopyWith<$Res> implements $ServiceProviderInputCopyWith<$Res> {
  factory _$ServiceProviderInputCopyWith(_ServiceProviderInput value, $Res Function(_ServiceProviderInput) _then) = __$ServiceProviderInputCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String? contactName, String? contactPhone, String? contactEmail, String? referenceNumber
});




}
/// @nodoc
class __$ServiceProviderInputCopyWithImpl<$Res>
    implements _$ServiceProviderInputCopyWith<$Res> {
  __$ServiceProviderInputCopyWithImpl(this._self, this._then);

  final _ServiceProviderInput _self;
  final $Res Function(_ServiceProviderInput) _then;

/// Create a copy of ServiceProviderInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? contactName = freezed,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? referenceNumber = freezed,}) {
  return _then(_ServiceProviderInput(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,contactName: freezed == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,referenceNumber: freezed == referenceNumber ? _self.referenceNumber : referenceNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ClaimDraft {

 String get tenantId; String get claimNumber; String get insurerId; String? get clientId; ClientInput? get clientInput; String? get addressId; AddressInput? get addressInput; String? get serviceProviderId; ServiceProviderInput? get serviceProviderInput; String? get dasNumber; PriorityLevel get priority; DamageCause get damageCause; String? get damageDescription; bool get surgeProtectionAtDb; bool get surgeProtectionAtPlug; String? get agentId; String? get notesPublic; String? get notesInternal; String? get clientNotes; List<ClaimItemDraft> get items;
/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimDraftCopyWith<ClaimDraft> get copyWith => _$ClaimDraftCopyWithImpl<ClaimDraft>(this as ClaimDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimDraft&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientInput, clientInput) || other.clientInput == clientInput)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.addressInput, addressInput) || other.addressInput == addressInput)&&(identical(other.serviceProviderId, serviceProviderId) || other.serviceProviderId == serviceProviderId)&&(identical(other.serviceProviderInput, serviceProviderInput) || other.serviceProviderInput == serviceProviderInput)&&(identical(other.dasNumber, dasNumber) || other.dasNumber == dasNumber)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.damageDescription, damageDescription) || other.damageDescription == damageDescription)&&(identical(other.surgeProtectionAtDb, surgeProtectionAtDb) || other.surgeProtectionAtDb == surgeProtectionAtDb)&&(identical(other.surgeProtectionAtPlug, surgeProtectionAtPlug) || other.surgeProtectionAtPlug == surgeProtectionAtPlug)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.notesPublic, notesPublic) || other.notesPublic == notesPublic)&&(identical(other.notesInternal, notesInternal) || other.notesInternal == notesInternal)&&(identical(other.clientNotes, clientNotes) || other.clientNotes == clientNotes)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hashAll([runtimeType,tenantId,claimNumber,insurerId,clientId,clientInput,addressId,addressInput,serviceProviderId,serviceProviderInput,dasNumber,priority,damageCause,damageDescription,surgeProtectionAtDb,surgeProtectionAtPlug,agentId,notesPublic,notesInternal,clientNotes,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'ClaimDraft(tenantId: $tenantId, claimNumber: $claimNumber, insurerId: $insurerId, clientId: $clientId, clientInput: $clientInput, addressId: $addressId, addressInput: $addressInput, serviceProviderId: $serviceProviderId, serviceProviderInput: $serviceProviderInput, dasNumber: $dasNumber, priority: $priority, damageCause: $damageCause, damageDescription: $damageDescription, surgeProtectionAtDb: $surgeProtectionAtDb, surgeProtectionAtPlug: $surgeProtectionAtPlug, agentId: $agentId, notesPublic: $notesPublic, notesInternal: $notesInternal, clientNotes: $clientNotes, items: $items)';
}


}

/// @nodoc
abstract mixin class $ClaimDraftCopyWith<$Res>  {
  factory $ClaimDraftCopyWith(ClaimDraft value, $Res Function(ClaimDraft) _then) = _$ClaimDraftCopyWithImpl;
@useResult
$Res call({
 String tenantId, String claimNumber, String insurerId, String? clientId, ClientInput? clientInput, String? addressId, AddressInput? addressInput, String? serviceProviderId, ServiceProviderInput? serviceProviderInput, String? dasNumber, PriorityLevel priority, DamageCause damageCause, String? damageDescription, bool surgeProtectionAtDb, bool surgeProtectionAtPlug, String? agentId, String? notesPublic, String? notesInternal, String? clientNotes, List<ClaimItemDraft> items
});


$ClientInputCopyWith<$Res>? get clientInput;$AddressInputCopyWith<$Res>? get addressInput;$ServiceProviderInputCopyWith<$Res>? get serviceProviderInput;

}
/// @nodoc
class _$ClaimDraftCopyWithImpl<$Res>
    implements $ClaimDraftCopyWith<$Res> {
  _$ClaimDraftCopyWithImpl(this._self, this._then);

  final ClaimDraft _self;
  final $Res Function(ClaimDraft) _then;

/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tenantId = null,Object? claimNumber = null,Object? insurerId = null,Object? clientId = freezed,Object? clientInput = freezed,Object? addressId = freezed,Object? addressInput = freezed,Object? serviceProviderId = freezed,Object? serviceProviderInput = freezed,Object? dasNumber = freezed,Object? priority = null,Object? damageCause = null,Object? damageDescription = freezed,Object? surgeProtectionAtDb = null,Object? surgeProtectionAtPlug = null,Object? agentId = freezed,Object? notesPublic = freezed,Object? notesInternal = freezed,Object? clientNotes = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientInput: freezed == clientInput ? _self.clientInput : clientInput // ignore: cast_nullable_to_non_nullable
as ClientInput?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String?,addressInput: freezed == addressInput ? _self.addressInput : addressInput // ignore: cast_nullable_to_non_nullable
as AddressInput?,serviceProviderId: freezed == serviceProviderId ? _self.serviceProviderId : serviceProviderId // ignore: cast_nullable_to_non_nullable
as String?,serviceProviderInput: freezed == serviceProviderInput ? _self.serviceProviderInput : serviceProviderInput // ignore: cast_nullable_to_non_nullable
as ServiceProviderInput?,dasNumber: freezed == dasNumber ? _self.dasNumber : dasNumber // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,damageDescription: freezed == damageDescription ? _self.damageDescription : damageDescription // ignore: cast_nullable_to_non_nullable
as String?,surgeProtectionAtDb: null == surgeProtectionAtDb ? _self.surgeProtectionAtDb : surgeProtectionAtDb // ignore: cast_nullable_to_non_nullable
as bool,surgeProtectionAtPlug: null == surgeProtectionAtPlug ? _self.surgeProtectionAtPlug : surgeProtectionAtPlug // ignore: cast_nullable_to_non_nullable
as bool,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,notesPublic: freezed == notesPublic ? _self.notesPublic : notesPublic // ignore: cast_nullable_to_non_nullable
as String?,notesInternal: freezed == notesInternal ? _self.notesInternal : notesInternal // ignore: cast_nullable_to_non_nullable
as String?,clientNotes: freezed == clientNotes ? _self.clientNotes : clientNotes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimItemDraft>,
  ));
}
/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientInputCopyWith<$Res>? get clientInput {
    if (_self.clientInput == null) {
    return null;
  }

  return $ClientInputCopyWith<$Res>(_self.clientInput!, (value) {
    return _then(_self.copyWith(clientInput: value));
  });
}/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressInputCopyWith<$Res>? get addressInput {
    if (_self.addressInput == null) {
    return null;
  }

  return $AddressInputCopyWith<$Res>(_self.addressInput!, (value) {
    return _then(_self.copyWith(addressInput: value));
  });
}/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceProviderInputCopyWith<$Res>? get serviceProviderInput {
    if (_self.serviceProviderInput == null) {
    return null;
  }

  return $ServiceProviderInputCopyWith<$Res>(_self.serviceProviderInput!, (value) {
    return _then(_self.copyWith(serviceProviderInput: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClaimDraft].
extension ClaimDraftPatterns on ClaimDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimDraft value)  $default,){
final _that = this;
switch (_that) {
case _ClaimDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tenantId,  String claimNumber,  String insurerId,  String? clientId,  ClientInput? clientInput,  String? addressId,  AddressInput? addressInput,  String? serviceProviderId,  ServiceProviderInput? serviceProviderInput,  String? dasNumber,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? notesPublic,  String? notesInternal,  String? clientNotes,  List<ClaimItemDraft> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimDraft() when $default != null:
return $default(_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.clientInput,_that.addressId,_that.addressInput,_that.serviceProviderId,_that.serviceProviderInput,_that.dasNumber,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.notesPublic,_that.notesInternal,_that.clientNotes,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tenantId,  String claimNumber,  String insurerId,  String? clientId,  ClientInput? clientInput,  String? addressId,  AddressInput? addressInput,  String? serviceProviderId,  ServiceProviderInput? serviceProviderInput,  String? dasNumber,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? notesPublic,  String? notesInternal,  String? clientNotes,  List<ClaimItemDraft> items)  $default,) {final _that = this;
switch (_that) {
case _ClaimDraft():
return $default(_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.clientInput,_that.addressId,_that.addressInput,_that.serviceProviderId,_that.serviceProviderInput,_that.dasNumber,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.notesPublic,_that.notesInternal,_that.clientNotes,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tenantId,  String claimNumber,  String insurerId,  String? clientId,  ClientInput? clientInput,  String? addressId,  AddressInput? addressInput,  String? serviceProviderId,  ServiceProviderInput? serviceProviderInput,  String? dasNumber,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? notesPublic,  String? notesInternal,  String? clientNotes,  List<ClaimItemDraft> items)?  $default,) {final _that = this;
switch (_that) {
case _ClaimDraft() when $default != null:
return $default(_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.clientInput,_that.addressId,_that.addressInput,_that.serviceProviderId,_that.serviceProviderInput,_that.dasNumber,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.notesPublic,_that.notesInternal,_that.clientNotes,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimDraft extends ClaimDraft {
  const _ClaimDraft({required this.tenantId, required this.claimNumber, required this.insurerId, this.clientId, this.clientInput, this.addressId, this.addressInput, this.serviceProviderId, this.serviceProviderInput, this.dasNumber, this.priority = PriorityLevel.normal, this.damageCause = DamageCause.other, this.damageDescription, this.surgeProtectionAtDb = false, this.surgeProtectionAtPlug = false, this.agentId, this.notesPublic, this.notesInternal, this.clientNotes, final  List<ClaimItemDraft> items = const <ClaimItemDraft>[]}): _items = items,super._();
  

@override final  String tenantId;
@override final  String claimNumber;
@override final  String insurerId;
@override final  String? clientId;
@override final  ClientInput? clientInput;
@override final  String? addressId;
@override final  AddressInput? addressInput;
@override final  String? serviceProviderId;
@override final  ServiceProviderInput? serviceProviderInput;
@override final  String? dasNumber;
@override@JsonKey() final  PriorityLevel priority;
@override@JsonKey() final  DamageCause damageCause;
@override final  String? damageDescription;
@override@JsonKey() final  bool surgeProtectionAtDb;
@override@JsonKey() final  bool surgeProtectionAtPlug;
@override final  String? agentId;
@override final  String? notesPublic;
@override final  String? notesInternal;
@override final  String? clientNotes;
 final  List<ClaimItemDraft> _items;
@override@JsonKey() List<ClaimItemDraft> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimDraftCopyWith<_ClaimDraft> get copyWith => __$ClaimDraftCopyWithImpl<_ClaimDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimDraft&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientInput, clientInput) || other.clientInput == clientInput)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.addressInput, addressInput) || other.addressInput == addressInput)&&(identical(other.serviceProviderId, serviceProviderId) || other.serviceProviderId == serviceProviderId)&&(identical(other.serviceProviderInput, serviceProviderInput) || other.serviceProviderInput == serviceProviderInput)&&(identical(other.dasNumber, dasNumber) || other.dasNumber == dasNumber)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.damageDescription, damageDescription) || other.damageDescription == damageDescription)&&(identical(other.surgeProtectionAtDb, surgeProtectionAtDb) || other.surgeProtectionAtDb == surgeProtectionAtDb)&&(identical(other.surgeProtectionAtPlug, surgeProtectionAtPlug) || other.surgeProtectionAtPlug == surgeProtectionAtPlug)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.notesPublic, notesPublic) || other.notesPublic == notesPublic)&&(identical(other.notesInternal, notesInternal) || other.notesInternal == notesInternal)&&(identical(other.clientNotes, clientNotes) || other.clientNotes == clientNotes)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hashAll([runtimeType,tenantId,claimNumber,insurerId,clientId,clientInput,addressId,addressInput,serviceProviderId,serviceProviderInput,dasNumber,priority,damageCause,damageDescription,surgeProtectionAtDb,surgeProtectionAtPlug,agentId,notesPublic,notesInternal,clientNotes,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'ClaimDraft(tenantId: $tenantId, claimNumber: $claimNumber, insurerId: $insurerId, clientId: $clientId, clientInput: $clientInput, addressId: $addressId, addressInput: $addressInput, serviceProviderId: $serviceProviderId, serviceProviderInput: $serviceProviderInput, dasNumber: $dasNumber, priority: $priority, damageCause: $damageCause, damageDescription: $damageDescription, surgeProtectionAtDb: $surgeProtectionAtDb, surgeProtectionAtPlug: $surgeProtectionAtPlug, agentId: $agentId, notesPublic: $notesPublic, notesInternal: $notesInternal, clientNotes: $clientNotes, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ClaimDraftCopyWith<$Res> implements $ClaimDraftCopyWith<$Res> {
  factory _$ClaimDraftCopyWith(_ClaimDraft value, $Res Function(_ClaimDraft) _then) = __$ClaimDraftCopyWithImpl;
@override @useResult
$Res call({
 String tenantId, String claimNumber, String insurerId, String? clientId, ClientInput? clientInput, String? addressId, AddressInput? addressInput, String? serviceProviderId, ServiceProviderInput? serviceProviderInput, String? dasNumber, PriorityLevel priority, DamageCause damageCause, String? damageDescription, bool surgeProtectionAtDb, bool surgeProtectionAtPlug, String? agentId, String? notesPublic, String? notesInternal, String? clientNotes, List<ClaimItemDraft> items
});


@override $ClientInputCopyWith<$Res>? get clientInput;@override $AddressInputCopyWith<$Res>? get addressInput;@override $ServiceProviderInputCopyWith<$Res>? get serviceProviderInput;

}
/// @nodoc
class __$ClaimDraftCopyWithImpl<$Res>
    implements _$ClaimDraftCopyWith<$Res> {
  __$ClaimDraftCopyWithImpl(this._self, this._then);

  final _ClaimDraft _self;
  final $Res Function(_ClaimDraft) _then;

/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tenantId = null,Object? claimNumber = null,Object? insurerId = null,Object? clientId = freezed,Object? clientInput = freezed,Object? addressId = freezed,Object? addressInput = freezed,Object? serviceProviderId = freezed,Object? serviceProviderInput = freezed,Object? dasNumber = freezed,Object? priority = null,Object? damageCause = null,Object? damageDescription = freezed,Object? surgeProtectionAtDb = null,Object? surgeProtectionAtPlug = null,Object? agentId = freezed,Object? notesPublic = freezed,Object? notesInternal = freezed,Object? clientNotes = freezed,Object? items = null,}) {
  return _then(_ClaimDraft(
tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,clientInput: freezed == clientInput ? _self.clientInput : clientInput // ignore: cast_nullable_to_non_nullable
as ClientInput?,addressId: freezed == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String?,addressInput: freezed == addressInput ? _self.addressInput : addressInput // ignore: cast_nullable_to_non_nullable
as AddressInput?,serviceProviderId: freezed == serviceProviderId ? _self.serviceProviderId : serviceProviderId // ignore: cast_nullable_to_non_nullable
as String?,serviceProviderInput: freezed == serviceProviderInput ? _self.serviceProviderInput : serviceProviderInput // ignore: cast_nullable_to_non_nullable
as ServiceProviderInput?,dasNumber: freezed == dasNumber ? _self.dasNumber : dasNumber // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,damageDescription: freezed == damageDescription ? _self.damageDescription : damageDescription // ignore: cast_nullable_to_non_nullable
as String?,surgeProtectionAtDb: null == surgeProtectionAtDb ? _self.surgeProtectionAtDb : surgeProtectionAtDb // ignore: cast_nullable_to_non_nullable
as bool,surgeProtectionAtPlug: null == surgeProtectionAtPlug ? _self.surgeProtectionAtPlug : surgeProtectionAtPlug // ignore: cast_nullable_to_non_nullable
as bool,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,notesPublic: freezed == notesPublic ? _self.notesPublic : notesPublic // ignore: cast_nullable_to_non_nullable
as String?,notesInternal: freezed == notesInternal ? _self.notesInternal : notesInternal // ignore: cast_nullable_to_non_nullable
as String?,clientNotes: freezed == clientNotes ? _self.clientNotes : clientNotes // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimItemDraft>,
  ));
}

/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientInputCopyWith<$Res>? get clientInput {
    if (_self.clientInput == null) {
    return null;
  }

  return $ClientInputCopyWith<$Res>(_self.clientInput!, (value) {
    return _then(_self.copyWith(clientInput: value));
  });
}/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressInputCopyWith<$Res>? get addressInput {
    if (_self.addressInput == null) {
    return null;
  }

  return $AddressInputCopyWith<$Res>(_self.addressInput!, (value) {
    return _then(_self.copyWith(addressInput: value));
  });
}/// Create a copy of ClaimDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceProviderInputCopyWith<$Res>? get serviceProviderInput {
    if (_self.serviceProviderInput == null) {
    return null;
  }

  return $ServiceProviderInputCopyWith<$Res>(_self.serviceProviderInput!, (value) {
    return _then(_self.copyWith(serviceProviderInput: value));
  });
}
}

// dart format on
