// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssignableJobsState {

 List<ClaimSummary> get items; bool get isLoading; bool get isLoadingMore; bool get hasMore; String? get nextCursor; DomainError? get error; ClaimStatus? get statusFilter; bool? get assignedFilter; String? get technicianIdFilter; DateTime? get dateFrom; DateTime? get dateTo;
/// Create a copy of AssignableJobsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignableJobsStateCopyWith<AssignableJobsState> get copyWith => _$AssignableJobsStateCopyWithImpl<AssignableJobsState>(this as AssignableJobsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignableJobsState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.error, error) || other.error == error)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.assignedFilter, assignedFilter) || other.assignedFilter == assignedFilter)&&(identical(other.technicianIdFilter, technicianIdFilter) || other.technicianIdFilter == technicianIdFilter)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),isLoading,isLoadingMore,hasMore,nextCursor,error,statusFilter,assignedFilter,technicianIdFilter,dateFrom,dateTo);

@override
String toString() {
  return 'AssignableJobsState(items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextCursor: $nextCursor, error: $error, statusFilter: $statusFilter, assignedFilter: $assignedFilter, technicianIdFilter: $technicianIdFilter, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class $AssignableJobsStateCopyWith<$Res>  {
  factory $AssignableJobsStateCopyWith(AssignableJobsState value, $Res Function(AssignableJobsState) _then) = _$AssignableJobsStateCopyWithImpl;
@useResult
$Res call({
 List<ClaimSummary> items, bool isLoading, bool isLoadingMore, bool hasMore, String? nextCursor, DomainError? error, ClaimStatus? statusFilter, bool? assignedFilter, String? technicianIdFilter, DateTime? dateFrom, DateTime? dateTo
});




}
/// @nodoc
class _$AssignableJobsStateCopyWithImpl<$Res>
    implements $AssignableJobsStateCopyWith<$Res> {
  _$AssignableJobsStateCopyWithImpl(this._self, this._then);

  final AssignableJobsState _self;
  final $Res Function(AssignableJobsState) _then;

/// Create a copy of AssignableJobsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextCursor = freezed,Object? error = freezed,Object? statusFilter = freezed,Object? assignedFilter = freezed,Object? technicianIdFilter = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as DomainError?,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ClaimStatus?,assignedFilter: freezed == assignedFilter ? _self.assignedFilter : assignedFilter // ignore: cast_nullable_to_non_nullable
as bool?,technicianIdFilter: freezed == technicianIdFilter ? _self.technicianIdFilter : technicianIdFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignableJobsState].
extension AssignableJobsStatePatterns on AssignableJobsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignableJobsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignableJobsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignableJobsState value)  $default,){
final _that = this;
switch (_that) {
case _AssignableJobsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignableJobsState value)?  $default,){
final _that = this;
switch (_that) {
case _AssignableJobsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter,  bool? assignedFilter,  String? technicianIdFilter,  DateTime? dateFrom,  DateTime? dateTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignableJobsState() when $default != null:
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter,_that.assignedFilter,_that.technicianIdFilter,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter,  bool? assignedFilter,  String? technicianIdFilter,  DateTime? dateFrom,  DateTime? dateTo)  $default,) {final _that = this;
switch (_that) {
case _AssignableJobsState():
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter,_that.assignedFilter,_that.technicianIdFilter,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter,  bool? assignedFilter,  String? technicianIdFilter,  DateTime? dateFrom,  DateTime? dateTo)?  $default,) {final _that = this;
switch (_that) {
case _AssignableJobsState() when $default != null:
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter,_that.assignedFilter,_that.technicianIdFilter,_that.dateFrom,_that.dateTo);case _:
  return null;

}
}

}

/// @nodoc


class _AssignableJobsState implements AssignableJobsState {
  const _AssignableJobsState({final  List<ClaimSummary> items = const [], this.isLoading = false, this.isLoadingMore = false, this.hasMore = false, this.nextCursor, this.error, this.statusFilter, this.assignedFilter, this.technicianIdFilter, this.dateFrom, this.dateTo}): _items = items;
  

 final  List<ClaimSummary> _items;
@override@JsonKey() List<ClaimSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override final  DomainError? error;
@override final  ClaimStatus? statusFilter;
@override final  bool? assignedFilter;
@override final  String? technicianIdFilter;
@override final  DateTime? dateFrom;
@override final  DateTime? dateTo;

/// Create a copy of AssignableJobsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignableJobsStateCopyWith<_AssignableJobsState> get copyWith => __$AssignableJobsStateCopyWithImpl<_AssignableJobsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignableJobsState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.error, error) || other.error == error)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.assignedFilter, assignedFilter) || other.assignedFilter == assignedFilter)&&(identical(other.technicianIdFilter, technicianIdFilter) || other.technicianIdFilter == technicianIdFilter)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isLoading,isLoadingMore,hasMore,nextCursor,error,statusFilter,assignedFilter,technicianIdFilter,dateFrom,dateTo);

@override
String toString() {
  return 'AssignableJobsState(items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextCursor: $nextCursor, error: $error, statusFilter: $statusFilter, assignedFilter: $assignedFilter, technicianIdFilter: $technicianIdFilter, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class _$AssignableJobsStateCopyWith<$Res> implements $AssignableJobsStateCopyWith<$Res> {
  factory _$AssignableJobsStateCopyWith(_AssignableJobsState value, $Res Function(_AssignableJobsState) _then) = __$AssignableJobsStateCopyWithImpl;
@override @useResult
$Res call({
 List<ClaimSummary> items, bool isLoading, bool isLoadingMore, bool hasMore, String? nextCursor, DomainError? error, ClaimStatus? statusFilter, bool? assignedFilter, String? technicianIdFilter, DateTime? dateFrom, DateTime? dateTo
});




}
/// @nodoc
class __$AssignableJobsStateCopyWithImpl<$Res>
    implements _$AssignableJobsStateCopyWith<$Res> {
  __$AssignableJobsStateCopyWithImpl(this._self, this._then);

  final _AssignableJobsState _self;
  final $Res Function(_AssignableJobsState) _then;

/// Create a copy of AssignableJobsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextCursor = freezed,Object? error = freezed,Object? statusFilter = freezed,Object? assignedFilter = freezed,Object? technicianIdFilter = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_AssignableJobsState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as DomainError?,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ClaimStatus?,assignedFilter: freezed == assignedFilter ? _self.assignedFilter : assignedFilter // ignore: cast_nullable_to_non_nullable
as bool?,technicianIdFilter: freezed == technicianIdFilter ? _self.technicianIdFilter : technicianIdFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
