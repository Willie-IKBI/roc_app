// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueSettings {

 String get id; String get tenantId; int get retryLimit; int get retryIntervalMinutes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of QueueSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueSettingsCopyWith<QueueSettings> get copyWith => _$QueueSettingsCopyWithImpl<QueueSettings>(this as QueueSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.retryLimit, retryLimit) || other.retryLimit == retryLimit)&&(identical(other.retryIntervalMinutes, retryIntervalMinutes) || other.retryIntervalMinutes == retryIntervalMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,retryLimit,retryIntervalMinutes,createdAt,updatedAt);

@override
String toString() {
  return 'QueueSettings(id: $id, tenantId: $tenantId, retryLimit: $retryLimit, retryIntervalMinutes: $retryIntervalMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QueueSettingsCopyWith<$Res>  {
  factory $QueueSettingsCopyWith(QueueSettings value, $Res Function(QueueSettings) _then) = _$QueueSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, int retryLimit, int retryIntervalMinutes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$QueueSettingsCopyWithImpl<$Res>
    implements $QueueSettingsCopyWith<$Res> {
  _$QueueSettingsCopyWithImpl(this._self, this._then);

  final QueueSettings _self;
  final $Res Function(QueueSettings) _then;

/// Create a copy of QueueSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? retryLimit = null,Object? retryIntervalMinutes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,retryLimit: null == retryLimit ? _self.retryLimit : retryLimit // ignore: cast_nullable_to_non_nullable
as int,retryIntervalMinutes: null == retryIntervalMinutes ? _self.retryIntervalMinutes : retryIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueSettings].
extension QueueSettingsPatterns on QueueSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueSettings value)  $default,){
final _that = this;
switch (_that) {
case _QueueSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueSettings value)?  $default,){
final _that = this;
switch (_that) {
case _QueueSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  int retryLimit,  int retryIntervalMinutes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueSettings() when $default != null:
return $default(_that.id,_that.tenantId,_that.retryLimit,_that.retryIntervalMinutes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  int retryLimit,  int retryIntervalMinutes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _QueueSettings():
return $default(_that.id,_that.tenantId,_that.retryLimit,_that.retryIntervalMinutes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  int retryLimit,  int retryIntervalMinutes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _QueueSettings() when $default != null:
return $default(_that.id,_that.tenantId,_that.retryLimit,_that.retryIntervalMinutes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _QueueSettings implements QueueSettings {
  const _QueueSettings({required this.id, required this.tenantId, required this.retryLimit, required this.retryIntervalMinutes, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String tenantId;
@override final  int retryLimit;
@override final  int retryIntervalMinutes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of QueueSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueSettingsCopyWith<_QueueSettings> get copyWith => __$QueueSettingsCopyWithImpl<_QueueSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.retryLimit, retryLimit) || other.retryLimit == retryLimit)&&(identical(other.retryIntervalMinutes, retryIntervalMinutes) || other.retryIntervalMinutes == retryIntervalMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,retryLimit,retryIntervalMinutes,createdAt,updatedAt);

@override
String toString() {
  return 'QueueSettings(id: $id, tenantId: $tenantId, retryLimit: $retryLimit, retryIntervalMinutes: $retryIntervalMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QueueSettingsCopyWith<$Res> implements $QueueSettingsCopyWith<$Res> {
  factory _$QueueSettingsCopyWith(_QueueSettings value, $Res Function(_QueueSettings) _then) = __$QueueSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, int retryLimit, int retryIntervalMinutes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$QueueSettingsCopyWithImpl<$Res>
    implements _$QueueSettingsCopyWith<$Res> {
  __$QueueSettingsCopyWithImpl(this._self, this._then);

  final _QueueSettings _self;
  final $Res Function(_QueueSettings) _then;

/// Create a copy of QueueSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? retryLimit = null,Object? retryIntervalMinutes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_QueueSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,retryLimit: null == retryLimit ? _self.retryLimit : retryLimit // ignore: cast_nullable_to_non_nullable
as int,retryIntervalMinutes: null == retryIntervalMinutes ? _self.retryIntervalMinutes : retryIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
