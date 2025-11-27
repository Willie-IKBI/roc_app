// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimItem {

 String get id; String get claimId; String get brand; String? get color; WarrantyStatus get warranty; String? get serialOrModel; String? get notes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ClaimItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimItemCopyWith<ClaimItem> get copyWith => _$ClaimItemCopyWithImpl<ClaimItem>(this as ClaimItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimItem&&(identical(other.id, id) || other.id == id)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.color, color) || other.color == color)&&(identical(other.warranty, warranty) || other.warranty == warranty)&&(identical(other.serialOrModel, serialOrModel) || other.serialOrModel == serialOrModel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,claimId,brand,color,warranty,serialOrModel,notes,createdAt,updatedAt);

@override
String toString() {
  return 'ClaimItem(id: $id, claimId: $claimId, brand: $brand, color: $color, warranty: $warranty, serialOrModel: $serialOrModel, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ClaimItemCopyWith<$Res>  {
  factory $ClaimItemCopyWith(ClaimItem value, $Res Function(ClaimItem) _then) = _$ClaimItemCopyWithImpl;
@useResult
$Res call({
 String id, String claimId, String brand, String? color, WarrantyStatus warranty, String? serialOrModel, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ClaimItemCopyWithImpl<$Res>
    implements $ClaimItemCopyWith<$Res> {
  _$ClaimItemCopyWithImpl(this._self, this._then);

  final ClaimItem _self;
  final $Res Function(ClaimItem) _then;

/// Create a copy of ClaimItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? claimId = null,Object? brand = null,Object? color = freezed,Object? warranty = null,Object? serialOrModel = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,warranty: null == warranty ? _self.warranty : warranty // ignore: cast_nullable_to_non_nullable
as WarrantyStatus,serialOrModel: freezed == serialOrModel ? _self.serialOrModel : serialOrModel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimItem].
extension ClaimItemPatterns on ClaimItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimItem value)  $default,){
final _that = this;
switch (_that) {
case _ClaimItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimItem value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String claimId,  String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimItem() when $default != null:
return $default(_that.id,_that.claimId,_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String claimId,  String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ClaimItem():
return $default(_that.id,_that.claimId,_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String claimId,  String brand,  String? color,  WarrantyStatus warranty,  String? serialOrModel,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ClaimItem() when $default != null:
return $default(_that.id,_that.claimId,_that.brand,_that.color,_that.warranty,_that.serialOrModel,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimItem extends ClaimItem {
  const _ClaimItem({required this.id, required this.claimId, required this.brand, this.color, this.warranty = WarrantyStatus.unknown, this.serialOrModel, this.notes, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String claimId;
@override final  String brand;
@override final  String? color;
@override@JsonKey() final  WarrantyStatus warranty;
@override final  String? serialOrModel;
@override final  String? notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ClaimItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimItemCopyWith<_ClaimItem> get copyWith => __$ClaimItemCopyWithImpl<_ClaimItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimItem&&(identical(other.id, id) || other.id == id)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.color, color) || other.color == color)&&(identical(other.warranty, warranty) || other.warranty == warranty)&&(identical(other.serialOrModel, serialOrModel) || other.serialOrModel == serialOrModel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,claimId,brand,color,warranty,serialOrModel,notes,createdAt,updatedAt);

@override
String toString() {
  return 'ClaimItem(id: $id, claimId: $claimId, brand: $brand, color: $color, warranty: $warranty, serialOrModel: $serialOrModel, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ClaimItemCopyWith<$Res> implements $ClaimItemCopyWith<$Res> {
  factory _$ClaimItemCopyWith(_ClaimItem value, $Res Function(_ClaimItem) _then) = __$ClaimItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String claimId, String brand, String? color, WarrantyStatus warranty, String? serialOrModel, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ClaimItemCopyWithImpl<$Res>
    implements _$ClaimItemCopyWith<$Res> {
  __$ClaimItemCopyWithImpl(this._self, this._then);

  final _ClaimItem _self;
  final $Res Function(_ClaimItem) _then;

/// Create a copy of ClaimItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? claimId = null,Object? brand = null,Object? color = freezed,Object? warranty = null,Object? serialOrModel = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ClaimItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,warranty: null == warranty ? _self.warranty : warranty // ignore: cast_nullable_to_non_nullable
as WarrantyStatus,serialOrModel: freezed == serialOrModel ? _self.serialOrModel : serialOrModel // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
