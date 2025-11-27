// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insurer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Insurer {

 String get id; String get tenantId; String get name; String? get contactPhone; String? get contactEmail; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Insurer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsurerCopyWith<Insurer> get copyWith => _$InsurerCopyWithImpl<Insurer>(this as Insurer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Insurer&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,name,contactPhone,contactEmail,createdAt,updatedAt);

@override
String toString() {
  return 'Insurer(id: $id, tenantId: $tenantId, name: $name, contactPhone: $contactPhone, contactEmail: $contactEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InsurerCopyWith<$Res>  {
  factory $InsurerCopyWith(Insurer value, $Res Function(Insurer) _then) = _$InsurerCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String name, String? contactPhone, String? contactEmail, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$InsurerCopyWithImpl<$Res>
    implements $InsurerCopyWith<$Res> {
  _$InsurerCopyWithImpl(this._self, this._then);

  final Insurer _self;
  final $Res Function(Insurer) _then;

/// Create a copy of Insurer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? name = null,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Insurer].
extension InsurerPatterns on Insurer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Insurer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Insurer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Insurer value)  $default,){
final _that = this;
switch (_that) {
case _Insurer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Insurer value)?  $default,){
final _that = this;
switch (_that) {
case _Insurer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String name,  String? contactPhone,  String? contactEmail,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Insurer() when $default != null:
return $default(_that.id,_that.tenantId,_that.name,_that.contactPhone,_that.contactEmail,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String name,  String? contactPhone,  String? contactEmail,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Insurer():
return $default(_that.id,_that.tenantId,_that.name,_that.contactPhone,_that.contactEmail,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String name,  String? contactPhone,  String? contactEmail,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Insurer() when $default != null:
return $default(_that.id,_that.tenantId,_that.name,_that.contactPhone,_that.contactEmail,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Insurer implements Insurer {
  const _Insurer({required this.id, required this.tenantId, required this.name, this.contactPhone, this.contactEmail, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String tenantId;
@override final  String name;
@override final  String? contactPhone;
@override final  String? contactEmail;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Insurer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsurerCopyWith<_Insurer> get copyWith => __$InsurerCopyWithImpl<_Insurer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Insurer&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,name,contactPhone,contactEmail,createdAt,updatedAt);

@override
String toString() {
  return 'Insurer(id: $id, tenantId: $tenantId, name: $name, contactPhone: $contactPhone, contactEmail: $contactEmail, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InsurerCopyWith<$Res> implements $InsurerCopyWith<$Res> {
  factory _$InsurerCopyWith(_Insurer value, $Res Function(_Insurer) _then) = __$InsurerCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String name, String? contactPhone, String? contactEmail, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$InsurerCopyWithImpl<$Res>
    implements _$InsurerCopyWith<$Res> {
  __$InsurerCopyWithImpl(this._self, this._then);

  final _Insurer _self;
  final $Res Function(_Insurer) _then;

/// Create a copy of Insurer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? name = null,Object? contactPhone = freezed,Object? contactEmail = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Insurer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
