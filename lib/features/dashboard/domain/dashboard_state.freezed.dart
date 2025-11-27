// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 List<ClaimSummary> get claims; Map<ClaimStatus, int> get statusCounts; Map<PriorityLevel, int> get priorityCounts; List<ClaimSummary> get overdueClaims; List<ClaimSummary> get needsFollowUp; List<ClaimSummary> get recentClaims; int get dueSoonCount;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&const DeepCollectionEquality().equals(other.claims, claims)&&const DeepCollectionEquality().equals(other.statusCounts, statusCounts)&&const DeepCollectionEquality().equals(other.priorityCounts, priorityCounts)&&const DeepCollectionEquality().equals(other.overdueClaims, overdueClaims)&&const DeepCollectionEquality().equals(other.needsFollowUp, needsFollowUp)&&const DeepCollectionEquality().equals(other.recentClaims, recentClaims)&&(identical(other.dueSoonCount, dueSoonCount) || other.dueSoonCount == dueSoonCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(claims),const DeepCollectionEquality().hash(statusCounts),const DeepCollectionEquality().hash(priorityCounts),const DeepCollectionEquality().hash(overdueClaims),const DeepCollectionEquality().hash(needsFollowUp),const DeepCollectionEquality().hash(recentClaims),dueSoonCount);

@override
String toString() {
  return 'DashboardState(claims: $claims, statusCounts: $statusCounts, priorityCounts: $priorityCounts, overdueClaims: $overdueClaims, needsFollowUp: $needsFollowUp, recentClaims: $recentClaims, dueSoonCount: $dueSoonCount)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 List<ClaimSummary> claims, Map<ClaimStatus, int> statusCounts, Map<PriorityLevel, int> priorityCounts, List<ClaimSummary> overdueClaims, List<ClaimSummary> needsFollowUp, List<ClaimSummary> recentClaims, int dueSoonCount
});




}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claims = null,Object? statusCounts = null,Object? priorityCounts = null,Object? overdueClaims = null,Object? needsFollowUp = null,Object? recentClaims = null,Object? dueSoonCount = null,}) {
  return _then(_self.copyWith(
claims: null == claims ? _self.claims : claims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,statusCounts: null == statusCounts ? _self.statusCounts : statusCounts // ignore: cast_nullable_to_non_nullable
as Map<ClaimStatus, int>,priorityCounts: null == priorityCounts ? _self.priorityCounts : priorityCounts // ignore: cast_nullable_to_non_nullable
as Map<PriorityLevel, int>,overdueClaims: null == overdueClaims ? _self.overdueClaims : overdueClaims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,needsFollowUp: null == needsFollowUp ? _self.needsFollowUp : needsFollowUp // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,recentClaims: null == recentClaims ? _self.recentClaims : recentClaims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,dueSoonCount: null == dueSoonCount ? _self.dueSoonCount : dueSoonCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ClaimSummary> claims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  List<ClaimSummary> overdueClaims,  List<ClaimSummary> needsFollowUp,  List<ClaimSummary> recentClaims,  int dueSoonCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.claims,_that.statusCounts,_that.priorityCounts,_that.overdueClaims,_that.needsFollowUp,_that.recentClaims,_that.dueSoonCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ClaimSummary> claims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  List<ClaimSummary> overdueClaims,  List<ClaimSummary> needsFollowUp,  List<ClaimSummary> recentClaims,  int dueSoonCount)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.claims,_that.statusCounts,_that.priorityCounts,_that.overdueClaims,_that.needsFollowUp,_that.recentClaims,_that.dueSoonCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ClaimSummary> claims,  Map<ClaimStatus, int> statusCounts,  Map<PriorityLevel, int> priorityCounts,  List<ClaimSummary> overdueClaims,  List<ClaimSummary> needsFollowUp,  List<ClaimSummary> recentClaims,  int dueSoonCount)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.claims,_that.statusCounts,_that.priorityCounts,_that.overdueClaims,_that.needsFollowUp,_that.recentClaims,_that.dueSoonCount);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState extends DashboardState {
  const _DashboardState({required final  List<ClaimSummary> claims, required final  Map<ClaimStatus, int> statusCounts, required final  Map<PriorityLevel, int> priorityCounts, required final  List<ClaimSummary> overdueClaims, required final  List<ClaimSummary> needsFollowUp, required final  List<ClaimSummary> recentClaims, required this.dueSoonCount}): _claims = claims,_statusCounts = statusCounts,_priorityCounts = priorityCounts,_overdueClaims = overdueClaims,_needsFollowUp = needsFollowUp,_recentClaims = recentClaims,super._();
  

 final  List<ClaimSummary> _claims;
@override List<ClaimSummary> get claims {
  if (_claims is EqualUnmodifiableListView) return _claims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_claims);
}

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

 final  List<ClaimSummary> _overdueClaims;
@override List<ClaimSummary> get overdueClaims {
  if (_overdueClaims is EqualUnmodifiableListView) return _overdueClaims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdueClaims);
}

 final  List<ClaimSummary> _needsFollowUp;
@override List<ClaimSummary> get needsFollowUp {
  if (_needsFollowUp is EqualUnmodifiableListView) return _needsFollowUp;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needsFollowUp);
}

 final  List<ClaimSummary> _recentClaims;
@override List<ClaimSummary> get recentClaims {
  if (_recentClaims is EqualUnmodifiableListView) return _recentClaims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentClaims);
}

@override final  int dueSoonCount;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&const DeepCollectionEquality().equals(other._claims, _claims)&&const DeepCollectionEquality().equals(other._statusCounts, _statusCounts)&&const DeepCollectionEquality().equals(other._priorityCounts, _priorityCounts)&&const DeepCollectionEquality().equals(other._overdueClaims, _overdueClaims)&&const DeepCollectionEquality().equals(other._needsFollowUp, _needsFollowUp)&&const DeepCollectionEquality().equals(other._recentClaims, _recentClaims)&&(identical(other.dueSoonCount, dueSoonCount) || other.dueSoonCount == dueSoonCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_claims),const DeepCollectionEquality().hash(_statusCounts),const DeepCollectionEquality().hash(_priorityCounts),const DeepCollectionEquality().hash(_overdueClaims),const DeepCollectionEquality().hash(_needsFollowUp),const DeepCollectionEquality().hash(_recentClaims),dueSoonCount);

@override
String toString() {
  return 'DashboardState(claims: $claims, statusCounts: $statusCounts, priorityCounts: $priorityCounts, overdueClaims: $overdueClaims, needsFollowUp: $needsFollowUp, recentClaims: $recentClaims, dueSoonCount: $dueSoonCount)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<ClaimSummary> claims, Map<ClaimStatus, int> statusCounts, Map<PriorityLevel, int> priorityCounts, List<ClaimSummary> overdueClaims, List<ClaimSummary> needsFollowUp, List<ClaimSummary> recentClaims, int dueSoonCount
});




}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claims = null,Object? statusCounts = null,Object? priorityCounts = null,Object? overdueClaims = null,Object? needsFollowUp = null,Object? recentClaims = null,Object? dueSoonCount = null,}) {
  return _then(_DashboardState(
claims: null == claims ? _self._claims : claims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,statusCounts: null == statusCounts ? _self._statusCounts : statusCounts // ignore: cast_nullable_to_non_nullable
as Map<ClaimStatus, int>,priorityCounts: null == priorityCounts ? _self._priorityCounts : priorityCounts // ignore: cast_nullable_to_non_nullable
as Map<PriorityLevel, int>,overdueClaims: null == overdueClaims ? _self._overdueClaims : overdueClaims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,needsFollowUp: null == needsFollowUp ? _self._needsFollowUp : needsFollowUp // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,recentClaims: null == recentClaims ? _self._recentClaims : recentClaims // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,dueSoonCount: null == dueSoonCount ? _self.dueSoonCount : dueSoonCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
