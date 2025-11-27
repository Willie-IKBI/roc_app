// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sla_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SlaRule {

 String get id; String get tenantId; int get timeToFirstContactMinutes; bool get breachHighlight; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SlaRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlaRuleCopyWith<SlaRule> get copyWith => _$SlaRuleCopyWithImpl<SlaRule>(this as SlaRule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlaRule&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.timeToFirstContactMinutes, timeToFirstContactMinutes) || other.timeToFirstContactMinutes == timeToFirstContactMinutes)&&(identical(other.breachHighlight, breachHighlight) || other.breachHighlight == breachHighlight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,timeToFirstContactMinutes,breachHighlight,createdAt,updatedAt);

@override
String toString() {
  return 'SlaRule(id: $id, tenantId: $tenantId, timeToFirstContactMinutes: $timeToFirstContactMinutes, breachHighlight: $breachHighlight, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SlaRuleCopyWith<$Res>  {
  factory $SlaRuleCopyWith(SlaRule value, $Res Function(SlaRule) _then) = _$SlaRuleCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, int timeToFirstContactMinutes, bool breachHighlight, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SlaRuleCopyWithImpl<$Res>
    implements $SlaRuleCopyWith<$Res> {
  _$SlaRuleCopyWithImpl(this._self, this._then);

  final SlaRule _self;
  final $Res Function(SlaRule) _then;

/// Create a copy of SlaRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? timeToFirstContactMinutes = null,Object? breachHighlight = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,timeToFirstContactMinutes: null == timeToFirstContactMinutes ? _self.timeToFirstContactMinutes : timeToFirstContactMinutes // ignore: cast_nullable_to_non_nullable
as int,breachHighlight: null == breachHighlight ? _self.breachHighlight : breachHighlight // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SlaRule].
extension SlaRulePatterns on SlaRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlaRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlaRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlaRule value)  $default,){
final _that = this;
switch (_that) {
case _SlaRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlaRule value)?  $default,){
final _that = this;
switch (_that) {
case _SlaRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  int timeToFirstContactMinutes,  bool breachHighlight,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlaRule() when $default != null:
return $default(_that.id,_that.tenantId,_that.timeToFirstContactMinutes,_that.breachHighlight,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  int timeToFirstContactMinutes,  bool breachHighlight,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SlaRule():
return $default(_that.id,_that.tenantId,_that.timeToFirstContactMinutes,_that.breachHighlight,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  int timeToFirstContactMinutes,  bool breachHighlight,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SlaRule() when $default != null:
return $default(_that.id,_that.tenantId,_that.timeToFirstContactMinutes,_that.breachHighlight,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SlaRule implements SlaRule {
  const _SlaRule({required this.id, required this.tenantId, required this.timeToFirstContactMinutes, required this.breachHighlight, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String tenantId;
@override final  int timeToFirstContactMinutes;
@override final  bool breachHighlight;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SlaRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlaRuleCopyWith<_SlaRule> get copyWith => __$SlaRuleCopyWithImpl<_SlaRule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlaRule&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.timeToFirstContactMinutes, timeToFirstContactMinutes) || other.timeToFirstContactMinutes == timeToFirstContactMinutes)&&(identical(other.breachHighlight, breachHighlight) || other.breachHighlight == breachHighlight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,timeToFirstContactMinutes,breachHighlight,createdAt,updatedAt);

@override
String toString() {
  return 'SlaRule(id: $id, tenantId: $tenantId, timeToFirstContactMinutes: $timeToFirstContactMinutes, breachHighlight: $breachHighlight, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SlaRuleCopyWith<$Res> implements $SlaRuleCopyWith<$Res> {
  factory _$SlaRuleCopyWith(_SlaRule value, $Res Function(_SlaRule) _then) = __$SlaRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, int timeToFirstContactMinutes, bool breachHighlight, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SlaRuleCopyWithImpl<$Res>
    implements _$SlaRuleCopyWith<$Res> {
  __$SlaRuleCopyWithImpl(this._self, this._then);

  final _SlaRule _self;
  final $Res Function(_SlaRule) _then;

/// Create a copy of SlaRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? timeToFirstContactMinutes = null,Object? breachHighlight = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SlaRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,timeToFirstContactMinutes: null == timeToFirstContactMinutes ? _self.timeToFirstContactMinutes : timeToFirstContactMinutes // ignore: cast_nullable_to_non_nullable
as int,breachHighlight: null == breachHighlight ? _self.breachHighlight : breachHighlight // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
