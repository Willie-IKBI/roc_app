// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technician_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppointmentSlot {

 String get claimId; String get appointmentTime; String get status;
/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentSlotCopyWith<AppointmentSlot> get copyWith => _$AppointmentSlotCopyWithImpl<AppointmentSlot>(this as AppointmentSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentSlot&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,appointmentTime,status);

@override
String toString() {
  return 'AppointmentSlot(claimId: $claimId, appointmentTime: $appointmentTime, status: $status)';
}


}

/// @nodoc
abstract mixin class $AppointmentSlotCopyWith<$Res>  {
  factory $AppointmentSlotCopyWith(AppointmentSlot value, $Res Function(AppointmentSlot) _then) = _$AppointmentSlotCopyWithImpl;
@useResult
$Res call({
 String claimId, String appointmentTime, String status
});




}
/// @nodoc
class _$AppointmentSlotCopyWithImpl<$Res>
    implements $AppointmentSlotCopyWith<$Res> {
  _$AppointmentSlotCopyWithImpl(this._self, this._then);

  final AppointmentSlot _self;
  final $Res Function(AppointmentSlot) _then;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claimId = null,Object? appointmentTime = null,Object? status = null,}) {
  return _then(_self.copyWith(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentSlot].
extension AppointmentSlotPatterns on AppointmentSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentSlot value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentSlot value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String claimId,  String appointmentTime,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
return $default(_that.claimId,_that.appointmentTime,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String claimId,  String appointmentTime,  String status)  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlot():
return $default(_that.claimId,_that.appointmentTime,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String claimId,  String appointmentTime,  String status)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
return $default(_that.claimId,_that.appointmentTime,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AppointmentSlot implements AppointmentSlot {
  const _AppointmentSlot({required this.claimId, required this.appointmentTime, required this.status});
  

@override final  String claimId;
@override final  String appointmentTime;
@override final  String status;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentSlotCopyWith<_AppointmentSlot> get copyWith => __$AppointmentSlotCopyWithImpl<_AppointmentSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentSlot&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,appointmentTime,status);

@override
String toString() {
  return 'AppointmentSlot(claimId: $claimId, appointmentTime: $appointmentTime, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AppointmentSlotCopyWith<$Res> implements $AppointmentSlotCopyWith<$Res> {
  factory _$AppointmentSlotCopyWith(_AppointmentSlot value, $Res Function(_AppointmentSlot) _then) = __$AppointmentSlotCopyWithImpl;
@override @useResult
$Res call({
 String claimId, String appointmentTime, String status
});




}
/// @nodoc
class __$AppointmentSlotCopyWithImpl<$Res>
    implements _$AppointmentSlotCopyWith<$Res> {
  __$AppointmentSlotCopyWithImpl(this._self, this._then);

  final _AppointmentSlot _self;
  final $Res Function(_AppointmentSlot) _then;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claimId = null,Object? appointmentTime = null,Object? status = null,}) {
  return _then(_AppointmentSlot(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TechnicianAvailability {

 String get technicianId; DateTime get date; List<AppointmentSlot> get appointments; List<String> get availableSlots; int get totalAppointments;
/// Create a copy of TechnicianAvailability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianAvailabilityCopyWith<TechnicianAvailability> get copyWith => _$TechnicianAvailabilityCopyWithImpl<TechnicianAvailability>(this as TechnicianAvailability, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianAvailability&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.appointments, appointments)&&const DeepCollectionEquality().equals(other.availableSlots, availableSlots)&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,date,const DeepCollectionEquality().hash(appointments),const DeepCollectionEquality().hash(availableSlots),totalAppointments);

@override
String toString() {
  return 'TechnicianAvailability(technicianId: $technicianId, date: $date, appointments: $appointments, availableSlots: $availableSlots, totalAppointments: $totalAppointments)';
}


}

/// @nodoc
abstract mixin class $TechnicianAvailabilityCopyWith<$Res>  {
  factory $TechnicianAvailabilityCopyWith(TechnicianAvailability value, $Res Function(TechnicianAvailability) _then) = _$TechnicianAvailabilityCopyWithImpl;
@useResult
$Res call({
 String technicianId, DateTime date, List<AppointmentSlot> appointments, List<String> availableSlots, int totalAppointments
});




}
/// @nodoc
class _$TechnicianAvailabilityCopyWithImpl<$Res>
    implements $TechnicianAvailabilityCopyWith<$Res> {
  _$TechnicianAvailabilityCopyWithImpl(this._self, this._then);

  final TechnicianAvailability _self;
  final $Res Function(TechnicianAvailability) _then;

/// Create a copy of TechnicianAvailability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicianId = null,Object? date = null,Object? appointments = null,Object? availableSlots = null,Object? totalAppointments = null,}) {
  return _then(_self.copyWith(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,availableSlots: null == availableSlots ? _self.availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as List<String>,totalAppointments: null == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianAvailability].
extension TechnicianAvailabilityPatterns on TechnicianAvailability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianAvailability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianAvailability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianAvailability value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianAvailability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianAvailability value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianAvailability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String technicianId,  DateTime date,  List<AppointmentSlot> appointments,  List<String> availableSlots,  int totalAppointments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianAvailability() when $default != null:
return $default(_that.technicianId,_that.date,_that.appointments,_that.availableSlots,_that.totalAppointments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String technicianId,  DateTime date,  List<AppointmentSlot> appointments,  List<String> availableSlots,  int totalAppointments)  $default,) {final _that = this;
switch (_that) {
case _TechnicianAvailability():
return $default(_that.technicianId,_that.date,_that.appointments,_that.availableSlots,_that.totalAppointments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String technicianId,  DateTime date,  List<AppointmentSlot> appointments,  List<String> availableSlots,  int totalAppointments)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianAvailability() when $default != null:
return $default(_that.technicianId,_that.date,_that.appointments,_that.availableSlots,_that.totalAppointments);case _:
  return null;

}
}

}

/// @nodoc


class _TechnicianAvailability implements TechnicianAvailability {
  const _TechnicianAvailability({required this.technicianId, required this.date, required final  List<AppointmentSlot> appointments, required final  List<String> availableSlots, required this.totalAppointments}): _appointments = appointments,_availableSlots = availableSlots;
  

@override final  String technicianId;
@override final  DateTime date;
 final  List<AppointmentSlot> _appointments;
@override List<AppointmentSlot> get appointments {
  if (_appointments is EqualUnmodifiableListView) return _appointments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appointments);
}

 final  List<String> _availableSlots;
@override List<String> get availableSlots {
  if (_availableSlots is EqualUnmodifiableListView) return _availableSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableSlots);
}

@override final  int totalAppointments;

/// Create a copy of TechnicianAvailability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianAvailabilityCopyWith<_TechnicianAvailability> get copyWith => __$TechnicianAvailabilityCopyWithImpl<_TechnicianAvailability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianAvailability&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._appointments, _appointments)&&const DeepCollectionEquality().equals(other._availableSlots, _availableSlots)&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,date,const DeepCollectionEquality().hash(_appointments),const DeepCollectionEquality().hash(_availableSlots),totalAppointments);

@override
String toString() {
  return 'TechnicianAvailability(technicianId: $technicianId, date: $date, appointments: $appointments, availableSlots: $availableSlots, totalAppointments: $totalAppointments)';
}


}

/// @nodoc
abstract mixin class _$TechnicianAvailabilityCopyWith<$Res> implements $TechnicianAvailabilityCopyWith<$Res> {
  factory _$TechnicianAvailabilityCopyWith(_TechnicianAvailability value, $Res Function(_TechnicianAvailability) _then) = __$TechnicianAvailabilityCopyWithImpl;
@override @useResult
$Res call({
 String technicianId, DateTime date, List<AppointmentSlot> appointments, List<String> availableSlots, int totalAppointments
});




}
/// @nodoc
class __$TechnicianAvailabilityCopyWithImpl<$Res>
    implements _$TechnicianAvailabilityCopyWith<$Res> {
  __$TechnicianAvailabilityCopyWithImpl(this._self, this._then);

  final _TechnicianAvailability _self;
  final $Res Function(_TechnicianAvailability) _then;

/// Create a copy of TechnicianAvailability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicianId = null,Object? date = null,Object? appointments = null,Object? availableSlots = null,Object? totalAppointments = null,}) {
  return _then(_TechnicianAvailability(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,appointments: null == appointments ? _self._appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,availableSlots: null == availableSlots ? _self._availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as List<String>,totalAppointments: null == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
