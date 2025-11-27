// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reporting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportingState {

 List<DailyClaimReport> get reports; int get totalClaims; double? get averageMinutesToFirstContact; double get complianceRate; ReportingWindow get window;
/// Create a copy of ReportingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportingStateCopyWith<ReportingState> get copyWith => _$ReportingStateCopyWithImpl<ReportingState>(this as ReportingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportingState&&const DeepCollectionEquality().equals(other.reports, reports)&&(identical(other.totalClaims, totalClaims) || other.totalClaims == totalClaims)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.complianceRate, complianceRate) || other.complianceRate == complianceRate)&&(identical(other.window, window) || other.window == window));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reports),totalClaims,averageMinutesToFirstContact,complianceRate,window);

@override
String toString() {
  return 'ReportingState(reports: $reports, totalClaims: $totalClaims, averageMinutesToFirstContact: $averageMinutesToFirstContact, complianceRate: $complianceRate, window: $window)';
}


}

/// @nodoc
abstract mixin class $ReportingStateCopyWith<$Res>  {
  factory $ReportingStateCopyWith(ReportingState value, $Res Function(ReportingState) _then) = _$ReportingStateCopyWithImpl;
@useResult
$Res call({
 List<DailyClaimReport> reports, int totalClaims, double? averageMinutesToFirstContact, double complianceRate, ReportingWindow window
});




}
/// @nodoc
class _$ReportingStateCopyWithImpl<$Res>
    implements $ReportingStateCopyWith<$Res> {
  _$ReportingStateCopyWithImpl(this._self, this._then);

  final ReportingState _self;
  final $Res Function(ReportingState) _then;

/// Create a copy of ReportingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reports = null,Object? totalClaims = null,Object? averageMinutesToFirstContact = freezed,Object? complianceRate = null,Object? window = null,}) {
  return _then(_self.copyWith(
reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<DailyClaimReport>,totalClaims: null == totalClaims ? _self.totalClaims : totalClaims // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,complianceRate: null == complianceRate ? _self.complianceRate : complianceRate // ignore: cast_nullable_to_non_nullable
as double,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as ReportingWindow,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportingState].
extension ReportingStatePatterns on ReportingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportingState value)  $default,){
final _that = this;
switch (_that) {
case _ReportingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportingState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DailyClaimReport> reports,  int totalClaims,  double? averageMinutesToFirstContact,  double complianceRate,  ReportingWindow window)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportingState() when $default != null:
return $default(_that.reports,_that.totalClaims,_that.averageMinutesToFirstContact,_that.complianceRate,_that.window);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DailyClaimReport> reports,  int totalClaims,  double? averageMinutesToFirstContact,  double complianceRate,  ReportingWindow window)  $default,) {final _that = this;
switch (_that) {
case _ReportingState():
return $default(_that.reports,_that.totalClaims,_that.averageMinutesToFirstContact,_that.complianceRate,_that.window);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DailyClaimReport> reports,  int totalClaims,  double? averageMinutesToFirstContact,  double complianceRate,  ReportingWindow window)?  $default,) {final _that = this;
switch (_that) {
case _ReportingState() when $default != null:
return $default(_that.reports,_that.totalClaims,_that.averageMinutesToFirstContact,_that.complianceRate,_that.window);case _:
  return null;

}
}

}

/// @nodoc


class _ReportingState implements ReportingState {
  const _ReportingState({required final  List<DailyClaimReport> reports, required this.totalClaims, this.averageMinutesToFirstContact, required this.complianceRate, required this.window}): _reports = reports;
  

 final  List<DailyClaimReport> _reports;
@override List<DailyClaimReport> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}

@override final  int totalClaims;
@override final  double? averageMinutesToFirstContact;
@override final  double complianceRate;
@override final  ReportingWindow window;

/// Create a copy of ReportingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportingStateCopyWith<_ReportingState> get copyWith => __$ReportingStateCopyWithImpl<_ReportingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportingState&&const DeepCollectionEquality().equals(other._reports, _reports)&&(identical(other.totalClaims, totalClaims) || other.totalClaims == totalClaims)&&(identical(other.averageMinutesToFirstContact, averageMinutesToFirstContact) || other.averageMinutesToFirstContact == averageMinutesToFirstContact)&&(identical(other.complianceRate, complianceRate) || other.complianceRate == complianceRate)&&(identical(other.window, window) || other.window == window));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reports),totalClaims,averageMinutesToFirstContact,complianceRate,window);

@override
String toString() {
  return 'ReportingState(reports: $reports, totalClaims: $totalClaims, averageMinutesToFirstContact: $averageMinutesToFirstContact, complianceRate: $complianceRate, window: $window)';
}


}

/// @nodoc
abstract mixin class _$ReportingStateCopyWith<$Res> implements $ReportingStateCopyWith<$Res> {
  factory _$ReportingStateCopyWith(_ReportingState value, $Res Function(_ReportingState) _then) = __$ReportingStateCopyWithImpl;
@override @useResult
$Res call({
 List<DailyClaimReport> reports, int totalClaims, double? averageMinutesToFirstContact, double complianceRate, ReportingWindow window
});




}
/// @nodoc
class __$ReportingStateCopyWithImpl<$Res>
    implements _$ReportingStateCopyWith<$Res> {
  __$ReportingStateCopyWithImpl(this._self, this._then);

  final _ReportingState _self;
  final $Res Function(_ReportingState) _then;

/// Create a copy of ReportingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reports = null,Object? totalClaims = null,Object? averageMinutesToFirstContact = freezed,Object? complianceRate = null,Object? window = null,}) {
  return _then(_ReportingState(
reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<DailyClaimReport>,totalClaims: null == totalClaims ? _self.totalClaims : totalClaims // ignore: cast_nullable_to_non_nullable
as int,averageMinutesToFirstContact: freezed == averageMinutesToFirstContact ? _self.averageMinutesToFirstContact : averageMinutesToFirstContact // ignore: cast_nullable_to_non_nullable
as double?,complianceRate: null == complianceRate ? _self.complianceRate : complianceRate // ignore: cast_nullable_to_non_nullable
as double,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as ReportingWindow,
  ));
}


}

// dart format on
