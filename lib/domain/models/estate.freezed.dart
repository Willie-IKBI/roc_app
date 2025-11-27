// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Estate {

 String get id; String get tenantId; String get name; String? get suburb; String? get city; String? get province; String? get postalCode; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstateCopyWith<Estate> get copyWith => _$EstateCopyWithImpl<Estate>(this as Estate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Estate&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,name,suburb,city,province,postalCode,createdAt,updatedAt);

@override
String toString() {
  return 'Estate(id: $id, tenantId: $tenantId, name: $name, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EstateCopyWith<$Res>  {
  factory $EstateCopyWith(Estate value, $Res Function(Estate) _then) = _$EstateCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String name, String? suburb, String? city, String? province, String? postalCode, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$EstateCopyWithImpl<$Res>
    implements $EstateCopyWith<$Res> {
  _$EstateCopyWithImpl(this._self, this._then);

  final Estate _self;
  final $Res Function(Estate) _then;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? name = null,Object? suburb = freezed,Object? city = freezed,Object? province = freezed,Object? postalCode = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Estate].
extension EstatePatterns on Estate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Estate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Estate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Estate value)  $default,){
final _that = this;
switch (_that) {
case _Estate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Estate value)?  $default,){
final _that = this;
switch (_that) {
case _Estate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String name,  String? suburb,  String? city,  String? province,  String? postalCode,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Estate() when $default != null:
return $default(_that.id,_that.tenantId,_that.name,_that.suburb,_that.city,_that.province,_that.postalCode,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String name,  String? suburb,  String? city,  String? province,  String? postalCode,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Estate():
return $default(_that.id,_that.tenantId,_that.name,_that.suburb,_that.city,_that.province,_that.postalCode,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String name,  String? suburb,  String? city,  String? province,  String? postalCode,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Estate() when $default != null:
return $default(_that.id,_that.tenantId,_that.name,_that.suburb,_that.city,_that.province,_that.postalCode,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Estate extends Estate {
  const _Estate({required this.id, required this.tenantId, required this.name, this.suburb, this.city, this.province, this.postalCode, required this.createdAt, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String tenantId;
@override final  String name;
@override final  String? suburb;
@override final  String? city;
@override final  String? province;
@override final  String? postalCode;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EstateCopyWith<_Estate> get copyWith => __$EstateCopyWithImpl<_Estate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Estate&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,name,suburb,city,province,postalCode,createdAt,updatedAt);

@override
String toString() {
  return 'Estate(id: $id, tenantId: $tenantId, name: $name, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EstateCopyWith<$Res> implements $EstateCopyWith<$Res> {
  factory _$EstateCopyWith(_Estate value, $Res Function(_Estate) _then) = __$EstateCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String name, String? suburb, String? city, String? province, String? postalCode, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$EstateCopyWithImpl<$Res>
    implements _$EstateCopyWith<$Res> {
  __$EstateCopyWithImpl(this._self, this._then);

  final _Estate _self;
  final $Res Function(_Estate) _then;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? name = null,Object? suburb = freezed,Object? city = freezed,Object? province = freezed,Object? postalCode = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Estate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$EstateInput {

 String get name; String? get suburb; String? get city; String? get province; String? get postalCode;
/// Create a copy of EstateInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstateInputCopyWith<EstateInput> get copyWith => _$EstateInputCopyWithImpl<EstateInput>(this as EstateInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EstateInput&&(identical(other.name, name) || other.name == name)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode));
}


@override
int get hashCode => Object.hash(runtimeType,name,suburb,city,province,postalCode);

@override
String toString() {
  return 'EstateInput(name: $name, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode)';
}


}

/// @nodoc
abstract mixin class $EstateInputCopyWith<$Res>  {
  factory $EstateInputCopyWith(EstateInput value, $Res Function(EstateInput) _then) = _$EstateInputCopyWithImpl;
@useResult
$Res call({
 String name, String? suburb, String? city, String? province, String? postalCode
});




}
/// @nodoc
class _$EstateInputCopyWithImpl<$Res>
    implements $EstateInputCopyWith<$Res> {
  _$EstateInputCopyWithImpl(this._self, this._then);

  final EstateInput _self;
  final $Res Function(EstateInput) _then;

/// Create a copy of EstateInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? suburb = freezed,Object? city = freezed,Object? province = freezed,Object? postalCode = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EstateInput].
extension EstateInputPatterns on EstateInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EstateInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EstateInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EstateInput value)  $default,){
final _that = this;
switch (_that) {
case _EstateInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EstateInput value)?  $default,){
final _that = this;
switch (_that) {
case _EstateInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? suburb,  String? city,  String? province,  String? postalCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EstateInput() when $default != null:
return $default(_that.name,_that.suburb,_that.city,_that.province,_that.postalCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? suburb,  String? city,  String? province,  String? postalCode)  $default,) {final _that = this;
switch (_that) {
case _EstateInput():
return $default(_that.name,_that.suburb,_that.city,_that.province,_that.postalCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? suburb,  String? city,  String? province,  String? postalCode)?  $default,) {final _that = this;
switch (_that) {
case _EstateInput() when $default != null:
return $default(_that.name,_that.suburb,_that.city,_that.province,_that.postalCode);case _:
  return null;

}
}

}

/// @nodoc


class _EstateInput extends EstateInput {
  const _EstateInput({required this.name, this.suburb, this.city, this.province, this.postalCode}): super._();
  

@override final  String name;
@override final  String? suburb;
@override final  String? city;
@override final  String? province;
@override final  String? postalCode;

/// Create a copy of EstateInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EstateInputCopyWith<_EstateInput> get copyWith => __$EstateInputCopyWithImpl<_EstateInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EstateInput&&(identical(other.name, name) || other.name == name)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.city, city) || other.city == city)&&(identical(other.province, province) || other.province == province)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode));
}


@override
int get hashCode => Object.hash(runtimeType,name,suburb,city,province,postalCode);

@override
String toString() {
  return 'EstateInput(name: $name, suburb: $suburb, city: $city, province: $province, postalCode: $postalCode)';
}


}

/// @nodoc
abstract mixin class _$EstateInputCopyWith<$Res> implements $EstateInputCopyWith<$Res> {
  factory _$EstateInputCopyWith(_EstateInput value, $Res Function(_EstateInput) _then) = __$EstateInputCopyWithImpl;
@override @useResult
$Res call({
 String name, String? suburb, String? city, String? province, String? postalCode
});




}
/// @nodoc
class __$EstateInputCopyWithImpl<$Res>
    implements _$EstateInputCopyWith<$Res> {
  __$EstateInputCopyWithImpl(this._self, this._then);

  final _EstateInput _self;
  final $Res Function(_EstateInput) _then;

/// Create a copy of EstateInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? suburb = freezed,Object? city = freezed,Object? province = freezed,Object? postalCode = freezed,}) {
  return _then(_EstateInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
