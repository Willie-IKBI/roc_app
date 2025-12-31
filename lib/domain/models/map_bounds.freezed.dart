// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_bounds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapBounds {

 double get north;// Maximum latitude
 double get south;// Minimum latitude
 double get east;// Maximum longitude
 double get west;
/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapBoundsCopyWith<MapBounds> get copyWith => _$MapBoundsCopyWithImpl<MapBounds>(this as MapBounds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapBounds&&(identical(other.north, north) || other.north == north)&&(identical(other.south, south) || other.south == south)&&(identical(other.east, east) || other.east == east)&&(identical(other.west, west) || other.west == west));
}


@override
int get hashCode => Object.hash(runtimeType,north,south,east,west);

@override
String toString() {
  return 'MapBounds(north: $north, south: $south, east: $east, west: $west)';
}


}

/// @nodoc
abstract mixin class $MapBoundsCopyWith<$Res>  {
  factory $MapBoundsCopyWith(MapBounds value, $Res Function(MapBounds) _then) = _$MapBoundsCopyWithImpl;
@useResult
$Res call({
 double north, double south, double east, double west
});




}
/// @nodoc
class _$MapBoundsCopyWithImpl<$Res>
    implements $MapBoundsCopyWith<$Res> {
  _$MapBoundsCopyWithImpl(this._self, this._then);

  final MapBounds _self;
  final $Res Function(MapBounds) _then;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? north = null,Object? south = null,Object? east = null,Object? west = null,}) {
  return _then(_self.copyWith(
north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MapBounds].
extension MapBoundsPatterns on MapBounds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapBounds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapBounds value)  $default,){
final _that = this;
switch (_that) {
case _MapBounds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapBounds value)?  $default,){
final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double north,  double south,  double east,  double west)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
return $default(_that.north,_that.south,_that.east,_that.west);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double north,  double south,  double east,  double west)  $default,) {final _that = this;
switch (_that) {
case _MapBounds():
return $default(_that.north,_that.south,_that.east,_that.west);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double north,  double south,  double east,  double west)?  $default,) {final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
return $default(_that.north,_that.south,_that.east,_that.west);case _:
  return null;

}
}

}

/// @nodoc


class _MapBounds extends MapBounds {
  const _MapBounds({required this.north, required this.south, required this.east, required this.west}): super._();
  

@override final  double north;
// Maximum latitude
@override final  double south;
// Minimum latitude
@override final  double east;
// Maximum longitude
@override final  double west;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapBoundsCopyWith<_MapBounds> get copyWith => __$MapBoundsCopyWithImpl<_MapBounds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapBounds&&(identical(other.north, north) || other.north == north)&&(identical(other.south, south) || other.south == south)&&(identical(other.east, east) || other.east == east)&&(identical(other.west, west) || other.west == west));
}


@override
int get hashCode => Object.hash(runtimeType,north,south,east,west);

@override
String toString() {
  return 'MapBounds(north: $north, south: $south, east: $east, west: $west)';
}


}

/// @nodoc
abstract mixin class _$MapBoundsCopyWith<$Res> implements $MapBoundsCopyWith<$Res> {
  factory _$MapBoundsCopyWith(_MapBounds value, $Res Function(_MapBounds) _then) = __$MapBoundsCopyWithImpl;
@override @useResult
$Res call({
 double north, double south, double east, double west
});




}
/// @nodoc
class __$MapBoundsCopyWithImpl<$Res>
    implements _$MapBoundsCopyWith<$Res> {
  __$MapBoundsCopyWithImpl(this._self, this._then);

  final _MapBounds _self;
  final $Res Function(_MapBounds) _then;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? north = null,Object? south = null,Object? east = null,Object? west = null,}) {
  return _then(_MapBounds(
north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
