// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimSummary {

 String get claimId; String get claimNumber; String get clientFullName; String get primaryPhone; String get insurerName; ClaimStatus get status; PriorityLevel get priority; DateTime get slaStartedAt; Duration get elapsed; DateTime? get latestContactAt; String? get latestContactOutcome; Duration get slaTarget; int get attemptCount; Duration get retryInterval; DateTime? get nextRetryAt; bool get readyForRetry; String get addressShort;
/// Create a copy of ClaimSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimSummaryCopyWith<ClaimSummary> get copyWith => _$ClaimSummaryCopyWithImpl<ClaimSummary>(this as ClaimSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimSummary&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.clientFullName, clientFullName) || other.clientFullName == clientFullName)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.slaStartedAt, slaStartedAt) || other.slaStartedAt == slaStartedAt)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.latestContactAt, latestContactAt) || other.latestContactAt == latestContactAt)&&(identical(other.latestContactOutcome, latestContactOutcome) || other.latestContactOutcome == latestContactOutcome)&&(identical(other.slaTarget, slaTarget) || other.slaTarget == slaTarget)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.retryInterval, retryInterval) || other.retryInterval == retryInterval)&&(identical(other.nextRetryAt, nextRetryAt) || other.nextRetryAt == nextRetryAt)&&(identical(other.readyForRetry, readyForRetry) || other.readyForRetry == readyForRetry)&&(identical(other.addressShort, addressShort) || other.addressShort == addressShort));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,clientFullName,primaryPhone,insurerName,status,priority,slaStartedAt,elapsed,latestContactAt,latestContactOutcome,slaTarget,attemptCount,retryInterval,nextRetryAt,readyForRetry,addressShort);

@override
String toString() {
  return 'ClaimSummary(claimId: $claimId, claimNumber: $claimNumber, clientFullName: $clientFullName, primaryPhone: $primaryPhone, insurerName: $insurerName, status: $status, priority: $priority, slaStartedAt: $slaStartedAt, elapsed: $elapsed, latestContactAt: $latestContactAt, latestContactOutcome: $latestContactOutcome, slaTarget: $slaTarget, attemptCount: $attemptCount, retryInterval: $retryInterval, nextRetryAt: $nextRetryAt, readyForRetry: $readyForRetry, addressShort: $addressShort)';
}


}

/// @nodoc
abstract mixin class $ClaimSummaryCopyWith<$Res>  {
  factory $ClaimSummaryCopyWith(ClaimSummary value, $Res Function(ClaimSummary) _then) = _$ClaimSummaryCopyWithImpl;
@useResult
$Res call({
 String claimId, String claimNumber, String clientFullName, String primaryPhone, String insurerName, ClaimStatus status, PriorityLevel priority, DateTime slaStartedAt, Duration elapsed, DateTime? latestContactAt, String? latestContactOutcome, Duration slaTarget, int attemptCount, Duration retryInterval, DateTime? nextRetryAt, bool readyForRetry, String addressShort
});




}
/// @nodoc
class _$ClaimSummaryCopyWithImpl<$Res>
    implements $ClaimSummaryCopyWith<$Res> {
  _$ClaimSummaryCopyWithImpl(this._self, this._then);

  final ClaimSummary _self;
  final $Res Function(ClaimSummary) _then;

/// Create a copy of ClaimSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claimId = null,Object? claimNumber = null,Object? clientFullName = null,Object? primaryPhone = null,Object? insurerName = null,Object? status = null,Object? priority = null,Object? slaStartedAt = null,Object? elapsed = null,Object? latestContactAt = freezed,Object? latestContactOutcome = freezed,Object? slaTarget = null,Object? attemptCount = null,Object? retryInterval = null,Object? nextRetryAt = freezed,Object? readyForRetry = null,Object? addressShort = null,}) {
  return _then(_self.copyWith(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,clientFullName: null == clientFullName ? _self.clientFullName : clientFullName // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,slaStartedAt: null == slaStartedAt ? _self.slaStartedAt : slaStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,latestContactAt: freezed == latestContactAt ? _self.latestContactAt : latestContactAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestContactOutcome: freezed == latestContactOutcome ? _self.latestContactOutcome : latestContactOutcome // ignore: cast_nullable_to_non_nullable
as String?,slaTarget: null == slaTarget ? _self.slaTarget : slaTarget // ignore: cast_nullable_to_non_nullable
as Duration,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,retryInterval: null == retryInterval ? _self.retryInterval : retryInterval // ignore: cast_nullable_to_non_nullable
as Duration,nextRetryAt: freezed == nextRetryAt ? _self.nextRetryAt : nextRetryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyForRetry: null == readyForRetry ? _self.readyForRetry : readyForRetry // ignore: cast_nullable_to_non_nullable
as bool,addressShort: null == addressShort ? _self.addressShort : addressShort // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimSummary].
extension ClaimSummaryPatterns on ClaimSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimSummary value)  $default,){
final _that = this;
switch (_that) {
case _ClaimSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  String clientFullName,  String primaryPhone,  String insurerName,  ClaimStatus status,  PriorityLevel priority,  DateTime slaStartedAt,  Duration elapsed,  DateTime? latestContactAt,  String? latestContactOutcome,  Duration slaTarget,  int attemptCount,  Duration retryInterval,  DateTime? nextRetryAt,  bool readyForRetry,  String addressShort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimSummary() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.clientFullName,_that.primaryPhone,_that.insurerName,_that.status,_that.priority,_that.slaStartedAt,_that.elapsed,_that.latestContactAt,_that.latestContactOutcome,_that.slaTarget,_that.attemptCount,_that.retryInterval,_that.nextRetryAt,_that.readyForRetry,_that.addressShort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  String clientFullName,  String primaryPhone,  String insurerName,  ClaimStatus status,  PriorityLevel priority,  DateTime slaStartedAt,  Duration elapsed,  DateTime? latestContactAt,  String? latestContactOutcome,  Duration slaTarget,  int attemptCount,  Duration retryInterval,  DateTime? nextRetryAt,  bool readyForRetry,  String addressShort)  $default,) {final _that = this;
switch (_that) {
case _ClaimSummary():
return $default(_that.claimId,_that.claimNumber,_that.clientFullName,_that.primaryPhone,_that.insurerName,_that.status,_that.priority,_that.slaStartedAt,_that.elapsed,_that.latestContactAt,_that.latestContactOutcome,_that.slaTarget,_that.attemptCount,_that.retryInterval,_that.nextRetryAt,_that.readyForRetry,_that.addressShort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String claimId,  String claimNumber,  String clientFullName,  String primaryPhone,  String insurerName,  ClaimStatus status,  PriorityLevel priority,  DateTime slaStartedAt,  Duration elapsed,  DateTime? latestContactAt,  String? latestContactOutcome,  Duration slaTarget,  int attemptCount,  Duration retryInterval,  DateTime? nextRetryAt,  bool readyForRetry,  String addressShort)?  $default,) {final _that = this;
switch (_that) {
case _ClaimSummary() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.clientFullName,_that.primaryPhone,_that.insurerName,_that.status,_that.priority,_that.slaStartedAt,_that.elapsed,_that.latestContactAt,_that.latestContactOutcome,_that.slaTarget,_that.attemptCount,_that.retryInterval,_that.nextRetryAt,_that.readyForRetry,_that.addressShort);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimSummary extends ClaimSummary {
  const _ClaimSummary({required this.claimId, required this.claimNumber, required this.clientFullName, required this.primaryPhone, required this.insurerName, required this.status, required this.priority, required this.slaStartedAt, required this.elapsed, this.latestContactAt, this.latestContactOutcome, required this.slaTarget, required this.attemptCount, required this.retryInterval, this.nextRetryAt, required this.readyForRetry, required this.addressShort}): super._();
  

@override final  String claimId;
@override final  String claimNumber;
@override final  String clientFullName;
@override final  String primaryPhone;
@override final  String insurerName;
@override final  ClaimStatus status;
@override final  PriorityLevel priority;
@override final  DateTime slaStartedAt;
@override final  Duration elapsed;
@override final  DateTime? latestContactAt;
@override final  String? latestContactOutcome;
@override final  Duration slaTarget;
@override final  int attemptCount;
@override final  Duration retryInterval;
@override final  DateTime? nextRetryAt;
@override final  bool readyForRetry;
@override final  String addressShort;

/// Create a copy of ClaimSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimSummaryCopyWith<_ClaimSummary> get copyWith => __$ClaimSummaryCopyWithImpl<_ClaimSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimSummary&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.clientFullName, clientFullName) || other.clientFullName == clientFullName)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.slaStartedAt, slaStartedAt) || other.slaStartedAt == slaStartedAt)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.latestContactAt, latestContactAt) || other.latestContactAt == latestContactAt)&&(identical(other.latestContactOutcome, latestContactOutcome) || other.latestContactOutcome == latestContactOutcome)&&(identical(other.slaTarget, slaTarget) || other.slaTarget == slaTarget)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.retryInterval, retryInterval) || other.retryInterval == retryInterval)&&(identical(other.nextRetryAt, nextRetryAt) || other.nextRetryAt == nextRetryAt)&&(identical(other.readyForRetry, readyForRetry) || other.readyForRetry == readyForRetry)&&(identical(other.addressShort, addressShort) || other.addressShort == addressShort));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,clientFullName,primaryPhone,insurerName,status,priority,slaStartedAt,elapsed,latestContactAt,latestContactOutcome,slaTarget,attemptCount,retryInterval,nextRetryAt,readyForRetry,addressShort);

@override
String toString() {
  return 'ClaimSummary(claimId: $claimId, claimNumber: $claimNumber, clientFullName: $clientFullName, primaryPhone: $primaryPhone, insurerName: $insurerName, status: $status, priority: $priority, slaStartedAt: $slaStartedAt, elapsed: $elapsed, latestContactAt: $latestContactAt, latestContactOutcome: $latestContactOutcome, slaTarget: $slaTarget, attemptCount: $attemptCount, retryInterval: $retryInterval, nextRetryAt: $nextRetryAt, readyForRetry: $readyForRetry, addressShort: $addressShort)';
}


}

/// @nodoc
abstract mixin class _$ClaimSummaryCopyWith<$Res> implements $ClaimSummaryCopyWith<$Res> {
  factory _$ClaimSummaryCopyWith(_ClaimSummary value, $Res Function(_ClaimSummary) _then) = __$ClaimSummaryCopyWithImpl;
@override @useResult
$Res call({
 String claimId, String claimNumber, String clientFullName, String primaryPhone, String insurerName, ClaimStatus status, PriorityLevel priority, DateTime slaStartedAt, Duration elapsed, DateTime? latestContactAt, String? latestContactOutcome, Duration slaTarget, int attemptCount, Duration retryInterval, DateTime? nextRetryAt, bool readyForRetry, String addressShort
});




}
/// @nodoc
class __$ClaimSummaryCopyWithImpl<$Res>
    implements _$ClaimSummaryCopyWith<$Res> {
  __$ClaimSummaryCopyWithImpl(this._self, this._then);

  final _ClaimSummary _self;
  final $Res Function(_ClaimSummary) _then;

/// Create a copy of ClaimSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claimId = null,Object? claimNumber = null,Object? clientFullName = null,Object? primaryPhone = null,Object? insurerName = null,Object? status = null,Object? priority = null,Object? slaStartedAt = null,Object? elapsed = null,Object? latestContactAt = freezed,Object? latestContactOutcome = freezed,Object? slaTarget = null,Object? attemptCount = null,Object? retryInterval = null,Object? nextRetryAt = freezed,Object? readyForRetry = null,Object? addressShort = null,}) {
  return _then(_ClaimSummary(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,clientFullName: null == clientFullName ? _self.clientFullName : clientFullName // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,slaStartedAt: null == slaStartedAt ? _self.slaStartedAt : slaStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,latestContactAt: freezed == latestContactAt ? _self.latestContactAt : latestContactAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latestContactOutcome: freezed == latestContactOutcome ? _self.latestContactOutcome : latestContactOutcome // ignore: cast_nullable_to_non_nullable
as String?,slaTarget: null == slaTarget ? _self.slaTarget : slaTarget // ignore: cast_nullable_to_non_nullable
as Duration,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,retryInterval: null == retryInterval ? _self.retryInterval : retryInterval // ignore: cast_nullable_to_non_nullable
as Duration,nextRetryAt: freezed == nextRetryAt ? _self.nextRetryAt : nextRetryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyForRetry: null == readyForRetry ? _self.readyForRetry : readyForRetry // ignore: cast_nullable_to_non_nullable
as bool,addressShort: null == addressShort ? _self.addressShort : addressShort // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
