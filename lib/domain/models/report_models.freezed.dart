// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgentPerformanceReport {

 String get agentId; String get agentName; int get claimsHandled; double? get averageMinutesToFirstContact; double get slaComplianceRate; int get claimsClosed; double? get averageResolutionTimeMinutes; double get contactSuccessRate;
/// Create a copy of AgentPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentPerformanceReportCopyWith<AgentPerformanceReport> get copyWith => _$AgentPerformanceReportCopyWithImpl<AgentPerformanceReport>(this as AgentPerformanceReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentPerformanceReport&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.claimsHandled, claimsHandled) || other.claimsHandled == claimsHandled)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.slaComplianceRate, slaComplianceRate) || other.slaComplianceRate == slaComplianceRate)&&(identical(other.claimsClosed, claimsClosed) || other.claimsClosed == claimsClosed)&&(identical(other.averageResolutionTimeMinutes, averageResolutionTimeMinutes) || other.averageResolutionTimeMinutes == averageResolutionTimeMinutes)&&(identical(other.contactSuccessRate, contactSuccessRate) || other.contactSuccessRate == contactSuccessRate));
}


@override
int get hashCode => Object.hash(runtimeType,agentId,agentName,claimsHandled,averageMinutesToFirstContact,slaComplianceRate,claimsClosed,averageResolutionTimeMinutes,contactSuccessRate);

@override
String toString() {
  return 'AgentPerformanceReport(agentId: $agentId, agentName: $agentName, claimsHandled: $claimsHandled, averageMinutesToFirstContact: $averageMinutesToFirstContact, slaComplianceRate: $slaComplianceRate, claimsClosed: $claimsClosed, averageResolutionTimeMinutes: $averageResolutionTimeMinutes, contactSuccessRate: $contactSuccessRate)';
}


}

/// @nodoc
abstract mixin class $AgentPerformanceReportCopyWith<$Res>  {
  factory $AgentPerformanceReportCopyWith(AgentPerformanceReport value, $Res Function(AgentPerformanceReport) _then) = _$AgentPerformanceReportCopyWithImpl;
@useResult
$Res call({
 String agentId, String agentName, int claimsHandled, double? averageMinutesToFirstContact, double slaComplianceRate, int claimsClosed, double? averageResolutionTimeMinutes, double contactSuccessRate
});




}
/// @nodoc
class _$AgentPerformanceReportCopyWithImpl<$Res>
    implements $AgentPerformanceReportCopyWith<$Res> {
  _$AgentPerformanceReportCopyWithImpl(this._self, this._then);

  final AgentPerformanceReport _self;
  final $Res Function(AgentPerformanceReport) _then;

/// Create a copy of AgentPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentId = null,Object? agentName = null,Object? claimsHandled = null,Object? averageMinutesToFirstContact = freezed,Object? slaComplianceRate = null,Object? claimsClosed = null,Object? averageResolutionTimeMinutes = freezed,Object? contactSuccessRate = null,}) {
  return _then(_self.copyWith(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,agentName: null == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String,claimsHandled: null == claimsHandled ? _self.claimsHandled : claimsHandled // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,slaComplianceRate: null == slaComplianceRate ? _self.slaComplianceRate : slaComplianceRate // ignore: cast_nullable_to_non_nullable
as double,claimsClosed: null == claimsClosed ? _self.claimsClosed : claimsClosed // ignore: cast_nullable_to_non_nullable
as int,averageResolutionTimeMinutes: freezed == averageResolutionTimeMinutes ? _self.averageResolutionTimeMinutes : averageResolutionTimeMinutes // ignore: cast_nullable_to_non_nullable
as double?,contactSuccessRate: null == contactSuccessRate ? _self.contactSuccessRate : contactSuccessRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentPerformanceReport].
extension AgentPerformanceReportPatterns on AgentPerformanceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentPerformanceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentPerformanceReport value)  $default,){
final _that = this;
switch (_that) {
case _AgentPerformanceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentPerformanceReport value)?  $default,){
final _that = this;
switch (_that) {
case _AgentPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentId,  String agentName,  int claimsHandled,  double? averageMinutesToFirstContact,  double slaComplianceRate,  int claimsClosed,  double? averageResolutionTimeMinutes,  double contactSuccessRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentPerformanceReport() when $default != null:
return $default(_that.agentId,_that.agentName,_that.claimsHandled,_that.averageMinutesToFirstContact,_that.slaComplianceRate,_that.claimsClosed,_that.averageResolutionTimeMinutes,_that.contactSuccessRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentId,  String agentName,  int claimsHandled,  double? averageMinutesToFirstContact,  double slaComplianceRate,  int claimsClosed,  double? averageResolutionTimeMinutes,  double contactSuccessRate)  $default,) {final _that = this;
switch (_that) {
case _AgentPerformanceReport():
return $default(_that.agentId,_that.agentName,_that.claimsHandled,_that.averageMinutesToFirstContact,_that.slaComplianceRate,_that.claimsClosed,_that.averageResolutionTimeMinutes,_that.contactSuccessRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentId,  String agentName,  int claimsHandled,  double? averageMinutesToFirstContact,  double slaComplianceRate,  int claimsClosed,  double? averageResolutionTimeMinutes,  double contactSuccessRate)?  $default,) {final _that = this;
switch (_that) {
case _AgentPerformanceReport() when $default != null:
return $default(_that.agentId,_that.agentName,_that.claimsHandled,_that.averageMinutesToFirstContact,_that.slaComplianceRate,_that.claimsClosed,_that.averageResolutionTimeMinutes,_that.contactSuccessRate);case _:
  return null;

}
}

}

/// @nodoc


class _AgentPerformanceReport extends AgentPerformanceReport {
  const _AgentPerformanceReport({required this.agentId, required this.agentName, required this.claimsHandled, this.averageMinutesToFirstContact, required this.slaComplianceRate, required this.claimsClosed, this.averageResolutionTimeMinutes, required this.contactSuccessRate}): super._();
  

@override final  String agentId;
@override final  String agentName;
@override final  int claimsHandled;
@override final  double? averageMinutesToFirstContact;
@override final  double slaComplianceRate;
@override final  int claimsClosed;
@override final  double? averageResolutionTimeMinutes;
@override final  double contactSuccessRate;

/// Create a copy of AgentPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentPerformanceReportCopyWith<_AgentPerformanceReport> get copyWith => __$AgentPerformanceReportCopyWithImpl<_AgentPerformanceReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentPerformanceReport&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.agentName, agentName) || other.agentName == agentName)&&(identical(other.claimsHandled, claimsHandled) || other.claimsHandled == claimsHandled)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.slaComplianceRate, slaComplianceRate) || other.slaComplianceRate == slaComplianceRate)&&(identical(other.claimsClosed, claimsClosed) || other.claimsClosed == claimsClosed)&&(identical(other.averageResolutionTimeMinutes, averageResolutionTimeMinutes) || other.averageResolutionTimeMinutes == averageResolutionTimeMinutes)&&(identical(other.contactSuccessRate, contactSuccessRate) || other.contactSuccessRate == contactSuccessRate));
}


@override
int get hashCode => Object.hash(runtimeType,agentId,agentName,claimsHandled,averageMinutesToFirstContact,slaComplianceRate,claimsClosed,averageResolutionTimeMinutes,contactSuccessRate);

@override
String toString() {
  return 'AgentPerformanceReport(agentId: $agentId, agentName: $agentName, claimsHandled: $claimsHandled, averageMinutesToFirstContact: $averageMinutesToFirstContact, slaComplianceRate: $slaComplianceRate, claimsClosed: $claimsClosed, averageResolutionTimeMinutes: $averageResolutionTimeMinutes, contactSuccessRate: $contactSuccessRate)';
}


}

/// @nodoc
abstract mixin class _$AgentPerformanceReportCopyWith<$Res> implements $AgentPerformanceReportCopyWith<$Res> {
  factory _$AgentPerformanceReportCopyWith(_AgentPerformanceReport value, $Res Function(_AgentPerformanceReport) _then) = __$AgentPerformanceReportCopyWithImpl;
@override @useResult
$Res call({
 String agentId, String agentName, int claimsHandled, double? averageMinutesToFirstContact, double slaComplianceRate, int claimsClosed, double? averageResolutionTimeMinutes, double contactSuccessRate
});




}
/// @nodoc
class __$AgentPerformanceReportCopyWithImpl<$Res>
    implements _$AgentPerformanceReportCopyWith<$Res> {
  __$AgentPerformanceReportCopyWithImpl(this._self, this._then);

  final _AgentPerformanceReport _self;
  final $Res Function(_AgentPerformanceReport) _then;

/// Create a copy of AgentPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentId = null,Object? agentName = null,Object? claimsHandled = null,Object? averageMinutesToFirstContact = freezed,Object? slaComplianceRate = null,Object? claimsClosed = null,Object? averageResolutionTimeMinutes = freezed,Object? contactSuccessRate = null,}) {
  return _then(_AgentPerformanceReport(
agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,agentName: null == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String,claimsHandled: null == claimsHandled ? _self.claimsHandled : claimsHandled // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,slaComplianceRate: null == slaComplianceRate ? _self.slaComplianceRate : slaComplianceRate // ignore: cast_nullable_to_non_nullable
as double,claimsClosed: null == claimsClosed ? _self.claimsClosed : claimsClosed // ignore: cast_nullable_to_non_nullable
as int,averageResolutionTimeMinutes: freezed == averageResolutionTimeMinutes ? _self.averageResolutionTimeMinutes : averageResolutionTimeMinutes // ignore: cast_nullable_to_non_nullable
as double?,contactSuccessRate: null == contactSuccessRate ? _self.contactSuccessRate : contactSuccessRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$StatusDistributionReport {

 ClaimStatus get status; int get count; double get percentage; double? get averageTimeInStatusHours; int get stuckClaims;
/// Create a copy of StatusDistributionReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusDistributionReportCopyWith<StatusDistributionReport> get copyWith => _$StatusDistributionReportCopyWithImpl<StatusDistributionReport>(this as StatusDistributionReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusDistributionReport&&(identical(other.status, status) || other.status == status)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageTimeInStatusHours, averageTimeInStatusHours) || other.averageTimeInStatusHours == averageTimeInStatusHours)&&(identical(other.stuckClaims, stuckClaims) || other.stuckClaims == stuckClaims));
}


@override
int get hashCode => Object.hash(runtimeType,status,count,percentage,averageTimeInStatusHours,stuckClaims);

@override
String toString() {
  return 'StatusDistributionReport(status: $status, count: $count, percentage: $percentage, averageTimeInStatusHours: $averageTimeInStatusHours, stuckClaims: $stuckClaims)';
}


}

/// @nodoc
abstract mixin class $StatusDistributionReportCopyWith<$Res>  {
  factory $StatusDistributionReportCopyWith(StatusDistributionReport value, $Res Function(StatusDistributionReport) _then) = _$StatusDistributionReportCopyWithImpl;
@useResult
$Res call({
 ClaimStatus status, int count, double percentage, double? averageTimeInStatusHours, int stuckClaims
});




}
/// @nodoc
class _$StatusDistributionReportCopyWithImpl<$Res>
    implements $StatusDistributionReportCopyWith<$Res> {
  _$StatusDistributionReportCopyWithImpl(this._self, this._then);

  final StatusDistributionReport _self;
  final $Res Function(StatusDistributionReport) _then;

/// Create a copy of StatusDistributionReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? count = null,Object? percentage = null,Object? averageTimeInStatusHours = freezed,Object? stuckClaims = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageTimeInStatusHours: freezed == averageTimeInStatusHours ? _self.averageTimeInStatusHours : averageTimeInStatusHours // ignore: cast_nullable_to_non_nullable
as double?,stuckClaims: null == stuckClaims ? _self.stuckClaims : stuckClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusDistributionReport].
extension StatusDistributionReportPatterns on StatusDistributionReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusDistributionReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusDistributionReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusDistributionReport value)  $default,){
final _that = this;
switch (_that) {
case _StatusDistributionReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusDistributionReport value)?  $default,){
final _that = this;
switch (_that) {
case _StatusDistributionReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClaimStatus status,  int count,  double percentage,  double? averageTimeInStatusHours,  int stuckClaims)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusDistributionReport() when $default != null:
return $default(_that.status,_that.count,_that.percentage,_that.averageTimeInStatusHours,_that.stuckClaims);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClaimStatus status,  int count,  double percentage,  double? averageTimeInStatusHours,  int stuckClaims)  $default,) {final _that = this;
switch (_that) {
case _StatusDistributionReport():
return $default(_that.status,_that.count,_that.percentage,_that.averageTimeInStatusHours,_that.stuckClaims);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClaimStatus status,  int count,  double percentage,  double? averageTimeInStatusHours,  int stuckClaims)?  $default,) {final _that = this;
switch (_that) {
case _StatusDistributionReport() when $default != null:
return $default(_that.status,_that.count,_that.percentage,_that.averageTimeInStatusHours,_that.stuckClaims);case _:
  return null;

}
}

}

/// @nodoc


class _StatusDistributionReport extends StatusDistributionReport {
  const _StatusDistributionReport({required this.status, required this.count, required this.percentage, this.averageTimeInStatusHours, required this.stuckClaims}): super._();
  

@override final  ClaimStatus status;
@override final  int count;
@override final  double percentage;
@override final  double? averageTimeInStatusHours;
@override final  int stuckClaims;

/// Create a copy of StatusDistributionReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusDistributionReportCopyWith<_StatusDistributionReport> get copyWith => __$StatusDistributionReportCopyWithImpl<_StatusDistributionReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusDistributionReport&&(identical(other.status, status) || other.status == status)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageTimeInStatusHours, averageTimeInStatusHours) || other.averageTimeInStatusHours == averageTimeInStatusHours)&&(identical(other.stuckClaims, stuckClaims) || other.stuckClaims == stuckClaims));
}


@override
int get hashCode => Object.hash(runtimeType,status,count,percentage,averageTimeInStatusHours,stuckClaims);

@override
String toString() {
  return 'StatusDistributionReport(status: $status, count: $count, percentage: $percentage, averageTimeInStatusHours: $averageTimeInStatusHours, stuckClaims: $stuckClaims)';
}


}

/// @nodoc
abstract mixin class _$StatusDistributionReportCopyWith<$Res> implements $StatusDistributionReportCopyWith<$Res> {
  factory _$StatusDistributionReportCopyWith(_StatusDistributionReport value, $Res Function(_StatusDistributionReport) _then) = __$StatusDistributionReportCopyWithImpl;
@override @useResult
$Res call({
 ClaimStatus status, int count, double percentage, double? averageTimeInStatusHours, int stuckClaims
});




}
/// @nodoc
class __$StatusDistributionReportCopyWithImpl<$Res>
    implements _$StatusDistributionReportCopyWith<$Res> {
  __$StatusDistributionReportCopyWithImpl(this._self, this._then);

  final _StatusDistributionReport _self;
  final $Res Function(_StatusDistributionReport) _then;

/// Create a copy of StatusDistributionReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? count = null,Object? percentage = null,Object? averageTimeInStatusHours = freezed,Object? stuckClaims = null,}) {
  return _then(_StatusDistributionReport(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageTimeInStatusHours: freezed == averageTimeInStatusHours ? _self.averageTimeInStatusHours : averageTimeInStatusHours // ignore: cast_nullable_to_non_nullable
as double?,stuckClaims: null == stuckClaims ? _self.stuckClaims : stuckClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DamageCauseReport {

 DamageCause get cause; int get count; double get percentage; double? get averageResolutionTimeHours;
/// Create a copy of DamageCauseReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageCauseReportCopyWith<DamageCauseReport> get copyWith => _$DamageCauseReportCopyWithImpl<DamageCauseReport>(this as DamageCauseReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageCauseReport&&(identical(other.cause, cause) || other.cause == cause)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageResolutionTimeHours, averageResolutionTimeHours) || other.averageResolutionTimeHours == averageResolutionTimeHours));
}


@override
int get hashCode => Object.hash(runtimeType,cause,count,percentage,averageResolutionTimeHours);

@override
String toString() {
  return 'DamageCauseReport(cause: $cause, count: $count, percentage: $percentage, averageResolutionTimeHours: $averageResolutionTimeHours)';
}


}

/// @nodoc
abstract mixin class $DamageCauseReportCopyWith<$Res>  {
  factory $DamageCauseReportCopyWith(DamageCauseReport value, $Res Function(DamageCauseReport) _then) = _$DamageCauseReportCopyWithImpl;
@useResult
$Res call({
 DamageCause cause, int count, double percentage, double? averageResolutionTimeHours
});




}
/// @nodoc
class _$DamageCauseReportCopyWithImpl<$Res>
    implements $DamageCauseReportCopyWith<$Res> {
  _$DamageCauseReportCopyWithImpl(this._self, this._then);

  final DamageCauseReport _self;
  final $Res Function(DamageCauseReport) _then;

/// Create a copy of DamageCauseReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cause = null,Object? count = null,Object? percentage = null,Object? averageResolutionTimeHours = freezed,}) {
  return _then(_self.copyWith(
cause: null == cause ? _self.cause : cause // ignore: cast_nullable_to_non_nullable
as DamageCause,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageResolutionTimeHours: freezed == averageResolutionTimeHours ? _self.averageResolutionTimeHours : averageResolutionTimeHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DamageCauseReport].
extension DamageCauseReportPatterns on DamageCauseReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageCauseReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageCauseReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageCauseReport value)  $default,){
final _that = this;
switch (_that) {
case _DamageCauseReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageCauseReport value)?  $default,){
final _that = this;
switch (_that) {
case _DamageCauseReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DamageCause cause,  int count,  double percentage,  double? averageResolutionTimeHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageCauseReport() when $default != null:
return $default(_that.cause,_that.count,_that.percentage,_that.averageResolutionTimeHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DamageCause cause,  int count,  double percentage,  double? averageResolutionTimeHours)  $default,) {final _that = this;
switch (_that) {
case _DamageCauseReport():
return $default(_that.cause,_that.count,_that.percentage,_that.averageResolutionTimeHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DamageCause cause,  int count,  double percentage,  double? averageResolutionTimeHours)?  $default,) {final _that = this;
switch (_that) {
case _DamageCauseReport() when $default != null:
return $default(_that.cause,_that.count,_that.percentage,_that.averageResolutionTimeHours);case _:
  return null;

}
}

}

/// @nodoc


class _DamageCauseReport extends DamageCauseReport {
  const _DamageCauseReport({required this.cause, required this.count, required this.percentage, this.averageResolutionTimeHours}): super._();
  

@override final  DamageCause cause;
@override final  int count;
@override final  double percentage;
@override final  double? averageResolutionTimeHours;

/// Create a copy of DamageCauseReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageCauseReportCopyWith<_DamageCauseReport> get copyWith => __$DamageCauseReportCopyWithImpl<_DamageCauseReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageCauseReport&&(identical(other.cause, cause) || other.cause == cause)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageResolutionTimeHours, averageResolutionTimeHours) || other.averageResolutionTimeHours == averageResolutionTimeHours));
}


@override
int get hashCode => Object.hash(runtimeType,cause,count,percentage,averageResolutionTimeHours);

@override
String toString() {
  return 'DamageCauseReport(cause: $cause, count: $count, percentage: $percentage, averageResolutionTimeHours: $averageResolutionTimeHours)';
}


}

/// @nodoc
abstract mixin class _$DamageCauseReportCopyWith<$Res> implements $DamageCauseReportCopyWith<$Res> {
  factory _$DamageCauseReportCopyWith(_DamageCauseReport value, $Res Function(_DamageCauseReport) _then) = __$DamageCauseReportCopyWithImpl;
@override @useResult
$Res call({
 DamageCause cause, int count, double percentage, double? averageResolutionTimeHours
});




}
/// @nodoc
class __$DamageCauseReportCopyWithImpl<$Res>
    implements _$DamageCauseReportCopyWith<$Res> {
  __$DamageCauseReportCopyWithImpl(this._self, this._then);

  final _DamageCauseReport _self;
  final $Res Function(_DamageCauseReport) _then;

/// Create a copy of DamageCauseReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cause = null,Object? count = null,Object? percentage = null,Object? averageResolutionTimeHours = freezed,}) {
  return _then(_DamageCauseReport(
cause: null == cause ? _self.cause : cause // ignore: cast_nullable_to_non_nullable
as DamageCause,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageResolutionTimeHours: freezed == averageResolutionTimeHours ? _self.averageResolutionTimeHours : averageResolutionTimeHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$GeographicReport {

 String? get province; String? get city; String? get suburb; int get claimCount; double get percentage; double? get averageLat; double? get averageLng;
/// Create a copy of GeographicReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeographicReportCopyWith<GeographicReport> get copyWith => _$GeographicReportCopyWithImpl<GeographicReport>(this as GeographicReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeographicReport&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageLat, averageLat) || other.averageLat == averageLat)&&(identical(other.averageLng, averageLng) || other.averageLng == averageLng));
}


@override
int get hashCode => Object.hash(runtimeType,province,city,suburb,claimCount,percentage,averageLat,averageLng);

@override
String toString() {
  return 'GeographicReport(province: $province, city: $city, suburb: $suburb, claimCount: $claimCount, percentage: $percentage, averageLat: $averageLat, averageLng: $averageLng)';
}


}

/// @nodoc
abstract mixin class $GeographicReportCopyWith<$Res>  {
  factory $GeographicReportCopyWith(GeographicReport value, $Res Function(GeographicReport) _then) = _$GeographicReportCopyWithImpl;
@useResult
$Res call({
 String? province, String? city, String? suburb, int claimCount, double percentage, double? averageLat, double? averageLng
});




}
/// @nodoc
class _$GeographicReportCopyWithImpl<$Res>
    implements $GeographicReportCopyWith<$Res> {
  _$GeographicReportCopyWithImpl(this._self, this._then);

  final GeographicReport _self;
  final $Res Function(GeographicReport) _then;

/// Create a copy of GeographicReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? province = freezed,Object? city = freezed,Object? suburb = freezed,Object? claimCount = null,Object? percentage = null,Object? averageLat = freezed,Object? averageLng = freezed,}) {
  return _then(_self.copyWith(
province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageLat: freezed == averageLat ? _self.averageLat : averageLat // ignore: cast_nullable_to_non_nullable
as double?,averageLng: freezed == averageLng ? _self.averageLng : averageLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeographicReport].
extension GeographicReportPatterns on GeographicReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeographicReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeographicReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeographicReport value)  $default,){
final _that = this;
switch (_that) {
case _GeographicReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeographicReport value)?  $default,){
final _that = this;
switch (_that) {
case _GeographicReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? province,  String? city,  String? suburb,  int claimCount,  double percentage,  double? averageLat,  double? averageLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeographicReport() when $default != null:
return $default(_that.province,_that.city,_that.suburb,_that.claimCount,_that.percentage,_that.averageLat,_that.averageLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? province,  String? city,  String? suburb,  int claimCount,  double percentage,  double? averageLat,  double? averageLng)  $default,) {final _that = this;
switch (_that) {
case _GeographicReport():
return $default(_that.province,_that.city,_that.suburb,_that.claimCount,_that.percentage,_that.averageLat,_that.averageLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? province,  String? city,  String? suburb,  int claimCount,  double percentage,  double? averageLat,  double? averageLng)?  $default,) {final _that = this;
switch (_that) {
case _GeographicReport() when $default != null:
return $default(_that.province,_that.city,_that.suburb,_that.claimCount,_that.percentage,_that.averageLat,_that.averageLng);case _:
  return null;

}
}

}

/// @nodoc


class _GeographicReport extends GeographicReport {
  const _GeographicReport({this.province, this.city, this.suburb, required this.claimCount, required this.percentage, this.averageLat, this.averageLng}): super._();
  

@override final  String? province;
@override final  String? city;
@override final  String? suburb;
@override final  int claimCount;
@override final  double percentage;
@override final  double? averageLat;
@override final  double? averageLng;

/// Create a copy of GeographicReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeographicReportCopyWith<_GeographicReport> get copyWith => __$GeographicReportCopyWithImpl<_GeographicReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeographicReport&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.suburb, suburb) || other.suburb == suburb)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageLat, averageLat) || other.averageLat == averageLat)&&(identical(other.averageLng, averageLng) || other.averageLng == averageLng));
}


@override
int get hashCode => Object.hash(runtimeType,province,city,suburb,claimCount,percentage,averageLat,averageLng);

@override
String toString() {
  return 'GeographicReport(province: $province, city: $city, suburb: $suburb, claimCount: $claimCount, percentage: $percentage, averageLat: $averageLat, averageLng: $averageLng)';
}


}

/// @nodoc
abstract mixin class _$GeographicReportCopyWith<$Res> implements $GeographicReportCopyWith<$Res> {
  factory _$GeographicReportCopyWith(_GeographicReport value, $Res Function(_GeographicReport) _then) = __$GeographicReportCopyWithImpl;
@override @useResult
$Res call({
 String? province, String? city, String? suburb, int claimCount, double percentage, double? averageLat, double? averageLng
});




}
/// @nodoc
class __$GeographicReportCopyWithImpl<$Res>
    implements _$GeographicReportCopyWith<$Res> {
  __$GeographicReportCopyWithImpl(this._self, this._then);

  final _GeographicReport _self;
  final $Res Function(_GeographicReport) _then;

/// Create a copy of GeographicReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? province = freezed,Object? city = freezed,Object? suburb = freezed,Object? claimCount = null,Object? percentage = null,Object? averageLat = freezed,Object? averageLng = freezed,}) {
  return _then(_GeographicReport(
province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,suburb: freezed == suburb ? _self.suburb : suburb // ignore: cast_nullable_to_non_nullable
as String?,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageLat: freezed == averageLat ? _self.averageLat : averageLat // ignore: cast_nullable_to_non_nullable
as double?,averageLng: freezed == averageLng ? _self.averageLng : averageLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$InsurerPerformanceReport {

 String get insurerId; String get insurerName; int get totalClaims; int get closedClaims; int get newClaims; int get scheduledClaims; int get inContactClaims; double? get averageResolutionTimeHours; int get uniqueDamageCauseCount; List<InsurerDamageCauseBreakdown> get damageCauseBreakdown; List<InsurerStatusBreakdown> get statusBreakdown;
/// Create a copy of InsurerPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsurerPerformanceReportCopyWith<InsurerPerformanceReport> get copyWith => _$InsurerPerformanceReportCopyWithImpl<InsurerPerformanceReport>(this as InsurerPerformanceReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsurerPerformanceReport&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.totalClaims, totalClaims) || other.totalClaims == totalClaims)&&(identical(other.closedClaims, closedClaims) || other.closedClaims == closedClaims)&&(identical(other.newClaims, newClaims) || other.newClaims == newClaims)&&(identical(other.scheduledClaims, scheduledClaims) || other.scheduledClaims == scheduledClaims)&&(identical(other.inContactClaims, inContactClaims) || other.inContactClaims == inContactClaims)&&(identical(other.averageResolutionTimeHours, averageResolutionTimeHours) || other.averageResolutionTimeHours == averageResolutionTimeHours)&&(identical(other.uniqueDamageCauseCount, uniqueDamageCauseCount) || other.uniqueDamageCauseCount == uniqueDamageCauseCount)&&const DeepCollectionEquality().equals(other.damageCauseBreakdown, damageCauseBreakdown)&&const DeepCollectionEquality().equals(other.statusBreakdown, statusBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,totalClaims,closedClaims,newClaims,scheduledClaims,inContactClaims,averageResolutionTimeHours,uniqueDamageCauseCount,const DeepCollectionEquality().hash(damageCauseBreakdown),const DeepCollectionEquality().hash(statusBreakdown));

@override
String toString() {
  return 'InsurerPerformanceReport(insurerId: $insurerId, insurerName: $insurerName, totalClaims: $totalClaims, closedClaims: $closedClaims, newClaims: $newClaims, scheduledClaims: $scheduledClaims, inContactClaims: $inContactClaims, averageResolutionTimeHours: $averageResolutionTimeHours, uniqueDamageCauseCount: $uniqueDamageCauseCount, damageCauseBreakdown: $damageCauseBreakdown, statusBreakdown: $statusBreakdown)';
}


}

/// @nodoc
abstract mixin class $InsurerPerformanceReportCopyWith<$Res>  {
  factory $InsurerPerformanceReportCopyWith(InsurerPerformanceReport value, $Res Function(InsurerPerformanceReport) _then) = _$InsurerPerformanceReportCopyWithImpl;
@useResult
$Res call({
 String insurerId, String insurerName, int totalClaims, int closedClaims, int newClaims, int scheduledClaims, int inContactClaims, double? averageResolutionTimeHours, int uniqueDamageCauseCount, List<InsurerDamageCauseBreakdown> damageCauseBreakdown, List<InsurerStatusBreakdown> statusBreakdown
});




}
/// @nodoc
class _$InsurerPerformanceReportCopyWithImpl<$Res>
    implements $InsurerPerformanceReportCopyWith<$Res> {
  _$InsurerPerformanceReportCopyWithImpl(this._self, this._then);

  final InsurerPerformanceReport _self;
  final $Res Function(InsurerPerformanceReport) _then;

/// Create a copy of InsurerPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? insurerId = null,Object? insurerName = null,Object? totalClaims = null,Object? closedClaims = null,Object? newClaims = null,Object? scheduledClaims = null,Object? inContactClaims = null,Object? averageResolutionTimeHours = freezed,Object? uniqueDamageCauseCount = null,Object? damageCauseBreakdown = null,Object? statusBreakdown = null,}) {
  return _then(_self.copyWith(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,totalClaims: null == totalClaims ? _self.totalClaims : totalClaims // ignore: cast_nullable_to_non_nullable
as int,closedClaims: null == closedClaims ? _self.closedClaims : closedClaims // ignore: cast_nullable_to_non_nullable
as int,newClaims: null == newClaims ? _self.newClaims : newClaims // ignore: cast_nullable_to_non_nullable
as int,scheduledClaims: null == scheduledClaims ? _self.scheduledClaims : scheduledClaims // ignore: cast_nullable_to_non_nullable
as int,inContactClaims: null == inContactClaims ? _self.inContactClaims : inContactClaims // ignore: cast_nullable_to_non_nullable
as int,averageResolutionTimeHours: freezed == averageResolutionTimeHours ? _self.averageResolutionTimeHours : averageResolutionTimeHours // ignore: cast_nullable_to_non_nullable
as double?,uniqueDamageCauseCount: null == uniqueDamageCauseCount ? _self.uniqueDamageCauseCount : uniqueDamageCauseCount // ignore: cast_nullable_to_non_nullable
as int,damageCauseBreakdown: null == damageCauseBreakdown ? _self.damageCauseBreakdown : damageCauseBreakdown // ignore: cast_nullable_to_non_nullable
as List<InsurerDamageCauseBreakdown>,statusBreakdown: null == statusBreakdown ? _self.statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as List<InsurerStatusBreakdown>,
  ));
}

}


/// Adds pattern-matching-related methods to [InsurerPerformanceReport].
extension InsurerPerformanceReportPatterns on InsurerPerformanceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsurerPerformanceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsurerPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsurerPerformanceReport value)  $default,){
final _that = this;
switch (_that) {
case _InsurerPerformanceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsurerPerformanceReport value)?  $default,){
final _that = this;
switch (_that) {
case _InsurerPerformanceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  int totalClaims,  int closedClaims,  int newClaims,  int scheduledClaims,  int inContactClaims,  double? averageResolutionTimeHours,  int uniqueDamageCauseCount,  List<InsurerDamageCauseBreakdown> damageCauseBreakdown,  List<InsurerStatusBreakdown> statusBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsurerPerformanceReport() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.totalClaims,_that.closedClaims,_that.newClaims,_that.scheduledClaims,_that.inContactClaims,_that.averageResolutionTimeHours,_that.uniqueDamageCauseCount,_that.damageCauseBreakdown,_that.statusBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  int totalClaims,  int closedClaims,  int newClaims,  int scheduledClaims,  int inContactClaims,  double? averageResolutionTimeHours,  int uniqueDamageCauseCount,  List<InsurerDamageCauseBreakdown> damageCauseBreakdown,  List<InsurerStatusBreakdown> statusBreakdown)  $default,) {final _that = this;
switch (_that) {
case _InsurerPerformanceReport():
return $default(_that.insurerId,_that.insurerName,_that.totalClaims,_that.closedClaims,_that.newClaims,_that.scheduledClaims,_that.inContactClaims,_that.averageResolutionTimeHours,_that.uniqueDamageCauseCount,_that.damageCauseBreakdown,_that.statusBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String insurerId,  String insurerName,  int totalClaims,  int closedClaims,  int newClaims,  int scheduledClaims,  int inContactClaims,  double? averageResolutionTimeHours,  int uniqueDamageCauseCount,  List<InsurerDamageCauseBreakdown> damageCauseBreakdown,  List<InsurerStatusBreakdown> statusBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _InsurerPerformanceReport() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.totalClaims,_that.closedClaims,_that.newClaims,_that.scheduledClaims,_that.inContactClaims,_that.averageResolutionTimeHours,_that.uniqueDamageCauseCount,_that.damageCauseBreakdown,_that.statusBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _InsurerPerformanceReport extends InsurerPerformanceReport {
  const _InsurerPerformanceReport({required this.insurerId, required this.insurerName, required this.totalClaims, required this.closedClaims, required this.newClaims, required this.scheduledClaims, required this.inContactClaims, this.averageResolutionTimeHours, required this.uniqueDamageCauseCount, final  List<InsurerDamageCauseBreakdown> damageCauseBreakdown = const <InsurerDamageCauseBreakdown>[], final  List<InsurerStatusBreakdown> statusBreakdown = const <InsurerStatusBreakdown>[]}): _damageCauseBreakdown = damageCauseBreakdown,_statusBreakdown = statusBreakdown,super._();
  

@override final  String insurerId;
@override final  String insurerName;
@override final  int totalClaims;
@override final  int closedClaims;
@override final  int newClaims;
@override final  int scheduledClaims;
@override final  int inContactClaims;
@override final  double? averageResolutionTimeHours;
@override final  int uniqueDamageCauseCount;
 final  List<InsurerDamageCauseBreakdown> _damageCauseBreakdown;
@override@JsonKey() List<InsurerDamageCauseBreakdown> get damageCauseBreakdown {
  if (_damageCauseBreakdown is EqualUnmodifiableListView) return _damageCauseBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_damageCauseBreakdown);
}

 final  List<InsurerStatusBreakdown> _statusBreakdown;
@override@JsonKey() List<InsurerStatusBreakdown> get statusBreakdown {
  if (_statusBreakdown is EqualUnmodifiableListView) return _statusBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusBreakdown);
}


/// Create a copy of InsurerPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsurerPerformanceReportCopyWith<_InsurerPerformanceReport> get copyWith => __$InsurerPerformanceReportCopyWithImpl<_InsurerPerformanceReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsurerPerformanceReport&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.totalClaims, totalClaims) || other.totalClaims == totalClaims)&&(identical(other.closedClaims, closedClaims) || other.closedClaims == closedClaims)&&(identical(other.newClaims, newClaims) || other.newClaims == newClaims)&&(identical(other.scheduledClaims, scheduledClaims) || other.scheduledClaims == scheduledClaims)&&(identical(other.inContactClaims, inContactClaims) || other.inContactClaims == inContactClaims)&&(identical(other.averageResolutionTimeHours, averageResolutionTimeHours) || other.averageResolutionTimeHours == averageResolutionTimeHours)&&(identical(other.uniqueDamageCauseCount, uniqueDamageCauseCount) || other.uniqueDamageCauseCount == uniqueDamageCauseCount)&&const DeepCollectionEquality().equals(other._damageCauseBreakdown, _damageCauseBreakdown)&&const DeepCollectionEquality().equals(other._statusBreakdown, _statusBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,totalClaims,closedClaims,newClaims,scheduledClaims,inContactClaims,averageResolutionTimeHours,uniqueDamageCauseCount,const DeepCollectionEquality().hash(_damageCauseBreakdown),const DeepCollectionEquality().hash(_statusBreakdown));

@override
String toString() {
  return 'InsurerPerformanceReport(insurerId: $insurerId, insurerName: $insurerName, totalClaims: $totalClaims, closedClaims: $closedClaims, newClaims: $newClaims, scheduledClaims: $scheduledClaims, inContactClaims: $inContactClaims, averageResolutionTimeHours: $averageResolutionTimeHours, uniqueDamageCauseCount: $uniqueDamageCauseCount, damageCauseBreakdown: $damageCauseBreakdown, statusBreakdown: $statusBreakdown)';
}


}

/// @nodoc
abstract mixin class _$InsurerPerformanceReportCopyWith<$Res> implements $InsurerPerformanceReportCopyWith<$Res> {
  factory _$InsurerPerformanceReportCopyWith(_InsurerPerformanceReport value, $Res Function(_InsurerPerformanceReport) _then) = __$InsurerPerformanceReportCopyWithImpl;
@override @useResult
$Res call({
 String insurerId, String insurerName, int totalClaims, int closedClaims, int newClaims, int scheduledClaims, int inContactClaims, double? averageResolutionTimeHours, int uniqueDamageCauseCount, List<InsurerDamageCauseBreakdown> damageCauseBreakdown, List<InsurerStatusBreakdown> statusBreakdown
});




}
/// @nodoc
class __$InsurerPerformanceReportCopyWithImpl<$Res>
    implements _$InsurerPerformanceReportCopyWith<$Res> {
  __$InsurerPerformanceReportCopyWithImpl(this._self, this._then);

  final _InsurerPerformanceReport _self;
  final $Res Function(_InsurerPerformanceReport) _then;

/// Create a copy of InsurerPerformanceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? insurerId = null,Object? insurerName = null,Object? totalClaims = null,Object? closedClaims = null,Object? newClaims = null,Object? scheduledClaims = null,Object? inContactClaims = null,Object? averageResolutionTimeHours = freezed,Object? uniqueDamageCauseCount = null,Object? damageCauseBreakdown = null,Object? statusBreakdown = null,}) {
  return _then(_InsurerPerformanceReport(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,totalClaims: null == totalClaims ? _self.totalClaims : totalClaims // ignore: cast_nullable_to_non_nullable
as int,closedClaims: null == closedClaims ? _self.closedClaims : closedClaims // ignore: cast_nullable_to_non_nullable
as int,newClaims: null == newClaims ? _self.newClaims : newClaims // ignore: cast_nullable_to_non_nullable
as int,scheduledClaims: null == scheduledClaims ? _self.scheduledClaims : scheduledClaims // ignore: cast_nullable_to_non_nullable
as int,inContactClaims: null == inContactClaims ? _self.inContactClaims : inContactClaims // ignore: cast_nullable_to_non_nullable
as int,averageResolutionTimeHours: freezed == averageResolutionTimeHours ? _self.averageResolutionTimeHours : averageResolutionTimeHours // ignore: cast_nullable_to_non_nullable
as double?,uniqueDamageCauseCount: null == uniqueDamageCauseCount ? _self.uniqueDamageCauseCount : uniqueDamageCauseCount // ignore: cast_nullable_to_non_nullable
as int,damageCauseBreakdown: null == damageCauseBreakdown ? _self._damageCauseBreakdown : damageCauseBreakdown // ignore: cast_nullable_to_non_nullable
as List<InsurerDamageCauseBreakdown>,statusBreakdown: null == statusBreakdown ? _self._statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as List<InsurerStatusBreakdown>,
  ));
}


}

/// @nodoc
mixin _$InsurerDamageCauseBreakdown {

 String get insurerId; String get insurerName; DamageCause get damageCause; int get claimCount; double get percentage;
/// Create a copy of InsurerDamageCauseBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsurerDamageCauseBreakdownCopyWith<InsurerDamageCauseBreakdown> get copyWith => _$InsurerDamageCauseBreakdownCopyWithImpl<InsurerDamageCauseBreakdown>(this as InsurerDamageCauseBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsurerDamageCauseBreakdown&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,damageCause,claimCount,percentage);

@override
String toString() {
  return 'InsurerDamageCauseBreakdown(insurerId: $insurerId, insurerName: $insurerName, damageCause: $damageCause, claimCount: $claimCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $InsurerDamageCauseBreakdownCopyWith<$Res>  {
  factory $InsurerDamageCauseBreakdownCopyWith(InsurerDamageCauseBreakdown value, $Res Function(InsurerDamageCauseBreakdown) _then) = _$InsurerDamageCauseBreakdownCopyWithImpl;
@useResult
$Res call({
 String insurerId, String insurerName, DamageCause damageCause, int claimCount, double percentage
});




}
/// @nodoc
class _$InsurerDamageCauseBreakdownCopyWithImpl<$Res>
    implements $InsurerDamageCauseBreakdownCopyWith<$Res> {
  _$InsurerDamageCauseBreakdownCopyWithImpl(this._self, this._then);

  final InsurerDamageCauseBreakdown _self;
  final $Res Function(InsurerDamageCauseBreakdown) _then;

/// Create a copy of InsurerDamageCauseBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? insurerId = null,Object? insurerName = null,Object? damageCause = null,Object? claimCount = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InsurerDamageCauseBreakdown].
extension InsurerDamageCauseBreakdownPatterns on InsurerDamageCauseBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsurerDamageCauseBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsurerDamageCauseBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsurerDamageCauseBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  DamageCause damageCause,  int claimCount,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.damageCause,_that.claimCount,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  DamageCause damageCause,  int claimCount,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown():
return $default(_that.insurerId,_that.insurerName,_that.damageCause,_that.claimCount,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String insurerId,  String insurerName,  DamageCause damageCause,  int claimCount,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _InsurerDamageCauseBreakdown() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.damageCause,_that.claimCount,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc


class _InsurerDamageCauseBreakdown extends InsurerDamageCauseBreakdown {
  const _InsurerDamageCauseBreakdown({required this.insurerId, required this.insurerName, required this.damageCause, required this.claimCount, required this.percentage}): super._();
  

@override final  String insurerId;
@override final  String insurerName;
@override final  DamageCause damageCause;
@override final  int claimCount;
@override final  double percentage;

/// Create a copy of InsurerDamageCauseBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsurerDamageCauseBreakdownCopyWith<_InsurerDamageCauseBreakdown> get copyWith => __$InsurerDamageCauseBreakdownCopyWithImpl<_InsurerDamageCauseBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsurerDamageCauseBreakdown&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,damageCause,claimCount,percentage);

@override
String toString() {
  return 'InsurerDamageCauseBreakdown(insurerId: $insurerId, insurerName: $insurerName, damageCause: $damageCause, claimCount: $claimCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$InsurerDamageCauseBreakdownCopyWith<$Res> implements $InsurerDamageCauseBreakdownCopyWith<$Res> {
  factory _$InsurerDamageCauseBreakdownCopyWith(_InsurerDamageCauseBreakdown value, $Res Function(_InsurerDamageCauseBreakdown) _then) = __$InsurerDamageCauseBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String insurerId, String insurerName, DamageCause damageCause, int claimCount, double percentage
});




}
/// @nodoc
class __$InsurerDamageCauseBreakdownCopyWithImpl<$Res>
    implements _$InsurerDamageCauseBreakdownCopyWith<$Res> {
  __$InsurerDamageCauseBreakdownCopyWithImpl(this._self, this._then);

  final _InsurerDamageCauseBreakdown _self;
  final $Res Function(_InsurerDamageCauseBreakdown) _then;

/// Create a copy of InsurerDamageCauseBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? insurerId = null,Object? insurerName = null,Object? damageCause = null,Object? claimCount = null,Object? percentage = null,}) {
  return _then(_InsurerDamageCauseBreakdown(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InsurerStatusBreakdown {

 String get insurerId; String get insurerName; ClaimStatus get status; int get claimCount; double get percentage;
/// Create a copy of InsurerStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsurerStatusBreakdownCopyWith<InsurerStatusBreakdown> get copyWith => _$InsurerStatusBreakdownCopyWithImpl<InsurerStatusBreakdown>(this as InsurerStatusBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsurerStatusBreakdown&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,status,claimCount,percentage);

@override
String toString() {
  return 'InsurerStatusBreakdown(insurerId: $insurerId, insurerName: $insurerName, status: $status, claimCount: $claimCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $InsurerStatusBreakdownCopyWith<$Res>  {
  factory $InsurerStatusBreakdownCopyWith(InsurerStatusBreakdown value, $Res Function(InsurerStatusBreakdown) _then) = _$InsurerStatusBreakdownCopyWithImpl;
@useResult
$Res call({
 String insurerId, String insurerName, ClaimStatus status, int claimCount, double percentage
});




}
/// @nodoc
class _$InsurerStatusBreakdownCopyWithImpl<$Res>
    implements $InsurerStatusBreakdownCopyWith<$Res> {
  _$InsurerStatusBreakdownCopyWithImpl(this._self, this._then);

  final InsurerStatusBreakdown _self;
  final $Res Function(InsurerStatusBreakdown) _then;

/// Create a copy of InsurerStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? insurerId = null,Object? insurerName = null,Object? status = null,Object? claimCount = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InsurerStatusBreakdown].
extension InsurerStatusBreakdownPatterns on InsurerStatusBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsurerStatusBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsurerStatusBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsurerStatusBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _InsurerStatusBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsurerStatusBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _InsurerStatusBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  ClaimStatus status,  int claimCount,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsurerStatusBreakdown() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.status,_that.claimCount,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String insurerId,  String insurerName,  ClaimStatus status,  int claimCount,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _InsurerStatusBreakdown():
return $default(_that.insurerId,_that.insurerName,_that.status,_that.claimCount,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String insurerId,  String insurerName,  ClaimStatus status,  int claimCount,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _InsurerStatusBreakdown() when $default != null:
return $default(_that.insurerId,_that.insurerName,_that.status,_that.claimCount,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc


class _InsurerStatusBreakdown extends InsurerStatusBreakdown {
  const _InsurerStatusBreakdown({required this.insurerId, required this.insurerName, required this.status, required this.claimCount, required this.percentage}): super._();
  

@override final  String insurerId;
@override final  String insurerName;
@override final  ClaimStatus status;
@override final  int claimCount;
@override final  double percentage;

/// Create a copy of InsurerStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsurerStatusBreakdownCopyWith<_InsurerStatusBreakdown> get copyWith => __$InsurerStatusBreakdownCopyWithImpl<_InsurerStatusBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsurerStatusBreakdown&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.insurerName, insurerName) || other.insurerName == insurerName)&&(identical(other.status, status) || other.status == status)&&(identical(other.claimCount, claimCount) || other.claimCount == claimCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}


@override
int get hashCode => Object.hash(runtimeType,insurerId,insurerName,status,claimCount,percentage);

@override
String toString() {
  return 'InsurerStatusBreakdown(insurerId: $insurerId, insurerName: $insurerName, status: $status, claimCount: $claimCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$InsurerStatusBreakdownCopyWith<$Res> implements $InsurerStatusBreakdownCopyWith<$Res> {
  factory _$InsurerStatusBreakdownCopyWith(_InsurerStatusBreakdown value, $Res Function(_InsurerStatusBreakdown) _then) = __$InsurerStatusBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String insurerId, String insurerName, ClaimStatus status, int claimCount, double percentage
});




}
/// @nodoc
class __$InsurerStatusBreakdownCopyWithImpl<$Res>
    implements _$InsurerStatusBreakdownCopyWith<$Res> {
  __$InsurerStatusBreakdownCopyWithImpl(this._self, this._then);

  final _InsurerStatusBreakdown _self;
  final $Res Function(_InsurerStatusBreakdown) _then;

/// Create a copy of InsurerStatusBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? insurerId = null,Object? insurerName = null,Object? status = null,Object? claimCount = null,Object? percentage = null,}) {
  return _then(_InsurerStatusBreakdown(
insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,insurerName: null == insurerName ? _self.insurerName : insurerName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,claimCount: null == claimCount ? _self.claimCount : claimCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
