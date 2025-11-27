// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_status_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimStatusChange {

 String get id; String get tenantId; String get claimId; ClaimStatus get fromStatus; ClaimStatus get toStatus; String? get changedBy; DateTime get changedAt; String? get reason;
/// Create a copy of ClaimStatusChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimStatusChangeCopyWith<ClaimStatusChange> get copyWith => _$ClaimStatusChangeCopyWithImpl<ClaimStatusChange>(this as ClaimStatusChange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimStatusChange&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,claimId,fromStatus,toStatus,changedBy,changedAt,reason);

@override
String toString() {
  return 'ClaimStatusChange(id: $id, tenantId: $tenantId, claimId: $claimId, fromStatus: $fromStatus, toStatus: $toStatus, changedBy: $changedBy, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ClaimStatusChangeCopyWith<$Res>  {
  factory $ClaimStatusChangeCopyWith(ClaimStatusChange value, $Res Function(ClaimStatusChange) _then) = _$ClaimStatusChangeCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String claimId, ClaimStatus fromStatus, ClaimStatus toStatus, String? changedBy, DateTime changedAt, String? reason
});




}
/// @nodoc
class _$ClaimStatusChangeCopyWithImpl<$Res>
    implements $ClaimStatusChangeCopyWith<$Res> {
  _$ClaimStatusChangeCopyWithImpl(this._self, this._then);

  final ClaimStatusChange _self;
  final $Res Function(ClaimStatusChange) _then;

/// Create a copy of ClaimStatusChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? claimId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedBy = freezed,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ClaimStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ClaimStatus,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimStatusChange].
extension ClaimStatusChangePatterns on ClaimStatusChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimStatusChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimStatusChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimStatusChange value)  $default,){
final _that = this;
switch (_that) {
case _ClaimStatusChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimStatusChange value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimStatusChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimId,  ClaimStatus fromStatus,  ClaimStatus toStatus,  String? changedBy,  DateTime changedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimStatusChange() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimId,_that.fromStatus,_that.toStatus,_that.changedBy,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimId,  ClaimStatus fromStatus,  ClaimStatus toStatus,  String? changedBy,  DateTime changedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ClaimStatusChange():
return $default(_that.id,_that.tenantId,_that.claimId,_that.fromStatus,_that.toStatus,_that.changedBy,_that.changedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String claimId,  ClaimStatus fromStatus,  ClaimStatus toStatus,  String? changedBy,  DateTime changedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ClaimStatusChange() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimId,_that.fromStatus,_that.toStatus,_that.changedBy,_that.changedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimStatusChange extends ClaimStatusChange {
  const _ClaimStatusChange({required this.id, required this.tenantId, required this.claimId, required this.fromStatus, required this.toStatus, this.changedBy, required this.changedAt, this.reason}): super._();
  

@override final  String id;
@override final  String tenantId;
@override final  String claimId;
@override final  ClaimStatus fromStatus;
@override final  ClaimStatus toStatus;
@override final  String? changedBy;
@override final  DateTime changedAt;
@override final  String? reason;

/// Create a copy of ClaimStatusChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimStatusChangeCopyWith<_ClaimStatusChange> get copyWith => __$ClaimStatusChangeCopyWithImpl<_ClaimStatusChange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimStatusChange&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,claimId,fromStatus,toStatus,changedBy,changedAt,reason);

@override
String toString() {
  return 'ClaimStatusChange(id: $id, tenantId: $tenantId, claimId: $claimId, fromStatus: $fromStatus, toStatus: $toStatus, changedBy: $changedBy, changedAt: $changedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ClaimStatusChangeCopyWith<$Res> implements $ClaimStatusChangeCopyWith<$Res> {
  factory _$ClaimStatusChangeCopyWith(_ClaimStatusChange value, $Res Function(_ClaimStatusChange) _then) = __$ClaimStatusChangeCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String claimId, ClaimStatus fromStatus, ClaimStatus toStatus, String? changedBy, DateTime changedAt, String? reason
});




}
/// @nodoc
class __$ClaimStatusChangeCopyWithImpl<$Res>
    implements _$ClaimStatusChangeCopyWith<$Res> {
  __$ClaimStatusChangeCopyWithImpl(this._self, this._then);

  final _ClaimStatusChange _self;
  final $Res Function(_ClaimStatusChange) _then;

/// Create a copy of ClaimStatusChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? claimId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedBy = freezed,Object? changedAt = null,Object? reason = freezed,}) {
  return _then(_ClaimStatusChange(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as ClaimStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as ClaimStatus,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
