// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactAttempt {

 String get id; String get tenantId; String get claimId; String get attemptedBy; DateTime get attemptedAt; ContactMethod get method; ContactOutcome get outcome; String? get notes;
/// Create a copy of ContactAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactAttemptCopyWith<ContactAttempt> get copyWith => _$ContactAttemptCopyWithImpl<ContactAttempt>(this as ContactAttempt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.attemptedBy, attemptedBy) || other.attemptedBy == attemptedBy)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,claimId,attemptedBy,attemptedAt,method,outcome,notes);

@override
String toString() {
  return 'ContactAttempt(id: $id, tenantId: $tenantId, claimId: $claimId, attemptedBy: $attemptedBy, attemptedAt: $attemptedAt, method: $method, outcome: $outcome, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ContactAttemptCopyWith<$Res>  {
  factory $ContactAttemptCopyWith(ContactAttempt value, $Res Function(ContactAttempt) _then) = _$ContactAttemptCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String claimId, String attemptedBy, DateTime attemptedAt, ContactMethod method, ContactOutcome outcome, String? notes
});




}
/// @nodoc
class _$ContactAttemptCopyWithImpl<$Res>
    implements $ContactAttemptCopyWith<$Res> {
  _$ContactAttemptCopyWithImpl(this._self, this._then);

  final ContactAttempt _self;
  final $Res Function(ContactAttempt) _then;

/// Create a copy of ContactAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? claimId = null,Object? attemptedBy = null,Object? attemptedAt = null,Object? method = null,Object? outcome = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,attemptedBy: null == attemptedBy ? _self.attemptedBy : attemptedBy // ignore: cast_nullable_to_non_nullable
as String,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ContactMethod,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ContactOutcome,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactAttempt].
extension ContactAttemptPatterns on ContactAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactAttempt value)  $default,){
final _that = this;
switch (_that) {
case _ContactAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _ContactAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimId,  String attemptedBy,  DateTime attemptedAt,  ContactMethod method,  ContactOutcome outcome,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactAttempt() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimId,_that.attemptedBy,_that.attemptedAt,_that.method,_that.outcome,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimId,  String attemptedBy,  DateTime attemptedAt,  ContactMethod method,  ContactOutcome outcome,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ContactAttempt():
return $default(_that.id,_that.tenantId,_that.claimId,_that.attemptedBy,_that.attemptedAt,_that.method,_that.outcome,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String claimId,  String attemptedBy,  DateTime attemptedAt,  ContactMethod method,  ContactOutcome outcome,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ContactAttempt() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimId,_that.attemptedBy,_that.attemptedAt,_that.method,_that.outcome,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _ContactAttempt extends ContactAttempt {
  const _ContactAttempt({required this.id, required this.tenantId, required this.claimId, required this.attemptedBy, required this.attemptedAt, required this.method, required this.outcome, this.notes}): super._();
  

@override final  String id;
@override final  String tenantId;
@override final  String claimId;
@override final  String attemptedBy;
@override final  DateTime attemptedAt;
@override final  ContactMethod method;
@override final  ContactOutcome outcome;
@override final  String? notes;

/// Create a copy of ContactAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactAttemptCopyWith<_ContactAttempt> get copyWith => __$ContactAttemptCopyWithImpl<_ContactAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.attemptedBy, attemptedBy) || other.attemptedBy == attemptedBy)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,id,tenantId,claimId,attemptedBy,attemptedAt,method,outcome,notes);

@override
String toString() {
  return 'ContactAttempt(id: $id, tenantId: $tenantId, claimId: $claimId, attemptedBy: $attemptedBy, attemptedAt: $attemptedAt, method: $method, outcome: $outcome, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ContactAttemptCopyWith<$Res> implements $ContactAttemptCopyWith<$Res> {
  factory _$ContactAttemptCopyWith(_ContactAttempt value, $Res Function(_ContactAttempt) _then) = __$ContactAttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String claimId, String attemptedBy, DateTime attemptedAt, ContactMethod method, ContactOutcome outcome, String? notes
});




}
/// @nodoc
class __$ContactAttemptCopyWithImpl<$Res>
    implements _$ContactAttemptCopyWith<$Res> {
  __$ContactAttemptCopyWithImpl(this._self, this._then);

  final _ContactAttempt _self;
  final $Res Function(_ContactAttempt) _then;

/// Create a copy of ContactAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? claimId = null,Object? attemptedBy = null,Object? attemptedAt = null,Object? method = null,Object? outcome = null,Object? notes = freezed,}) {
  return _then(_ContactAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,attemptedBy: null == attemptedBy ? _self.attemptedBy : attemptedBy // ignore: cast_nullable_to_non_nullable
as String,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ContactMethod,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ContactOutcome,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
