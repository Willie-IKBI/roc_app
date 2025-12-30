// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Claim {

 String get id; String get tenantId; String get claimNumber; String get insurerId; String get clientId; String get addressId; String? get serviceProviderId; String? get dasNumber; ClaimStatus get status; PriorityLevel get priority; DamageCause get damageCause; String? get damageDescription; bool get surgeProtectionAtDb; bool get surgeProtectionAtPlug; String? get agentId; String? get technicianId; DateTime? get appointmentDate; String? get appointmentTime; DateTime get slaStartedAt; DateTime? get closedAt; String? get notesPublic; String? get notesInternal; DateTime get createdAt; DateTime get updatedAt; List<ClaimItem> get items; ContactAttempt? get latestContact; List<ContactAttempt> get contactAttempts; List<ClaimStatusChange> get statusHistory; Client? get client; Address? get address;
/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimCopyWith<Claim> get copyWith => _$ClaimCopyWithImpl<Claim>(this as Claim, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Claim&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.serviceProviderId, serviceProviderId) || other.serviceProviderId == serviceProviderId)&&(identical(other.dasNumber, dasNumber) || other.dasNumber == dasNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.damageDescription, damageDescription) || other.damageDescription == damageDescription)&&(identical(other.surgeProtectionAtDb, surgeProtectionAtDb) || other.surgeProtectionAtDb == surgeProtectionAtDb)&&(identical(other.surgeProtectionAtPlug, surgeProtectionAtPlug) || other.surgeProtectionAtPlug == surgeProtectionAtPlug)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.slaStartedAt, slaStartedAt) || other.slaStartedAt == slaStartedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.notesPublic, notesPublic) || other.notesPublic == notesPublic)&&(identical(other.notesInternal, notesInternal) || other.notesInternal == notesInternal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.latestContact, latestContact) || other.latestContact == latestContact)&&const DeepCollectionEquality().equals(other.contactAttempts, contactAttempts)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory)&&(identical(other.client, client) || other.client == client)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,claimNumber,insurerId,clientId,addressId,serviceProviderId,dasNumber,status,priority,damageCause,damageDescription,surgeProtectionAtDb,surgeProtectionAtPlug,agentId,technicianId,appointmentDate,appointmentTime,slaStartedAt,closedAt,notesPublic,notesInternal,createdAt,updatedAt,const DeepCollectionEquality().hash(items),latestContact,const DeepCollectionEquality().hash(contactAttempts),const DeepCollectionEquality().hash(statusHistory),client,address]);

@override
String toString() {
  return 'Claim(id: $id, tenantId: $tenantId, claimNumber: $claimNumber, insurerId: $insurerId, clientId: $clientId, addressId: $addressId, serviceProviderId: $serviceProviderId, dasNumber: $dasNumber, status: $status, priority: $priority, damageCause: $damageCause, damageDescription: $damageDescription, surgeProtectionAtDb: $surgeProtectionAtDb, surgeProtectionAtPlug: $surgeProtectionAtPlug, agentId: $agentId, technicianId: $technicianId, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, slaStartedAt: $slaStartedAt, closedAt: $closedAt, notesPublic: $notesPublic, notesInternal: $notesInternal, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, latestContact: $latestContact, contactAttempts: $contactAttempts, statusHistory: $statusHistory, client: $client, address: $address)';
}


}

/// @nodoc
abstract mixin class $ClaimCopyWith<$Res>  {
  factory $ClaimCopyWith(Claim value, $Res Function(Claim) _then) = _$ClaimCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String claimNumber, String insurerId, String clientId, String addressId, String? serviceProviderId, String? dasNumber, ClaimStatus status, PriorityLevel priority, DamageCause damageCause, String? damageDescription, bool surgeProtectionAtDb, bool surgeProtectionAtPlug, String? agentId, String? technicianId, DateTime? appointmentDate, String? appointmentTime, DateTime slaStartedAt, DateTime? closedAt, String? notesPublic, String? notesInternal, DateTime createdAt, DateTime updatedAt, List<ClaimItem> items, ContactAttempt? latestContact, List<ContactAttempt> contactAttempts, List<ClaimStatusChange> statusHistory, Client? client, Address? address
});


$ContactAttemptCopyWith<$Res>? get latestContact;$ClientCopyWith<$Res>? get client;$AddressCopyWith<$Res>? get address;

}
/// @nodoc
class _$ClaimCopyWithImpl<$Res>
    implements $ClaimCopyWith<$Res> {
  _$ClaimCopyWithImpl(this._self, this._then);

  final Claim _self;
  final $Res Function(Claim) _then;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? claimNumber = null,Object? insurerId = null,Object? clientId = null,Object? addressId = null,Object? serviceProviderId = freezed,Object? dasNumber = freezed,Object? status = null,Object? priority = null,Object? damageCause = null,Object? damageDescription = freezed,Object? surgeProtectionAtDb = null,Object? surgeProtectionAtPlug = null,Object? agentId = freezed,Object? technicianId = freezed,Object? appointmentDate = freezed,Object? appointmentTime = freezed,Object? slaStartedAt = null,Object? closedAt = freezed,Object? notesPublic = freezed,Object? notesInternal = freezed,Object? createdAt = null,Object? updatedAt = null,Object? items = null,Object? latestContact = freezed,Object? contactAttempts = null,Object? statusHistory = null,Object? client = freezed,Object? address = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,serviceProviderId: freezed == serviceProviderId ? _self.serviceProviderId : serviceProviderId // ignore: cast_nullable_to_non_nullable
as String?,dasNumber: freezed == dasNumber ? _self.dasNumber : dasNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,damageDescription: freezed == damageDescription ? _self.damageDescription : damageDescription // ignore: cast_nullable_to_non_nullable
as String?,surgeProtectionAtDb: null == surgeProtectionAtDb ? _self.surgeProtectionAtDb : surgeProtectionAtDb // ignore: cast_nullable_to_non_nullable
as bool,surgeProtectionAtPlug: null == surgeProtectionAtPlug ? _self.surgeProtectionAtPlug : surgeProtectionAtPlug // ignore: cast_nullable_to_non_nullable
as bool,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,appointmentDate: freezed == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,appointmentTime: freezed == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String?,slaStartedAt: null == slaStartedAt ? _self.slaStartedAt : slaStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notesPublic: freezed == notesPublic ? _self.notesPublic : notesPublic // ignore: cast_nullable_to_non_nullable
as String?,notesInternal: freezed == notesInternal ? _self.notesInternal : notesInternal // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimItem>,latestContact: freezed == latestContact ? _self.latestContact : latestContact // ignore: cast_nullable_to_non_nullable
as ContactAttempt?,contactAttempts: null == contactAttempts ? _self.contactAttempts : contactAttempts // ignore: cast_nullable_to_non_nullable
as List<ContactAttempt>,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<ClaimStatusChange>,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,
  ));
}
/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactAttemptCopyWith<$Res>? get latestContact {
    if (_self.latestContact == null) {
    return null;
  }

  return $ContactAttemptCopyWith<$Res>(_self.latestContact!, (value) {
    return _then(_self.copyWith(latestContact: value));
  });
}/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $ClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [Claim].
extension ClaimPatterns on Claim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Claim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Claim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Claim value)  $default,){
final _that = this;
switch (_that) {
case _Claim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Claim value)?  $default,){
final _that = this;
switch (_that) {
case _Claim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimNumber,  String insurerId,  String clientId,  String addressId,  String? serviceProviderId,  String? dasNumber,  ClaimStatus status,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? technicianId,  DateTime? appointmentDate,  String? appointmentTime,  DateTime slaStartedAt,  DateTime? closedAt,  String? notesPublic,  String? notesInternal,  DateTime createdAt,  DateTime updatedAt,  List<ClaimItem> items,  ContactAttempt? latestContact,  List<ContactAttempt> contactAttempts,  List<ClaimStatusChange> statusHistory,  Client? client,  Address? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Claim() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.addressId,_that.serviceProviderId,_that.dasNumber,_that.status,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.technicianId,_that.appointmentDate,_that.appointmentTime,_that.slaStartedAt,_that.closedAt,_that.notesPublic,_that.notesInternal,_that.createdAt,_that.updatedAt,_that.items,_that.latestContact,_that.contactAttempts,_that.statusHistory,_that.client,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String claimNumber,  String insurerId,  String clientId,  String addressId,  String? serviceProviderId,  String? dasNumber,  ClaimStatus status,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? technicianId,  DateTime? appointmentDate,  String? appointmentTime,  DateTime slaStartedAt,  DateTime? closedAt,  String? notesPublic,  String? notesInternal,  DateTime createdAt,  DateTime updatedAt,  List<ClaimItem> items,  ContactAttempt? latestContact,  List<ContactAttempt> contactAttempts,  List<ClaimStatusChange> statusHistory,  Client? client,  Address? address)  $default,) {final _that = this;
switch (_that) {
case _Claim():
return $default(_that.id,_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.addressId,_that.serviceProviderId,_that.dasNumber,_that.status,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.technicianId,_that.appointmentDate,_that.appointmentTime,_that.slaStartedAt,_that.closedAt,_that.notesPublic,_that.notesInternal,_that.createdAt,_that.updatedAt,_that.items,_that.latestContact,_that.contactAttempts,_that.statusHistory,_that.client,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String claimNumber,  String insurerId,  String clientId,  String addressId,  String? serviceProviderId,  String? dasNumber,  ClaimStatus status,  PriorityLevel priority,  DamageCause damageCause,  String? damageDescription,  bool surgeProtectionAtDb,  bool surgeProtectionAtPlug,  String? agentId,  String? technicianId,  DateTime? appointmentDate,  String? appointmentTime,  DateTime slaStartedAt,  DateTime? closedAt,  String? notesPublic,  String? notesInternal,  DateTime createdAt,  DateTime updatedAt,  List<ClaimItem> items,  ContactAttempt? latestContact,  List<ContactAttempt> contactAttempts,  List<ClaimStatusChange> statusHistory,  Client? client,  Address? address)?  $default,) {final _that = this;
switch (_that) {
case _Claim() when $default != null:
return $default(_that.id,_that.tenantId,_that.claimNumber,_that.insurerId,_that.clientId,_that.addressId,_that.serviceProviderId,_that.dasNumber,_that.status,_that.priority,_that.damageCause,_that.damageDescription,_that.surgeProtectionAtDb,_that.surgeProtectionAtPlug,_that.agentId,_that.technicianId,_that.appointmentDate,_that.appointmentTime,_that.slaStartedAt,_that.closedAt,_that.notesPublic,_that.notesInternal,_that.createdAt,_that.updatedAt,_that.items,_that.latestContact,_that.contactAttempts,_that.statusHistory,_that.client,_that.address);case _:
  return null;

}
}

}

/// @nodoc


class _Claim extends Claim {
  const _Claim({required this.id, required this.tenantId, required this.claimNumber, required this.insurerId, required this.clientId, required this.addressId, this.serviceProviderId, this.dasNumber, this.status = ClaimStatus.newClaim, this.priority = PriorityLevel.normal, this.damageCause = DamageCause.other, this.damageDescription, this.surgeProtectionAtDb = false, this.surgeProtectionAtPlug = false, this.agentId, this.technicianId, this.appointmentDate, this.appointmentTime, required this.slaStartedAt, this.closedAt, this.notesPublic, this.notesInternal, required this.createdAt, required this.updatedAt, final  List<ClaimItem> items = const <ClaimItem>[], this.latestContact, final  List<ContactAttempt> contactAttempts = const <ContactAttempt>[], final  List<ClaimStatusChange> statusHistory = const <ClaimStatusChange>[], this.client, this.address}): _items = items,_contactAttempts = contactAttempts,_statusHistory = statusHistory,super._();
  

@override final  String id;
@override final  String tenantId;
@override final  String claimNumber;
@override final  String insurerId;
@override final  String clientId;
@override final  String addressId;
@override final  String? serviceProviderId;
@override final  String? dasNumber;
@override@JsonKey() final  ClaimStatus status;
@override@JsonKey() final  PriorityLevel priority;
@override@JsonKey() final  DamageCause damageCause;
@override final  String? damageDescription;
@override@JsonKey() final  bool surgeProtectionAtDb;
@override@JsonKey() final  bool surgeProtectionAtPlug;
@override final  String? agentId;
@override final  String? technicianId;
@override final  DateTime? appointmentDate;
@override final  String? appointmentTime;
@override final  DateTime slaStartedAt;
@override final  DateTime? closedAt;
@override final  String? notesPublic;
@override final  String? notesInternal;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<ClaimItem> _items;
@override@JsonKey() List<ClaimItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  ContactAttempt? latestContact;
 final  List<ContactAttempt> _contactAttempts;
@override@JsonKey() List<ContactAttempt> get contactAttempts {
  if (_contactAttempts is EqualUnmodifiableListView) return _contactAttempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contactAttempts);
}

 final  List<ClaimStatusChange> _statusHistory;
@override@JsonKey() List<ClaimStatusChange> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}

@override final  Client? client;
@override final  Address? address;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimCopyWith<_Claim> get copyWith => __$ClaimCopyWithImpl<_Claim>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Claim&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.claimNumber, claimNumber) || other.claimNumber == claimNumber)&&(identical(other.insurerId, insurerId) || other.insurerId == insurerId)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.serviceProviderId, serviceProviderId) || other.serviceProviderId == serviceProviderId)&&(identical(other.dasNumber, dasNumber) || other.dasNumber == dasNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.damageCause, damageCause) || other.damageCause == damageCause)&&(identical(other.damageDescription, damageDescription) || other.damageDescription == damageDescription)&&(identical(other.surgeProtectionAtDb, surgeProtectionAtDb) || other.surgeProtectionAtDb == surgeProtectionAtDb)&&(identical(other.surgeProtectionAtPlug, surgeProtectionAtPlug) || other.surgeProtectionAtPlug == surgeProtectionAtPlug)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.technicianId, technicianId) || other.technicianId == technicianId)&&(identical(other.appointmentDate, appointmentDate) || other.appointmentDate == appointmentDate)&&(identical(other.appointmentTime, appointmentTime) || other.appointmentTime == appointmentTime)&&(identical(other.slaStartedAt, slaStartedAt) || other.slaStartedAt == slaStartedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.notesPublic, notesPublic) || other.notesPublic == notesPublic)&&(identical(other.notesInternal, notesInternal) || other.notesInternal == notesInternal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.latestContact, latestContact) || other.latestContact == latestContact)&&const DeepCollectionEquality().equals(other._contactAttempts, _contactAttempts)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory)&&(identical(other.client, client) || other.client == client)&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,tenantId,claimNumber,insurerId,clientId,addressId,serviceProviderId,dasNumber,status,priority,damageCause,damageDescription,surgeProtectionAtDb,surgeProtectionAtPlug,agentId,technicianId,appointmentDate,appointmentTime,slaStartedAt,closedAt,notesPublic,notesInternal,createdAt,updatedAt,const DeepCollectionEquality().hash(_items),latestContact,const DeepCollectionEquality().hash(_contactAttempts),const DeepCollectionEquality().hash(_statusHistory),client,address]);

@override
String toString() {
  return 'Claim(id: $id, tenantId: $tenantId, claimNumber: $claimNumber, insurerId: $insurerId, clientId: $clientId, addressId: $addressId, serviceProviderId: $serviceProviderId, dasNumber: $dasNumber, status: $status, priority: $priority, damageCause: $damageCause, damageDescription: $damageDescription, surgeProtectionAtDb: $surgeProtectionAtDb, surgeProtectionAtPlug: $surgeProtectionAtPlug, agentId: $agentId, technicianId: $technicianId, appointmentDate: $appointmentDate, appointmentTime: $appointmentTime, slaStartedAt: $slaStartedAt, closedAt: $closedAt, notesPublic: $notesPublic, notesInternal: $notesInternal, createdAt: $createdAt, updatedAt: $updatedAt, items: $items, latestContact: $latestContact, contactAttempts: $contactAttempts, statusHistory: $statusHistory, client: $client, address: $address)';
}


}

/// @nodoc
abstract mixin class _$ClaimCopyWith<$Res> implements $ClaimCopyWith<$Res> {
  factory _$ClaimCopyWith(_Claim value, $Res Function(_Claim) _then) = __$ClaimCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String claimNumber, String insurerId, String clientId, String addressId, String? serviceProviderId, String? dasNumber, ClaimStatus status, PriorityLevel priority, DamageCause damageCause, String? damageDescription, bool surgeProtectionAtDb, bool surgeProtectionAtPlug, String? agentId, String? technicianId, DateTime? appointmentDate, String? appointmentTime, DateTime slaStartedAt, DateTime? closedAt, String? notesPublic, String? notesInternal, DateTime createdAt, DateTime updatedAt, List<ClaimItem> items, ContactAttempt? latestContact, List<ContactAttempt> contactAttempts, List<ClaimStatusChange> statusHistory, Client? client, Address? address
});


@override $ContactAttemptCopyWith<$Res>? get latestContact;@override $ClientCopyWith<$Res>? get client;@override $AddressCopyWith<$Res>? get address;

}
/// @nodoc
class __$ClaimCopyWithImpl<$Res>
    implements _$ClaimCopyWith<$Res> {
  __$ClaimCopyWithImpl(this._self, this._then);

  final _Claim _self;
  final $Res Function(_Claim) _then;

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? claimNumber = null,Object? insurerId = null,Object? clientId = null,Object? addressId = null,Object? serviceProviderId = freezed,Object? dasNumber = freezed,Object? status = null,Object? priority = null,Object? damageCause = null,Object? damageDescription = freezed,Object? surgeProtectionAtDb = null,Object? surgeProtectionAtPlug = null,Object? agentId = freezed,Object? technicianId = freezed,Object? appointmentDate = freezed,Object? appointmentTime = freezed,Object? slaStartedAt = null,Object? closedAt = freezed,Object? notesPublic = freezed,Object? notesInternal = freezed,Object? createdAt = null,Object? updatedAt = null,Object? items = null,Object? latestContact = freezed,Object? contactAttempts = null,Object? statusHistory = null,Object? client = freezed,Object? address = freezed,}) {
  return _then(_Claim(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,claimNumber: null == claimNumber ? _self.claimNumber : claimNumber // ignore: cast_nullable_to_non_nullable
as String,insurerId: null == insurerId ? _self.insurerId : insurerId // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,serviceProviderId: freezed == serviceProviderId ? _self.serviceProviderId : serviceProviderId // ignore: cast_nullable_to_non_nullable
as String?,dasNumber: freezed == dasNumber ? _self.dasNumber : dasNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ClaimStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as PriorityLevel,damageCause: null == damageCause ? _self.damageCause : damageCause // ignore: cast_nullable_to_non_nullable
as DamageCause,damageDescription: freezed == damageDescription ? _self.damageDescription : damageDescription // ignore: cast_nullable_to_non_nullable
as String?,surgeProtectionAtDb: null == surgeProtectionAtDb ? _self.surgeProtectionAtDb : surgeProtectionAtDb // ignore: cast_nullable_to_non_nullable
as bool,surgeProtectionAtPlug: null == surgeProtectionAtPlug ? _self.surgeProtectionAtPlug : surgeProtectionAtPlug // ignore: cast_nullable_to_non_nullable
as bool,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,technicianId: freezed == technicianId ? _self.technicianId : technicianId // ignore: cast_nullable_to_non_nullable
as String?,appointmentDate: freezed == appointmentDate ? _self.appointmentDate : appointmentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,appointmentTime: freezed == appointmentTime ? _self.appointmentTime : appointmentTime // ignore: cast_nullable_to_non_nullable
as String?,slaStartedAt: null == slaStartedAt ? _self.slaStartedAt : slaStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notesPublic: freezed == notesPublic ? _self.notesPublic : notesPublic // ignore: cast_nullable_to_non_nullable
as String?,notesInternal: freezed == notesInternal ? _self.notesInternal : notesInternal // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ClaimItem>,latestContact: freezed == latestContact ? _self.latestContact : latestContact // ignore: cast_nullable_to_non_nullable
as ContactAttempt?,contactAttempts: null == contactAttempts ? _self._contactAttempts : contactAttempts // ignore: cast_nullable_to_non_nullable
as List<ContactAttempt>,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<ClaimStatusChange>,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,
  ));
}

/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactAttemptCopyWith<$Res>? get latestContact {
    if (_self.latestContact == null) {
    return null;
  }

  return $ContactAttemptCopyWith<$Res>(_self.latestContact!, (value) {
    return _then(_self.copyWith(latestContact: value));
  });
}/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $ClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Claim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

// dart format on
