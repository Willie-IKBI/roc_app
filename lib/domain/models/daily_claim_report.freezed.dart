// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_claim_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyClaimReport {

 DateTime get date; int get claimsCaptured; double? get averageMinutesToFirstContact; int get compliantClaims; int get contactedClaims;
/// Create a copy of DailyClaimReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyClaimReportCopyWith<DailyClaimReport> get copyWith => _$DailyClaimReportCopyWithImpl<DailyClaimReport>(this as DailyClaimReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyClaimReport&&(identical(other.date, date) || other.date == date)&&(identical(other.claimsCaptured, claimsCaptured) || other.claimsCaptured == claimsCaptured)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.compliantClaims, compliantClaims) || other.compliantClaims == compliantClaims)&&(identical(other.contactedClaims, contactedClaims) || other.contactedClaims == contactedClaims));
}


@override
int get hashCode => Object.hash(runtimeType,date,claimsCaptured,averageMinutesToFirstContact,compliantClaims,contactedClaims);

@override
String toString() {
  return 'DailyClaimReport(date: $date, claimsCaptured: $claimsCaptured, averageMinutesToFirstContact: $averageMinutesToFirstContact, compliantClaims: $compliantClaims, contactedClaims: $contactedClaims)';
}


}

/// @nodoc
abstract mixin class $DailyClaimReportCopyWith<$Res>  {
  factory $DailyClaimReportCopyWith(DailyClaimReport value, $Res Function(DailyClaimReport) _then) = _$DailyClaimReportCopyWithImpl;
@useResult
$Res call({
 DateTime date, int claimsCaptured, double? averageMinutesToFirstContact, int compliantClaims, int contactedClaims
});




}
/// @nodoc
class _$DailyClaimReportCopyWithImpl<$Res>
    implements $DailyClaimReportCopyWith<$Res> {
  _$DailyClaimReportCopyWithImpl(this._self, this._then);

  final DailyClaimReport _self;
  final $Res Function(DailyClaimReport) _then;

/// Create a copy of DailyClaimReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? claimsCaptured = null,Object? averageMinutesToFirstContact = freezed,Object? compliantClaims = null,Object? contactedClaims = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,claimsCaptured: null == claimsCaptured ? _self.claimsCaptured : claimsCaptured // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,compliantClaims: null == compliantClaims ? _self.compliantClaims : compliantClaims // ignore: cast_nullable_to_non_nullable
as int,contactedClaims: null == contactedClaims ? _self.contactedClaims : contactedClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyClaimReport].
extension DailyClaimReportPatterns on DailyClaimReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyClaimReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyClaimReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyClaimReport value)  $default,){
final _that = this;
switch (_that) {
case _DailyClaimReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyClaimReport value)?  $default,){
final _that = this;
switch (_that) {
case _DailyClaimReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int claimsCaptured,  double? averageMinutesToFirstContact,  int compliantClaims,  int contactedClaims)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyClaimReport() when $default != null:
return $default(_that.date,_that.claimsCaptured,_that.averageMinutesToFirstContact,_that.compliantClaims,_that.contactedClaims);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int claimsCaptured,  double? averageMinutesToFirstContact,  int compliantClaims,  int contactedClaims)  $default,) {final _that = this;
switch (_that) {
case _DailyClaimReport():
return $default(_that.date,_that.claimsCaptured,_that.averageMinutesToFirstContact,_that.compliantClaims,_that.contactedClaims);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int claimsCaptured,  double? averageMinutesToFirstContact,  int compliantClaims,  int contactedClaims)?  $default,) {final _that = this;
switch (_that) {
case _DailyClaimReport() when $default != null:
return $default(_that.date,_that.claimsCaptured,_that.averageMinutesToFirstContact,_that.compliantClaims,_that.contactedClaims);case _:
  return null;

}
}

}

/// @nodoc


class _DailyClaimReport extends DailyClaimReport {
  const _DailyClaimReport({required this.date, required this.claimsCaptured, this.averageMinutesToFirstContact, required this.compliantClaims, required this.contactedClaims}): super._();
  

@override final  DateTime date;
@override final  int claimsCaptured;
@override final  double? averageMinutesToFirstContact;
@override final  int compliantClaims;
@override final  int contactedClaims;

/// Create a copy of DailyClaimReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyClaimReportCopyWith<_DailyClaimReport> get copyWith => __$DailyClaimReportCopyWithImpl<_DailyClaimReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyClaimReport&&(identical(other.date, date) || other.date == date)&&(identical(other.claimsCaptured, claimsCaptured) || other.claimsCaptured == claimsCaptured)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.compliantClaims, compliantClaims) || other.compliantClaims == compliantClaims)&&(identical(other.contactedClaims, contactedClaims) || other.contactedClaims == contactedClaims));
}


@override
int get hashCode => Object.hash(runtimeType,date,claimsCaptured,averageMinutesToFirstContact,compliantClaims,contactedClaims);

@override
String toString() {
  return 'DailyClaimReport(date: $date, claimsCaptured: $claimsCaptured, averageMinutesToFirstContact: $averageMinutesToFirstContact, compliantClaims: $compliantClaims, contactedClaims: $contactedClaims)';
}


}

/// @nodoc
abstract mixin class _$DailyClaimReportCopyWith<$Res> implements $DailyClaimReportCopyWith<$Res> {
  factory _$DailyClaimReportCopyWith(_DailyClaimReport value, $Res Function(_DailyClaimReport) _then) = __$DailyClaimReportCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int claimsCaptured, double? averageMinutesToFirstContact, int compliantClaims, int contactedClaims
});




}
/// @nodoc
class __$DailyClaimReportCopyWithImpl<$Res>
    implements _$DailyClaimReportCopyWith<$Res> {
  __$DailyClaimReportCopyWithImpl(this._self, this._then);

  final _DailyClaimReport _self;
  final $Res Function(_DailyClaimReport) _then;

/// Create a copy of DailyClaimReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? claimsCaptured = null,Object? averageMinutesToFirstContact = freezed,Object? compliantClaims = null,Object? contactedClaims = null,}) {
  return _then(_DailyClaimReport(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,claimsCaptured: null == claimsCaptured ? _self.claimsCaptured : claimsCaptured // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,compliantClaims: null == compliantClaims ? _self.compliantClaims : compliantClaims // ignore: cast_nullable_to_non_nullable
as int,contactedClaims: null == contactedClaims ? _self.contactedClaims : contactedClaims // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
