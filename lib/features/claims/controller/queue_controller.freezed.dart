// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClaimsQueueState {

 List<ClaimSummary> get items; bool get isLoading; bool get isLoadingMore; bool get hasMore; String? get nextCursor; DomainError? get error; ClaimStatus? get statusFilter;
/// Create a copy of ClaimsQueueState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimsQueueStateCopyWith<ClaimsQueueState> get copyWith => _$ClaimsQueueStateCopyWithImpl<ClaimsQueueState>(this as ClaimsQueueState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimsQueueState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.error, error) || other.error == error)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),isLoading,isLoadingMore,hasMore,nextCursor,error,statusFilter);

@override
String toString() {
  return 'ClaimsQueueState(items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextCursor: $nextCursor, error: $error, statusFilter: $statusFilter)';
}


}

/// @nodoc
abstract mixin class $ClaimsQueueStateCopyWith<$Res>  {
  factory $ClaimsQueueStateCopyWith(ClaimsQueueState value, $Res Function(ClaimsQueueState) _then) = _$ClaimsQueueStateCopyWithImpl;
@useResult
$Res call({
 List<ClaimSummary> items, bool isLoading, bool isLoadingMore, bool hasMore, String? nextCursor, DomainError? error, ClaimStatus? statusFilter
});




}
/// @nodoc
class _$ClaimsQueueStateCopyWithImpl<$Res>
    implements $ClaimsQueueStateCopyWith<$Res> {
  _$ClaimsQueueStateCopyWithImpl(this._self, this._then);

  final ClaimsQueueState _self;
  final $Res Function(ClaimsQueueState) _then;

/// Create a copy of ClaimsQueueState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextCursor = freezed,Object? error = freezed,Object? statusFilter = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as DomainError?,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ClaimStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimsQueueState].
extension ClaimsQueueStatePatterns on ClaimsQueueState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimsQueueState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimsQueueState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimsQueueState value)  $default,){
final _that = this;
switch (_that) {
case _ClaimsQueueState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimsQueueState value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimsQueueState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimsQueueState() when $default != null:
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter)  $default,) {final _that = this;
switch (_that) {
case _ClaimsQueueState():
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ClaimSummary> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  String? nextCursor,  DomainError? error,  ClaimStatus? statusFilter)?  $default,) {final _that = this;
switch (_that) {
case _ClaimsQueueState() when $default != null:
return $default(_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.nextCursor,_that.error,_that.statusFilter);case _:
  return null;

}
}

}

/// @nodoc


class _ClaimsQueueState implements ClaimsQueueState {
  const _ClaimsQueueState({final  List<ClaimSummary> items = const [], this.isLoading = false, this.isLoadingMore = false, this.hasMore = false, this.nextCursor, this.error, this.statusFilter}): _items = items;
  

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

/// Create a copy of ClaimsQueueState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimsQueueStateCopyWith<_ClaimsQueueState> get copyWith => __$ClaimsQueueStateCopyWithImpl<_ClaimsQueueState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimsQueueState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.error, error) || other.error == error)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isLoading,isLoadingMore,hasMore,nextCursor,error,statusFilter);

@override
String toString() {
  return 'ClaimsQueueState(items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextCursor: $nextCursor, error: $error, statusFilter: $statusFilter)';
}


}

/// @nodoc
abstract mixin class _$ClaimsQueueStateCopyWith<$Res> implements $ClaimsQueueStateCopyWith<$Res> {
  factory _$ClaimsQueueStateCopyWith(_ClaimsQueueState value, $Res Function(_ClaimsQueueState) _then) = __$ClaimsQueueStateCopyWithImpl;
@override @useResult
$Res call({
 List<ClaimSummary> items, bool isLoading, bool isLoadingMore, bool hasMore, String? nextCursor, DomainError? error, ClaimStatus? statusFilter
});




}
/// @nodoc
class __$ClaimsQueueStateCopyWithImpl<$Res>
    implements _$ClaimsQueueStateCopyWith<$Res> {
  __$ClaimsQueueStateCopyWithImpl(this._self, this._then);

  final _ClaimsQueueState _self;
  final $Res Function(_ClaimsQueueState) _then;

/// Create a copy of ClaimsQueueState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextCursor = freezed,Object? error = freezed,Object? statusFilter = freezed,}) {
  return _then(_ClaimsQueueState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimSummary>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as DomainError?,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as ClaimStatus?,
  ));
}


}

// dart format on
