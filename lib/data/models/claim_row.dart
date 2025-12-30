import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/claim.dart';
import '../../domain/models/address.dart';
import '../../domain/models/claim_item.dart';
import '../../domain/models/claim_status_change.dart';
import '../../domain/models/client.dart';
import '../../domain/models/contact_attempt.dart';
import '../../domain/value_objects/claim_enums.dart';

part 'claim_row.g.dart';

@JsonSerializable()
class ClaimRow {
  ClaimRow({
    required this.id,
    required this.tenantId,
    required this.claimNumber,
    required this.insurerId,
    required this.clientId,
    required this.addressId,
    this.serviceProviderId,
    this.dasNumber,
    required this.status,
    required this.priority,
    required this.damageCause,
    this.damageDescription,
    required this.surgeProtectionAtDb,
    required this.surgeProtectionAtPlug,
    this.agentId,
    this.technicianId,
    this.appointmentDate,
    this.appointmentTime,
    required this.slaStartedAt,
    this.closedAt,
    this.notesPublic,
    this.notesInternal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClaimRow.fromJson(Map<String, dynamic> json) =>
      _$ClaimRowFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimRowToJson(this);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'claim_number')
  final String claimNumber;

  @JsonKey(name: 'insurer_id')
  final String insurerId;

  @JsonKey(name: 'client_id')
  final String clientId;

  @JsonKey(name: 'address_id')
  final String addressId;

  @JsonKey(name: 'service_provider_id')
  final String? serviceProviderId;

  @JsonKey(name: 'das_number')
  final String? dasNumber;

  final String status;

  final String priority;

  @JsonKey(name: 'damage_cause')
  final String damageCause;

  @JsonKey(name: 'damage_description')
  final String? damageDescription;

  @JsonKey(name: 'surge_protection_at_db')
  final bool surgeProtectionAtDb;

  @JsonKey(name: 'surge_protection_at_plug')
  final bool surgeProtectionAtPlug;

  @JsonKey(name: 'agent_id')
  final String? agentId;

  @JsonKey(name: 'technician_id')
  final String? technicianId;

  @JsonKey(name: 'appointment_date')
  final DateTime? appointmentDate;

  @JsonKey(name: 'appointment_time')
  final String? appointmentTime;

  @JsonKey(name: 'sla_started_at')
  final DateTime slaStartedAt;

  @JsonKey(name: 'closed_at')
  final DateTime? closedAt;

  @JsonKey(name: 'notes_public')
  final String? notesPublic;

  @JsonKey(name: 'notes_internal')
  final String? notesInternal;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Claim toDomain({
    List<ClaimItem> items = const [],
    ContactAttempt? latestContact,
    List<ContactAttempt> contactAttempts = const [],
    List<ClaimStatusChange> statusHistory = const [],
    Client? client,
    Address? address,
  }) {
    return Claim(
      id: id,
      tenantId: tenantId,
      claimNumber: claimNumber,
      insurerId: insurerId,
      clientId: clientId,
      addressId: addressId,
      serviceProviderId: serviceProviderId,
      dasNumber: dasNumber,
      status: ClaimStatus.fromJson(status),
      priority: PriorityLevel.fromJson(priority),
      damageCause: DamageCause.fromJson(damageCause),
      damageDescription: damageDescription,
      surgeProtectionAtDb: surgeProtectionAtDb,
      surgeProtectionAtPlug: surgeProtectionAtPlug,
      agentId: agentId,
      technicianId: technicianId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      slaStartedAt: slaStartedAt,
      closedAt: closedAt,
      notesPublic: notesPublic,
      notesInternal: notesInternal,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items,
      latestContact: latestContact,
      contactAttempts: contactAttempts,
      statusHistory: statusHistory,
      client: client,
      address: address,
    );
  }
}
