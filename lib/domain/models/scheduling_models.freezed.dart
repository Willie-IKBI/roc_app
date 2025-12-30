// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduling_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppointmentSlot {

 String get claimId; String get claimNumber; String get clientName; Address get address; DateTime get appointmentDate; String get appointmentTime; int get estimatedDurationMinutes; int? get travelTimeMinutes;// Travel time from previous appointment
 String? get technicianId; String? get technicianName; ClaimStatus get status; PriorityLevel get priority; DateTime? get appointmentDateTime;
/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentSlotCopyWith<AppointmentSlot> get copyWith => _$AppointmentSlotCopyWithImpl<AppointmentSlot>(this as AppointmentSlot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentSlot&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.address, address) || other.address == address)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.estimatedDurationMinutes, estimatedDurationMinutes) || other.estimatedDurationMinutes == estimatedDurationMinutes)&&(identical(other.travelTimeMinutes, travelTimeMinutes) || other.travelTimeMinutes == travelTimeMinutes)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.appointmentDateTime, appointmentDateTime) || other.appointmentDateTime == appointmentDateTime));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,clientName,address,appointmentDate,appointmentTime,estimatedDurationMinutes,travelTimeMinutes,technicianId,technicianName,status,priority,appointmentDateTime);

@override
String toString() {
  return 'AppointmentSlot(claimId: $claimId, claimNumber: $claimNumber, clientName: $clientName, address: $address, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, estimatedDurationMinutes: $estimatedDurationMinutes, travelTimeMinutes: $travelTimeMinutes, technicianId: $technicianId, technicianName: $technicianName, status: $status, priority: $priority, appointmentDateTime: $appointmentDateTime)';
}


}

/// @nodoc
abstract mixin class $AppointmentSlotCopyWith<$Res>  {
  factory $AppointmentSlotCopyWith(AppointmentSlot value, $Res Function(AppointmentSlot) _then) = _$AppointmentSlotCopyWithImpl;
@useResult
$Res call({
 String claimId, String claimNumber, String clientName, Address address, DateTime appointmentDate, String appointmentTime, int estimatedDurationMinutes, int? travelTimeMinutes, String? technicianId, String? technicianName, ClaimStatus status, PriorityLevel priority, DateTime? appointmentDateTime
});


$AddressCopyWith<$Res> get address;

}
/// @nodoc
class _$AppointmentSlotCopyWithImpl<$Res>
    implements $AppointmentSlotCopyWith<$Res> {
  _$AppointmentSlotCopyWithImpl(this._self, this._then);

  final AppointmentSlot _self;
  final $Res Function(AppointmentSlot) _then;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claimId = null,Object? claimNumber = null,Object? clientName = null,Object? address = null,Object? appointmentDate = null,Object? appointmentTime = null,Object? estimatedDurationMinutes = null,Object? travelTimeMinutes = freezed,Object? technicianId = freezed,Object? technicianName = freezed,Object? status = null,Object? priority = null,Object? appointmentDateTime = freezed,}) {
  return _then(_self.copyWith(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,appointmentDate: null == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,estimatedDurationMinutes: null == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,travelTimeMinutes: freezed == travelTimeMinutes ? _self.travelTimeMinutes : travelTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,appointmentDateTime: freezed == appointmentDateTime ? _self.appointmentDateTime : appointmentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  String clientName,  Address address,  DateTime appointmentDate,  String appointmentTime,  int estimatedDurationMinutes,  int? travelTimeMinutes,  String? technicianId,  String? technicianName,  ClaimStatus status,  PriorityLevel priority,  DateTime? appointmentDateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.clientName,_that.address,_that.appointmentDate,_that.appointmentTime,_that.estimatedDurationMinutes,_that.travelTimeMinutes,_that.technicianId,_that.technicianName,_that.status,_that.priority,_that.appointmentDateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String claimId,  String claimNumber,  String clientName,  Address address,  DateTime appointmentDate,  String appointmentTime,  int estimatedDurationMinutes,  int? travelTimeMinutes,  String? technicianId,  String? technicianName,  ClaimStatus status,  PriorityLevel priority,  DateTime? appointmentDateTime)  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlot():
return $default(_that.claimId,_that.claimNumber,_that.clientName,_that.address,_that.appointmentDate,_that.appointmentTime,_that.estimatedDurationMinutes,_that.travelTimeMinutes,_that.technicianId,_that.technicianName,_that.status,_that.priority,_that.appointmentDateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String claimId,  String claimNumber,  String clientName,  Address address,  DateTime appointmentDate,  String appointmentTime,  int estimatedDurationMinutes,  int? travelTimeMinutes,  String? technicianId,  String? technicianName,  ClaimStatus status,  PriorityLevel priority,  DateTime? appointmentDateTime)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentSlot() when $default != null:
return $default(_that.claimId,_that.claimNumber,_that.clientName,_that.address,_that.appointmentDate,_that.appointmentTime,_that.estimatedDurationMinutes,_that.travelTimeMinutes,_that.technicianId,_that.technicianName,_that.status,_that.priority,_that.appointmentDateTime);case _:
  return null;

}
}

}

/// @nodoc


class _AppointmentSlot extends AppointmentSlot {
  const _AppointmentSlot({required this.claimId, required this.claimNumber, required this.clientName, required this.address, required this.appointmentDate, required this.appointmentTime, required this.estimatedDurationMinutes, this.travelTimeMinutes, this.technicianId, this.technicianName, required this.status, required this.priority, this.appointmentDateTime}): super._();
  

@override final  String claimId;
@override final  String claimNumber;
@override final  String clientName;
@override final  Address address;
@override final  DateTime appointmentDate;
@override final  String appointmentTime;
@override final  int estimatedDurationMinutes;
@override final  int? travelTimeMinutes;
// Travel time from previous appointment
@override final  String? technicianId;
@override final  String? technicianName;
@override final  ClaimStatus status;
@override final  PriorityLevel priority;
@override final  DateTime? appointmentDateTime;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentSlotCopyWith<_AppointmentSlot> get copyWith => __$AppointmentSlotCopyWithImpl<_AppointmentSlot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentSlot&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.address, address) || other.address == address)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.estimatedDurationMinutes, estimatedDurationMinutes) || other.estimatedDurationMinutes == estimatedDurationMinutes)&&(identical(other.travelTimeMinutes, travelTimeMinutes) || other.travelTimeMinutes == travelTimeMinutes)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.appointmentDateTime, appointmentDateTime) || other.appointmentDateTime == appointmentDateTime));
}


@override
int get hashCode => Object.hash(runtimeType,claimId,claimNumber,clientName,address,appointmentDate,appointmentTime,estimatedDurationMinutes,travelTimeMinutes,technicianId,technicianName,status,priority,appointmentDateTime);

@override
String toString() {
  return 'AppointmentSlot(claimId: $claimId, claimNumber: $claimNumber, clientName: $clientName, address: $address, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, estimatedDurationMinutes: $estimatedDurationMinutes, travelTimeMinutes: $travelTimeMinutes, technicianId: $technicianId, technicianName: $technicianName, status: $status, priority: $priority, appointmentDateTime: $appointmentDateTime)';
}


}

/// @nodoc
abstract mixin class _$AppointmentSlotCopyWith<$Res> implements $AppointmentSlotCopyWith<$Res> {
  factory _$AppointmentSlotCopyWith(_AppointmentSlot value, $Res Function(_AppointmentSlot) _then) = __$AppointmentSlotCopyWithImpl;
@override @useResult
$Res call({
 String claimId, String claimNumber, String clientName, Address address, DateTime appointmentDate, String appointmentTime, int estimatedDurationMinutes, int? travelTimeMinutes, String? technicianId, String? technicianName, ClaimStatus status, PriorityLevel priority, DateTime? appointmentDateTime
});


@override $AddressCopyWith<$Res> get address;

}
/// @nodoc
class __$AppointmentSlotCopyWithImpl<$Res>
    implements _$AppointmentSlotCopyWith<$Res> {
  __$AppointmentSlotCopyWithImpl(this._self, this._then);

  final _AppointmentSlot _self;
  final $Res Function(_AppointmentSlot) _then;

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claimId = null,Object? claimNumber = null,Object? clientName = null,Object? address = null,Object? appointmentDate = null,Object? appointmentTime = null,Object? estimatedDurationMinutes = null,Object? travelTimeMinutes = freezed,Object? technicianId = freezed,Object? technicianName = freezed,Object? status = null,Object? priority = null,Object? appointmentDateTime = freezed,}) {
  return _then(_AppointmentSlot(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,appointmentDate: null == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentTime: null == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String,estimatedDurationMinutes: null == estimatedDurationMinutes ? _self.estimatedDurationMinutes : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,travelTimeMinutes: freezed == travelTimeMinutes ? _self.travelTimeMinutes : travelTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,technicianName: freezed == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,appointmentDateTime: freezed == appointmentDateTime ? _self.appointmentDateTime : appointmentDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AppointmentSlot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

/// @nodoc
mixin _$TechnicianSchedule {

 String get technicianId; String get technicianName; DateTime get date; List<AppointmentSlot> get appointments; int get workStartHour;// Default: 8am
 int get workEndHour;
/// Create a copy of TechnicianSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianScheduleCopyWith<TechnicianSchedule> get copyWith => _$TechnicianScheduleCopyWithImpl<TechnicianSchedule>(this as TechnicianSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianSchedule&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.appointments, appointments)&&(identical(other.workStartHour, workStartHour) || other.workStartHour == workStartHour)&&(identical(other.workEndHour, workEndHour) || other.workEndHour == workEndHour));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,technicianName,date,const DeepCollectionEquality().hash(appointments),workStartHour,workEndHour);

@override
String toString() {
  return 'TechnicianSchedule(technicianId: $technicianId, technicianName: $technicianName, date: $date, appointments: $appointments, workStartHour: $workStartHour, workEndHour: $workEndHour)';
}


}

/// @nodoc
abstract mixin class $TechnicianScheduleCopyWith<$Res>  {
  factory $TechnicianScheduleCopyWith(TechnicianSchedule value, $Res Function(TechnicianSchedule) _then) = _$TechnicianScheduleCopyWithImpl;
@useResult
$Res call({
 String technicianId, String technicianName, DateTime date, List<AppointmentSlot> appointments, int workStartHour, int workEndHour
});




}
/// @nodoc
class _$TechnicianScheduleCopyWithImpl<$Res>
    implements $TechnicianScheduleCopyWith<$Res> {
  _$TechnicianScheduleCopyWithImpl(this._self, this._then);

  final TechnicianSchedule _self;
  final $Res Function(TechnicianSchedule) _then;

/// Create a copy of TechnicianSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicianId = null,Object? technicianName = null,Object? date = null,Object? appointments = null,Object? workStartHour = null,Object? workEndHour = null,}) {
  return _then(_self.copyWith(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,workStartHour: null == workStartHour ? _self.workStartHour : workStartHour // ignore: cast_nullable_to_non_nullable
as int,workEndHour: null == workEndHour ? _self.workEndHour : workEndHour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianSchedule].
extension TechnicianSchedulePatterns on TechnicianSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianSchedule value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> appointments,  int workStartHour,  int workEndHour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianSchedule() when $default != null:
return $default(_that.technicianId,_that.technicianName,_that.date,_that.appointments,_that.workStartHour,_that.workEndHour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> appointments,  int workStartHour,  int workEndHour)  $default,) {final _that = this;
switch (_that) {
case _TechnicianSchedule():
return $default(_that.technicianId,_that.technicianName,_that.date,_that.appointments,_that.workStartHour,_that.workEndHour);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> appointments,  int workStartHour,  int workEndHour)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianSchedule() when $default != null:
return $default(_that.technicianId,_that.technicianName,_that.date,_that.appointments,_that.workStartHour,_that.workEndHour);case _:
  return null;

}
}

}

/// @nodoc


class _TechnicianSchedule extends TechnicianSchedule {
  const _TechnicianSchedule({required this.technicianId, required this.technicianName, required this.date, required final  List<AppointmentSlot> appointments, this.workStartHour = 8, this.workEndHour = 17}): _appointments = appointments,super._();
  

@override final  String technicianId;
@override final  String technicianName;
@override final  DateTime date;
 final  List<AppointmentSlot> _appointments;
@override List<AppointmentSlot> get appointments {
  if (_appointments is EqualUnmodifiableListView) return _appointments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appointments);
}

@override@JsonKey() final  int workStartHour;
// Default: 8am
@override@JsonKey() final  int workEndHour;

/// Create a copy of TechnicianSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianScheduleCopyWith<_TechnicianSchedule> get copyWith => __$TechnicianScheduleCopyWithImpl<_TechnicianSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianSchedule&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._appointments, _appointments)&&(identical(other.workStartHour, workStartHour) || other.workStartHour == workStartHour)&&(identical(other.workEndHour, workEndHour) || other.workEndHour == workEndHour));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,technicianName,date,const DeepCollectionEquality().hash(_appointments),workStartHour,workEndHour);

@override
String toString() {
  return 'TechnicianSchedule(technicianId: $technicianId, technicianName: $technicianName, date: $date, appointments: $appointments, workStartHour: $workStartHour, workEndHour: $workEndHour)';
}


}

/// @nodoc
abstract mixin class _$TechnicianScheduleCopyWith<$Res> implements $TechnicianScheduleCopyWith<$Res> {
  factory _$TechnicianScheduleCopyWith(_TechnicianSchedule value, $Res Function(_TechnicianSchedule) _then) = __$TechnicianScheduleCopyWithImpl;
@override @useResult
$Res call({
 String technicianId, String technicianName, DateTime date, List<AppointmentSlot> appointments, int workStartHour, int workEndHour
});




}
/// @nodoc
class __$TechnicianScheduleCopyWithImpl<$Res>
    implements _$TechnicianScheduleCopyWith<$Res> {
  __$TechnicianScheduleCopyWithImpl(this._self, this._then);

  final _TechnicianSchedule _self;
  final $Res Function(_TechnicianSchedule) _then;

/// Create a copy of TechnicianSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicianId = null,Object? technicianName = null,Object? date = null,Object? appointments = null,Object? workStartHour = null,Object? workEndHour = null,}) {
  return _then(_TechnicianSchedule(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,appointments: null == appointments ? _self._appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,workStartHour: null == workStartHour ? _self.workStartHour : workStartHour // ignore: cast_nullable_to_non_nullable
as int,workEndHour: null == workEndHour ? _self.workEndHour : workEndHour // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DaySchedule {

 DateTime get date; List<TechnicianSchedule> get technicianSchedules; List<AppointmentSlot> get unassignedAppointments;
/// Create a copy of DaySchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayScheduleCopyWith<DaySchedule> get copyWith => _$DayScheduleCopyWithImpl<DaySchedule>(this as DaySchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySchedule&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.technicianSchedules, technicianSchedules)&&const DeepCollectionEquality().equals(other.unassignedAppointments, unassignedAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(technicianSchedules),const DeepCollectionEquality().hash(unassignedAppointments));

@override
String toString() {
  return 'DaySchedule(date: $date, technicianSchedules: $technicianSchedules, unassignedAppointments: $unassignedAppointments)';
}


}

/// @nodoc
abstract mixin class $DayScheduleCopyWith<$Res>  {
  factory $DayScheduleCopyWith(DaySchedule value, $Res Function(DaySchedule) _then) = _$DayScheduleCopyWithImpl;
@useResult
$Res call({
 DateTime date, List<TechnicianSchedule> technicianSchedules, List<AppointmentSlot> unassignedAppointments
});




}
/// @nodoc
class _$DayScheduleCopyWithImpl<$Res>
    implements $DayScheduleCopyWith<$Res> {
  _$DayScheduleCopyWithImpl(this._self, this._then);

  final DaySchedule _self;
  final $Res Function(DaySchedule) _then;

/// Create a copy of DaySchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? technicianSchedules = null,Object? unassignedAppointments = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,technicianSchedules: null == technicianSchedules ? _self.technicianSchedules : technicianSchedules // ignore: cast_nullable_to_non_nullable
as List<TechnicianSchedule>,unassignedAppointments: null == unassignedAppointments ? _self.unassignedAppointments : unassignedAppointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,
  ));
}

}


/// Adds pattern-matching-related methods to [DaySchedule].
extension DaySchedulePatterns on DaySchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySchedule value)  $default,){
final _that = this;
switch (_that) {
case _DaySchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DaySchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  List<TechnicianSchedule> technicianSchedules,  List<AppointmentSlot> unassignedAppointments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySchedule() when $default != null:
return $default(_that.date,_that.technicianSchedules,_that.unassignedAppointments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  List<TechnicianSchedule> technicianSchedules,  List<AppointmentSlot> unassignedAppointments)  $default,) {final _that = this;
switch (_that) {
case _DaySchedule():
return $default(_that.date,_that.technicianSchedules,_that.unassignedAppointments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  List<TechnicianSchedule> technicianSchedules,  List<AppointmentSlot> unassignedAppointments)?  $default,) {final _that = this;
switch (_that) {
case _DaySchedule() when $default != null:
return $default(_that.date,_that.technicianSchedules,_that.unassignedAppointments);case _:
  return null;

}
}

}

/// @nodoc


class _DaySchedule extends DaySchedule {
  const _DaySchedule({required this.date, required final  List<TechnicianSchedule> technicianSchedules, required final  List<AppointmentSlot> unassignedAppointments}): _technicianSchedules = technicianSchedules,_unassignedAppointments = unassignedAppointments,super._();
  

@override final  DateTime date;
 final  List<TechnicianSchedule> _technicianSchedules;
@override List<TechnicianSchedule> get technicianSchedules {
  if (_technicianSchedules is EqualUnmodifiableListView) return _technicianSchedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technicianSchedules);
}

 final  List<AppointmentSlot> _unassignedAppointments;
@override List<AppointmentSlot> get unassignedAppointments {
  if (_unassignedAppointments is EqualUnmodifiableListView) return _unassignedAppointments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unassignedAppointments);
}


/// Create a copy of DaySchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayScheduleCopyWith<_DaySchedule> get copyWith => __$DayScheduleCopyWithImpl<_DaySchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySchedule&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._technicianSchedules, _technicianSchedules)&&const DeepCollectionEquality().equals(other._unassignedAppointments, _unassignedAppointments));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_technicianSchedules),const DeepCollectionEquality().hash(_unassignedAppointments));

@override
String toString() {
  return 'DaySchedule(date: $date, technicianSchedules: $technicianSchedules, unassignedAppointments: $unassignedAppointments)';
}


}

/// @nodoc
abstract mixin class _$DayScheduleCopyWith<$Res> implements $DayScheduleCopyWith<$Res> {
  factory _$DayScheduleCopyWith(_DaySchedule value, $Res Function(_DaySchedule) _then) = __$DayScheduleCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, List<TechnicianSchedule> technicianSchedules, List<AppointmentSlot> unassignedAppointments
});




}
/// @nodoc
class __$DayScheduleCopyWithImpl<$Res>
    implements _$DayScheduleCopyWith<$Res> {
  __$DayScheduleCopyWithImpl(this._self, this._then);

  final _DaySchedule _self;
  final $Res Function(_DaySchedule) _then;

/// Create a copy of DaySchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? technicianSchedules = null,Object? unassignedAppointments = null,}) {
  return _then(_DaySchedule(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,technicianSchedules: null == technicianSchedules ? _self._technicianSchedules : technicianSchedules // ignore: cast_nullable_to_non_nullable
as List<TechnicianSchedule>,unassignedAppointments: null == unassignedAppointments ? _self._unassignedAppointments : unassignedAppointments // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,
  ));
}


}

/// @nodoc
mixin _$RouteOptimization {

 String get technicianId; String get technicianName; DateTime get date; List<AppointmentSlot> get optimizedOrder; List<int> get travelTimes;// Travel time between each pair
 int get totalTravelTimeMinutes; int get totalWorkTimeMinutes; List<String>? get conflicts;
/// Create a copy of RouteOptimization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteOptimizationCopyWith<RouteOptimization> get copyWith => _$RouteOptimizationCopyWithImpl<RouteOptimization>(this as RouteOptimization, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteOptimization&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.optimizedOrder, optimizedOrder)&&const DeepCollectionEquality().equals(other.travelTimes, travelTimes)&&(identical(other.totalTravelTimeMinutes, totalTravelTimeMinutes) || other.totalTravelTimeMinutes == totalTravelTimeMinutes)&&(identical(other.totalWorkTimeMinutes, totalWorkTimeMinutes) || other.totalWorkTimeMinutes == totalWorkTimeMinutes)&&const DeepCollectionEquality().equals(other.conflicts, conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,technicianName,date,const DeepCollectionEquality().hash(optimizedOrder),const DeepCollectionEquality().hash(travelTimes),totalTravelTimeMinutes,totalWorkTimeMinutes,const DeepCollectionEquality().hash(conflicts));

@override
String toString() {
  return 'RouteOptimization(technicianId: $technicianId, technicianName: $technicianName, date: $date, optimizedOrder: $optimizedOrder, travelTimes: $travelTimes, totalTravelTimeMinutes: $totalTravelTimeMinutes, totalWorkTimeMinutes: $totalWorkTimeMinutes, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class $RouteOptimizationCopyWith<$Res>  {
  factory $RouteOptimizationCopyWith(RouteOptimization value, $Res Function(RouteOptimization) _then) = _$RouteOptimizationCopyWithImpl;
@useResult
$Res call({
 String technicianId, String technicianName, DateTime date, List<AppointmentSlot> optimizedOrder, List<int> travelTimes, int totalTravelTimeMinutes, int totalWorkTimeMinutes, List<String>? conflicts
});




}
/// @nodoc
class _$RouteOptimizationCopyWithImpl<$Res>
    implements $RouteOptimizationCopyWith<$Res> {
  _$RouteOptimizationCopyWithImpl(this._self, this._then);

  final RouteOptimization _self;
  final $Res Function(RouteOptimization) _then;

/// Create a copy of RouteOptimization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicianId = null,Object? technicianName = null,Object? date = null,Object? optimizedOrder = null,Object? travelTimes = null,Object? totalTravelTimeMinutes = null,Object? totalWorkTimeMinutes = null,Object? conflicts = freezed,}) {
  return _then(_self.copyWith(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,optimizedOrder: null == optimizedOrder ? _self.optimizedOrder : optimizedOrder // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,travelTimes: null == travelTimes ? _self.travelTimes : travelTimes // ignore: cast_nullable_to_non_nullable
as List<int>,totalTravelTimeMinutes: null == totalTravelTimeMinutes ? _self.totalTravelTimeMinutes : totalTravelTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,totalWorkTimeMinutes: null == totalWorkTimeMinutes ? _self.totalWorkTimeMinutes : totalWorkTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,conflicts: freezed == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteOptimization].
extension RouteOptimizationPatterns on RouteOptimization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteOptimization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteOptimization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteOptimization value)  $default,){
final _that = this;
switch (_that) {
case _RouteOptimization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteOptimization value)?  $default,){
final _that = this;
switch (_that) {
case _RouteOptimization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> optimizedOrder,  List<int> travelTimes,  int totalTravelTimeMinutes,  int totalWorkTimeMinutes,  List<String>? conflicts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteOptimization() when $default != null:
return $default(_that.technicianId,_that.technicianName,_that.date,_that.optimizedOrder,_that.travelTimes,_that.totalTravelTimeMinutes,_that.totalWorkTimeMinutes,_that.conflicts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> optimizedOrder,  List<int> travelTimes,  int totalTravelTimeMinutes,  int totalWorkTimeMinutes,  List<String>? conflicts)  $default,) {final _that = this;
switch (_that) {
case _RouteOptimization():
return $default(_that.technicianId,_that.technicianName,_that.date,_that.optimizedOrder,_that.travelTimes,_that.totalTravelTimeMinutes,_that.totalWorkTimeMinutes,_that.conflicts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String technicianId,  String technicianName,  DateTime date,  List<AppointmentSlot> optimizedOrder,  List<int> travelTimes,  int totalTravelTimeMinutes,  int totalWorkTimeMinutes,  List<String>? conflicts)?  $default,) {final _that = this;
switch (_that) {
case _RouteOptimization() when $default != null:
return $default(_that.technicianId,_that.technicianName,_that.date,_that.optimizedOrder,_that.travelTimes,_that.totalTravelTimeMinutes,_that.totalWorkTimeMinutes,_that.conflicts);case _:
  return null;

}
}

}

/// @nodoc


class _RouteOptimization extends RouteOptimization {
  const _RouteOptimization({required this.technicianId, required this.technicianName, required this.date, required final  List<AppointmentSlot> optimizedOrder, required final  List<int> travelTimes, required this.totalTravelTimeMinutes, required this.totalWorkTimeMinutes, final  List<String>? conflicts}): _optimizedOrder = optimizedOrder,_travelTimes = travelTimes,_conflicts = conflicts,super._();
  

@override final  String technicianId;
@override final  String technicianName;
@override final  DateTime date;
 final  List<AppointmentSlot> _optimizedOrder;
@override List<AppointmentSlot> get optimizedOrder {
  if (_optimizedOrder is EqualUnmodifiableListView) return _optimizedOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optimizedOrder);
}

 final  List<int> _travelTimes;
@override List<int> get travelTimes {
  if (_travelTimes is EqualUnmodifiableListView) return _travelTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_travelTimes);
}

// Travel time between each pair
@override final  int totalTravelTimeMinutes;
@override final  int totalWorkTimeMinutes;
 final  List<String>? _conflicts;
@override List<String>? get conflicts {
  final value = _conflicts;
  if (value == null) return null;
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RouteOptimization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteOptimizationCopyWith<_RouteOptimization> get copyWith => __$RouteOptimizationCopyWithImpl<_RouteOptimization>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteOptimization&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._optimizedOrder, _optimizedOrder)&&const DeepCollectionEquality().equals(other._travelTimes, _travelTimes)&&(identical(other.totalTravelTimeMinutes, totalTravelTimeMinutes) || other.totalTravelTimeMinutes == totalTravelTimeMinutes)&&(identical(other.totalWorkTimeMinutes, totalWorkTimeMinutes) || other.totalWorkTimeMinutes == totalWorkTimeMinutes)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts));
}


@override
int get hashCode => Object.hash(runtimeType,technicianId,technicianName,date,const DeepCollectionEquality().hash(_optimizedOrder),const DeepCollectionEquality().hash(_travelTimes),totalTravelTimeMinutes,totalWorkTimeMinutes,const DeepCollectionEquality().hash(_conflicts));

@override
String toString() {
  return 'RouteOptimization(technicianId: $technicianId, technicianName: $technicianName, date: $date, optimizedOrder: $optimizedOrder, travelTimes: $travelTimes, totalTravelTimeMinutes: $totalTravelTimeMinutes, totalWorkTimeMinutes: $totalWorkTimeMinutes, conflicts: $conflicts)';
}


}

/// @nodoc
abstract mixin class _$RouteOptimizationCopyWith<$Res> implements $RouteOptimizationCopyWith<$Res> {
  factory _$RouteOptimizationCopyWith(_RouteOptimization value, $Res Function(_RouteOptimization) _then) = __$RouteOptimizationCopyWithImpl;
@override @useResult
$Res call({
 String technicianId, String technicianName, DateTime date, List<AppointmentSlot> optimizedOrder, List<int> travelTimes, int totalTravelTimeMinutes, int totalWorkTimeMinutes, List<String>? conflicts
});




}
/// @nodoc
class __$RouteOptimizationCopyWithImpl<$Res>
    implements _$RouteOptimizationCopyWith<$Res> {
  __$RouteOptimizationCopyWithImpl(this._self, this._then);

  final _RouteOptimization _self;
  final $Res Function(_RouteOptimization) _then;

/// Create a copy of RouteOptimization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicianId = null,Object? technicianName = null,Object? date = null,Object? optimizedOrder = null,Object? travelTimes = null,Object? totalTravelTimeMinutes = null,Object? totalWorkTimeMinutes = null,Object? conflicts = freezed,}) {
  return _then(_RouteOptimization(
technicianId: null == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String,technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,optimizedOrder: null == optimizedOrder ? _self._optimizedOrder : optimizedOrder // ignore: cast_nullable_to_non_nullable
as List<AppointmentSlot>,travelTimes: null == travelTimes ? _self._travelTimes : travelTimes // ignore: cast_nullable_to_non_nullable
as List<int>,totalTravelTimeMinutes: null == totalTravelTimeMinutes ? _self.totalTravelTimeMinutes : totalTravelTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,totalWorkTimeMinutes: null == totalWorkTimeMinutes ? _self.totalWorkTimeMinutes : totalWorkTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,conflicts: freezed == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
mixin _$AvailabilityWindow {

 DateTime get startTime; DateTime get endTime; int get durationMinutes;
/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityWindowCopyWith<AvailabilityWindow> get copyWith => _$AvailabilityWindowCopyWithImpl<AvailabilityWindow>(this as AvailabilityWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityWindow&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,durationMinutes);

@override
String toString() {
  return 'AvailabilityWindow(startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $AvailabilityWindowCopyWith<$Res>  {
  factory $AvailabilityWindowCopyWith(AvailabilityWindow value, $Res Function(AvailabilityWindow) _then) = _$AvailabilityWindowCopyWithImpl;
@useResult
$Res call({
 DateTime startTime, DateTime endTime, int durationMinutes
});




}
/// @nodoc
class _$AvailabilityWindowCopyWithImpl<$Res>
    implements $AvailabilityWindowCopyWith<$Res> {
  _$AvailabilityWindowCopyWithImpl(this._self, this._then);

  final AvailabilityWindow _self;
  final $Res Function(AvailabilityWindow) _then;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityWindow].
extension AvailabilityWindowPatterns on AvailabilityWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityWindow value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityWindow value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startTime,  DateTime endTime,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
return $default(_that.startTime,_that.endTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startTime,  DateTime endTime,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityWindow():
return $default(_that.startTime,_that.endTime,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startTime,  DateTime endTime,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
return $default(_that.startTime,_that.endTime,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _AvailabilityWindow extends AvailabilityWindow {
  const _AvailabilityWindow({required this.startTime, required this.endTime, required this.durationMinutes}): super._();
  

@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  int durationMinutes;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityWindowCopyWith<_AvailabilityWindow> get copyWith => __$AvailabilityWindowCopyWithImpl<_AvailabilityWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityWindow&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,durationMinutes);

@override
String toString() {
  return 'AvailabilityWindow(startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityWindowCopyWith<$Res> implements $AvailabilityWindowCopyWith<$Res> {
  factory _$AvailabilityWindowCopyWith(_AvailabilityWindow value, $Res Function(_AvailabilityWindow) _then) = __$AvailabilityWindowCopyWithImpl;
@override @useResult
$Res call({
 DateTime startTime, DateTime endTime, int durationMinutes
});




}
/// @nodoc
class __$AvailabilityWindowCopyWithImpl<$Res>
    implements _$AvailabilityWindowCopyWith<$Res> {
  __$AvailabilityWindowCopyWithImpl(this._self, this._then);

  final _AvailabilityWindow _self;
  final $Res Function(_AvailabilityWindow) _then;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,}) {
  return _then(_AvailabilityWindow(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
