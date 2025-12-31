// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardSummary {

 int get totalActiveClaims; Map<ClaimStatus, int> get statusCounts; Map<PriorityLevel, int> get priorityCounts; int get overdueCount; int get dueSoonCount; int get followUpCount;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.totalActiveClaims, totalActiveClaims) || other.totalActiveClaims == totalActiveClaims)&&const DeepCollectionEquality().equals(other.statusCounts, statusCounts)&&const DeepCollectionEquality().equals(other.priorityCounts, priorityCounts)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.dueSoonCount, dueSoonCount) || other.dueSoonCount == dueSoonCount)&&(identical(other.followUpCount, followUpCount) || other.followUpCount == followUpCount));
}


@override
int get hashCode => Object.hash(runtimeType,totalActiveClaims,const DeepCollectionEquality().hash(statusCounts),const DeepCollectionEquality().hash(priorityCounts),overdueCount,dueSoonCount,followUpCount);

@override
String toString() {
  return 'DashboardSummary(totalActiveClaims: $totalActiveClaims, statusCounts: $statusCounts, priorityCounts: $priorityCounts, overdueCount: $overdueCount, dueSoonCount: $dueSoonCount, followUpCount: $followUpCount)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 int totalActiveClaims, Map<ClaimStatus, int> statusCounts, Map<PriorityLevel, int> priorityCounts, int overdueCount, int dueSoonCount, int followUpCount
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalActiveClaims = null,Object? statusCounts = null,Object? priorityCounts = null,Object? overdueCount = null,Object? dueSoonCount = null,Object? followUpCount = null,}) {
  return _then(_self.copyWith(
totalActiveClaims: null == totalActiveClaims ? _self.totalActiveClaims : totalActiveClaims // ignore: cast_nullable_to_non_nullable
as int,statusCounts: null == statusCounts ? _self.statusCounts : statusCounts // ignore: cast_nullable_to_non_nullable
as Map<ClaimStatus, int>,priorityCounts: null == priorityCounts ? _self.priorityCounts : priorityCounts // ignore: cast_nullable_to_non_nullable
as Map<PriorityLevel, int>,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,dueSoonCount: null == dueSoonCount ? _self.dueSoonCount : dueSoonCount // ignore: cast_nullable_to_non_nullable
as int,followUpCount: null == followUpCount ? _self.followUpCount : followUpCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalActiveClaims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  int overdueCount,  int dueSoonCount,  int followUpCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.totalActiveClaims,_that.statusCounts,_that.priorityCounts,_that.overdueCount,_that.dueSoonCount,_that.followUpCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalActiveClaims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  int overdueCount,  int dueSoonCount,  int followUpCount)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.totalActiveClaims,_that.statusCounts,_that.priorityCounts,_that.overdueCount,_that.dueSoonCount,_that.followUpCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalActiveClaims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  int overdueCount,  int dueSoonCount,  int followUpCount)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.totalActiveClaims,_that.statusCounts,_that.priorityCounts,_that.overdueCount,_that.dueSoonCount,_that.followUpCount);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardSummary extends DashboardSummary {
  const _DashboardSummary({required this.totalActiveClaims, required final  Map<ClaimStatus, int> statusCounts, required final  Map<PriorityLevel, int> priorityCounts, required this.overdueCount, required this.dueSoonCount, required this.followUpCount}): _statusCounts = statusCounts,_priorityCounts = priorityCounts,super._();
  

@override final  int totalActiveClaims;
 final  Map<ClaimStatus, int> _statusCounts;
@override Map<ClaimStatus, int> get statusCounts {
  if (_statusCounts is EqualUnmodifiableMapView) return _statusCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statusCounts);
}

 final  Map<PriorityLevel, int> _priorityCounts;
@override Map<PriorityLevel, int> get priorityCounts {
  if (_priorityCounts is EqualUnmodifiableMapView) return _priorityCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_priorityCounts);
}

@override final  int overdueCount;
@override final  int dueSoonCount;
@override final  int followUpCount;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.totalActiveClaims, totalActiveClaims) || other.totalActiveClaims == totalActiveClaims)&&const DeepCollectionEquality().equals(other._statusCounts, _statusCounts)&&const DeepCollectionEquality().equals(other._priorityCounts, _priorityCounts)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.dueSoonCount, dueSoonCount) || other.dueSoonCount == dueSoonCount)&&(identical(other.followUpCount, followUpCount) || other.followUpCount == followUpCount));
}


@override
int get hashCode => Object.hash(runtimeType,totalActiveClaims,const DeepCollectionEquality().hash(_statusCounts),const DeepCollectionEquality().hash(_priorityCounts),overdueCount,dueSoonCount,followUpCount);

@override
String toString() {
  return 'DashboardSummary(totalActiveClaims: $totalActiveClaims, statusCounts: $statusCounts, priorityCounts: $priorityCounts, overdueCount: $overdueCount, dueSoonCount: $dueSoonCount, followUpCount: $followUpCount)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalActiveClaims, Map<ClaimStatus, int> statusCounts, Map<PriorityLevel, int> priorityCounts, int overdueCount, int dueSoonCount, int followUpCount
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalActiveClaims = null,Object? statusCounts = null,Object? priorityCounts = null,Object? overdueCount = null,Object? dueSoonCount = null,Object? followUpCount = null,}) {
  return _then(_DashboardSummary(
totalActiveClaims: null == totalActiveClaims ? _self.totalActiveClaims : totalActiveClaims // ignore: cast_nullable_to_non_nullable
as int,statusCounts: null == statusCounts ? _self._statusCounts : statusCounts // ignore: cast_nullable_to_non_nullable
as Map<ClaimStatus, int>,priorityCounts: null == priorityCounts ? _self._priorityCounts : priorityCounts // ignore: cast_nullable_to_non_nullable
as Map<PriorityLevel, int>,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,dueSoonCount: null == dueSoonCount ? _self.dueSoonCount : dueSoonCount // ignore: cast_nullable_to_non_nullable
as int,followUpCount: null == followUpCount ? _self.followUpCount : followUpCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
