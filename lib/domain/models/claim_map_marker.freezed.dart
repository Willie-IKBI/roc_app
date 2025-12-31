// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_map_marker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimMapMarker {

 String get claimId; String get claimNumber; ClaimStatus get status; double get latitude; double get longitude; String? get technicianId; String? get technicianName; String? get clientName; String? get address;
/// Create a copy of ClaimMapMarker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimMapMarkerCopyWith<ClaimMapMarker> get copyWith => _$ClaimMapMarkerCopyWithImpl<ClaimMapMarker>(this as ClaimMapMarker, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimMapMarker&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,status,latitude,longitude,technicianId,technicianName,clientName,address);

@override
String toString() {
  return 'ClaimMapMarker(claimId: $claimId, claimNumber: $claimNumber, status: $status, latitude: $latitude, longitude: $longitude, technicianId: $technicianId, technicianName: $technicianName, clientName: $clientName, address: $address)';
}


}

/// @nodoc
abstract mixin class $ClaimMapMarkerCopyWith<$Res>  {
  factory $ClaimMapMarkerCopyWith(ClaimMapMarker value, $Res Function(ClaimMapMarker) _then) = _$ClaimMapMarkerCopyWithImpl;
@useResult
$Res call({
 String claimId, String claimNumber, ClaimStatus status, double latitude, double longitude, String? technicianId, String? technicianName, String? clientName, String? address
});




}
/// @nodoc
class _$ClaimMapMarkerCopyWithImpl<$Res>
    implements $ClaimMapMarkerCopyWith<$Res> {
  _$ClaimMapMarkerCopyWithImpl(this._self, this._then);

  final ClaimMapMarker _self;
  final $Res Function(ClaimMapMarker) _then;

/// Create a copy of ClaimMapMarker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claimId = null,Object? claimNumber = null,Object? status = null,Object? latitude = null,Object? longitude = null,Object? technicianId = freezed,Object? technicianName = freezed,Object? clientName = freezed,Object? address = freezed,}) {
  return _then(_self.copyWith(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimMapMarker].
extension ClaimMapMarkerPatterns on ClaimMapMarker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimMapMarker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimMapMarker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimMapMarker value)  $default,){
final _that = this;
switch (_that) {
case _ClaimMapMarker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimMapMarker value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimMapMarker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  ClaimStatus status,  double latitude,  double longitude,  String? technicianId,  String? technicianName,  String? clientName,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimMapMarker() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.status,_that.latitude,_that.longitude,_that.technicianId,_that.technicianName,_that.clientName,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  ClaimStatus status,  double latitude,  double longitude,  String? technicianId,  String? technicianName,  String? clientName,  String? address)  $default,) {final _that = this;
switch (_that) {
case _ClaimMapMarker():
return $default(_that.claimId,_that.claimNumber,_that.status,_that.latitude,_that.longitude,_that.technicianId,_that.technicianName,_that.clientName,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String claimId,  String claimNumber,  ClaimStatus status,  double latitude,  double longitude,  String? technicianId,  String? technicianName,  String? clientName,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _ClaimMapMarker() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.status,_that.latitude,_that.longitude,_that.technicianId,_that.technicianName,_that.clientName,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimMapMarker extends ClaimMapMarker {
  const _ClaimMapMarker({required this.claimId, required this.claimNumber, required this.status, required this.latitude, required this.longitude, this.technicianId, this.technicianName, this.clientName, this.address}): super._();
  

@override final  String claimId;
@override final  String claimNumber;
@override final  ClaimStatus status;
@override final  double latitude;
@override final  double longitude;
@override final  String? technicianId;
@override final  String? technicianName;
@override final  String? clientName;
@override final  String? address;

/// Create a copy of ClaimMapMarker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimMapMarkerCopyWith<_ClaimMapMarker> get copyWith => __$ClaimMapMarkerCopyWithImpl<_ClaimMapMarker>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimMapMarker&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,status,latitude,longitude,technicianId,technicianName,clientName,address);

@override
String toString() {
  return 'ClaimMapMarker(claimId: $claimId, claimNumber: $claimNumber, status: $status, latitude: $latitude, longitude: $longitude, technicianId: $technicianId, technicianName: $technicianName, clientName: $clientName, address: $address)';
}


}

/// @nodoc
abstract mixin class _$ClaimMapMarkerCopyWith<$Res> implements $ClaimMapMarkerCopyWith<$Res> {
  factory _$ClaimMapMarkerCopyWith(_ClaimMapMarker value, $Res Function(_ClaimMapMarker) _then) = __$ClaimMapMarkerCopyWithImpl;
@override @useResult
$Res call({
 String claimId, String claimNumber, ClaimStatus status, double latitude, double longitude, String? technicianId, String? technicianName, String? clientName, String? address
});




}
/// @nodoc
class __$ClaimMapMarkerCopyWithImpl<$Res>
    implements _$ClaimMapMarkerCopyWith<$Res> {
  __$ClaimMapMarkerCopyWithImpl(this._self, this._then);

  final _ClaimMapMarker _self;
  final $Res Function(_ClaimMapMarker) _then;

/// Create a copy of ClaimMapMarker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claimId = null,Object? claimNumber = null,Object? status = null,Object? latitude = null,Object? longitude = null,Object? technicianId = freezed,Object? technicianName = freezed,Object? clientName = freezed,Object? address = freezed,}) {
  return _then(_ClaimMapMarker(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
