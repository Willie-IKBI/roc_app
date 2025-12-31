import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, SupabaseClient;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/claim_draft.dart';
import '../../domain/models/paginated_result.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../models/address_row.dart';
import '../models/claim_item_row.dart';
import '../models/claim_row.dart';
import '../models/claim_status_history_row.dart';
import '../models/claim_summary_row.dart';
import '../models/client_row.dart';
import '../models/contact_attempt_row.dart';
import 'claim_remote_data_source.dart';

class SupabaseClaimRemoteDataSource implements ClaimRemoteDataSource {
  SupabaseClaimRemoteDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Result<PaginatedResult<ClaimSummaryRow>>> fetchQueuePage({
    String? cursor,
    int limit = 50,
    ClaimStatus? status,
  }) async {
    try {
      // Validate limit
      final pageSize = limit.clamp(1, 100);

      // Build query
      var query = _client.from('v_claims_list').select('*');

      // Apply status filter (server-side)
      if (status != null) {
        query = query.eq('status', status.value);
      }

      // Apply cursor (pagination)
      // Cursor condition: (sla_started_at > cursor_sla) OR
      //                   (sla_started_at = cursor_sla AND claim_id > cursor_id)
      if (cursor != null) {
        final parts = cursor.split('|');
        if (parts.length == 2) {
          final cursorSlaStartedAt = DateTime.parse(parts[0]);
          final cursorClaimId = parts[1];

          // PostgREST filter: (sla_started_at > cursor) OR
          //                  (sla_started_at = cursor AND claim_id > cursor_id)
          // Format: "column1.gt.value1,column1.eq.value1.column2.gt.value2"
          query = query.or(
            'sla_started_at.gt.$cursorSlaStartedAt,sla_started_at.eq.$cursorSlaStartedAt.claim_id.gt.$cursorClaimId',
          );
        }
      }

      // Apply ordering and limit (chain directly to avoid type mismatch)
      final data = await query
          .order('sla_started_at', ascending: true)
          .order('claim_id', ascending: true)
          .limit(pageSize + 1);

      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ClaimSummaryRow.fromJson)
          .toList();

      // Check if we have more data
      final hasMore = rows.length > pageSize;
      final items =
          hasMore ? rows.take(pageSize).toList(growable: false) : rows;

      // Generate next cursor from last item (even if no more data, for consistency)
      String? nextCursor;
      if (items.isNotEmpty) {
        final lastItem = items.last;
        nextCursor =
            '${lastItem.slaStartedAt.toIso8601String()}|${lastItem.claimId}';
      }

      return Result.ok(PaginatedResult(
        items: items,
        nextCursor: nextCursor,
        hasMore: hasMore,
      ));
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch claims queue page (cursor: $cursor, status: $status)',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching claims queue page',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  @Deprecated('Use fetchQueuePage instead. This method will be removed in a future version.')
  Future<Result<List<ClaimSummaryRow>>> fetchQueue({
    ClaimStatus? status,
  }) async {
    try {
      // Safety limit: enforce maximum of 1000 claims even if more exist
      // This prevents unbounded queries that could cause performance issues
      const maxLimit = 1000;
      
      AppLogger.warn(
        'fetchQueue() is deprecated and limited to $maxLimit claims. Use fetchQueuePage() for pagination. '
        'This method will be removed in a future version.',
        name: 'SupabaseClaimRemoteDataSource',
      );
      
      var query = _client.from('v_claims_list').select('*');
      if (status != null) {
        query = query.eq('status', status.value);
      }
      final data = await query
          .order('sla_started_at', ascending: true)
          .limit(maxLimit);
      
      final rows = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ClaimSummaryRow.fromJson)
          .toList(growable: false);
      
      // Warn if we hit the limit (may indicate data was truncated)
      if (rows.length >= maxLimit) {
        AppLogger.warn(
          'fetchQueue() returned $maxLimit claims (limit reached). Results may be truncated. '
          'Migrate to fetchQueuePage() for proper pagination.',
          name: 'SupabaseClaimRemoteDataSource',
        );
      }
      
      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch claims queue (status: $status)',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching claims queue (status: $status)',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<ClaimRow>> fetchClaim(String claimId) async {
    try {
      final data = await _client
          .from('claims')
          .select(
            'id, tenant_id, claim_number, insurer_id, client_id, address_id, service_provider_id, das_number, status, priority, damage_cause, damage_description, surge_protection_at_db, surge_protection_at_plug, agent_id, technician_id, appointment_date, appointment_time, sla_started_at, closed_at, notes_public, notes_internal, created_at, updated_at',
          )
          .eq('id', claimId)
          .single();
      final record = Map<String, dynamic>.from(data as Map);
      return Result.ok(ClaimRow.fromJson(record));
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch claim: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching claim: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ClaimItemRow>>> fetchClaimItems(String claimId) async {
    try {
      final data = await _client
          .from('claim_items')
          .select('id, tenant_id, claim_id, brand, color, warranty, serial_or_model, notes, created_at, updated_at')
          .eq('claim_id', claimId)
          .order('created_at');

      final items = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ClaimItemRow.fromJson)
          .toList(growable: false);
      return Result.ok(items);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch claim items: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching claim items: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<ContactAttemptRow?>> fetchLatestContact(String claimId) async {
    try {
      final data = await _client
          .from('contact_attempts')
          .select('id, tenant_id, claim_id, attempted_by, attempted_at, method, outcome, notes')
          .eq('claim_id', claimId)
          .order('attempted_at', ascending: false)
          .limit(1)
          .maybeSingle();

      return Result.ok(
        data == null
            ? null
            : ContactAttemptRow.fromJson(
                Map<String, dynamic>.from(data as Map),
              ),
      );
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch latest contact: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching latest contact: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ContactAttemptRow>>> fetchContactAttempts(
    String claimId,
  ) async {
    try {
      final data = await _client
          .from('contact_attempts')
          .select('id, tenant_id, claim_id, attempted_by, attempted_at, method, outcome, notes')
          .eq('claim_id', claimId)
          .order('attempted_at', ascending: false);

      final attempts = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ContactAttemptRow.fromJson)
          .toList(growable: false);
      return Result.ok(attempts);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch contact attempts: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching contact attempts: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ClaimStatusHistoryRow>>> fetchStatusHistory(
    String claimId,
  ) async {
    try {
      final data = await _client
          .from('claim_status_history')
          .select('id, tenant_id, claim_id, from_status, to_status, changed_by, changed_at, reason')
          .eq('claim_id', claimId)
          .order('changed_at', ascending: false);

      final history = (data as List)
          .cast<Map<String, dynamic>>()
          .map(ClaimStatusHistoryRow.fromJson)
          .toList(growable: false);
      return Result.ok(history);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch status history: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching status history: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<ClientRow>> fetchClient(String clientId) async {
    try {
      final data = await _client
          .from('clients')
          .select('id, tenant_id, first_name, last_name, primary_phone, alt_phone, email, created_at, updated_at')
          .eq('id', clientId)
          .single();
      return Result.ok(
        ClientRow.fromJson(Map<String, dynamic>.from(data as Map)),
      );
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch client: $clientId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching client: $clientId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<AddressRow>> fetchAddress(String addressId) async {
    try {
      final data = await _client
          .from('addresses')
          .select('id, tenant_id, client_id, estate_id, google_place_id, unit_number, complex_or_estate, street, suburb, city, province, postal_code, country, lat, lng, notes, is_primary, created_at, updated_at, estate:estate_id(id, tenant_id, name, suburb, city, province, postal_code, created_at, updated_at)')
          .eq('id', addressId)
          .single();
      return Result.ok(
        AddressRow.fromJson(Map<String, dynamic>.from(data as Map)),
      );
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch address: $addressId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching address: $addressId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> createContactAttempt({
    required String claimId,
    required String tenantId,
    required String method,
    required String outcome,
    String? notes,
    bool sendSmsTemplate = false,
    String? smsTemplateId,
  }) async {
    final attemptedBy = _client.auth.currentUser?.id;
    if (attemptedBy == null) {
      return Result.err(const AuthError(code: 'not-authenticated'));
    }

    try {
      await _client.from('contact_attempts').insert({
        'tenant_id': tenantId,
        'claim_id': claimId,
        'attempted_by': attemptedBy,
        'method': method,
        'outcome': outcome,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      // TODO(phase2): SMS template integration via edge function or SMS provider.
      // This feature is planned for a future phase. When implemented, it should:
      // 1. Call a Supabase Edge Function or external SMS provider API
      // 2. Use the provided smsTemplateId to fetch and send the template
      // 3. Handle errors gracefully and log SMS sending failures

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to create contact attempt: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating contact attempt: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateClaimStatus({
    required String claimId,
    required String tenantId,
    required ClaimStatus fromStatus,
    required ClaimStatus toStatus,
    String? reason,
  }) async {
    final changedBy = _client.auth.currentUser?.id;

    try {
      final now = DateTime.now().toUtc();
      final updatePayload = <String, dynamic>{
        'status': toStatus.value,
        'updated_at': now.toIso8601String(),
      };

      if (toStatus == ClaimStatus.closed || toStatus == ClaimStatus.cancelled) {
        updatePayload['closed_at'] = now.toIso8601String();
      } else if (fromStatus == ClaimStatus.closed ||
          fromStatus == ClaimStatus.cancelled) {
        updatePayload['closed_at'] = null;
      }

      await _client.from('claims').update(updatePayload).eq('id', claimId);

      await _client.from('claim_status_history').insert({
        'tenant_id': tenantId,
        'claim_id': claimId,
        'from_status': fromStatus.value,
        'to_status': toStatus.value,
        'changed_by': changedBy,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      });

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to update claim status: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error updating claim status: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String>> createClaim(ClaimDraft draft) async {
    try {
      String? clientId = draft.clientId;
      if (clientId == null && draft.clientInput != null) {
        final clientResult = await createClient(
          tenantId: draft.tenantId,
          input: draft.clientInput!,
        );
        if (clientResult.isErr) return Result.err(clientResult.error);
        clientId = clientResult.data;
      }

      if (clientId == null) {
        return Result.err(ValidationError('Client details missing'));
      }

      String? addressId = draft.addressId;
      if (addressId == null && draft.addressInput != null) {
        final addressResult = await createAddress(
          tenantId: draft.tenantId,
          clientId: clientId,
          input: draft.addressInput!,
        );
        if (addressResult.isErr) return Result.err(addressResult.error);
        addressId = addressResult.data;
      }

      if (addressId == null) {
        return Result.err(ValidationError('Address details missing'));
      }

      String? serviceProviderId = draft.serviceProviderId;
      if (serviceProviderId == null && draft.serviceProviderInput != null) {
        final providerResult = await createServiceProvider(
          tenantId: draft.tenantId,
          input: draft.serviceProviderInput!,
        );
        if (providerResult.isErr) return Result.err(providerResult.error);
        serviceProviderId = providerResult.data;
      }

      final payload = <String, dynamic>{
        'tenant_id': draft.tenantId,
        'claim_number': draft.claimNumber,
        'insurer_id': draft.insurerId,
        'client_id': clientId,
        'address_id': addressId,
        'service_provider_id': serviceProviderId,
        'das_number': draft.dasNumber?.trim(),
        'priority': draft.priority.value,
        'damage_cause': draft.damageCause.value,
        'damage_description': draft.damageDescription,
        'surge_protection_at_db': draft.surgeProtectionAtDb,
        'surge_protection_at_plug': draft.surgeProtectionAtPlug,
        'agent_id': draft.agentId,
        'technician_id': draft.technicianId,
        'appointment_date': draft.appointmentDate?.toIso8601String().split('T')[0],
        'appointment_time': draft.appointmentTime,
        'notes_public': draft.clientNotes ?? draft.notesPublic,
        'notes_internal': draft.notesInternal,
      }..removeWhere((_, value) => value == null);

      final record = await _client
          .from('claims')
          .insert(payload)
          .select('id')
          .single();

      return Result.ok(record['id'] as String);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to create claim: ${draft.claimNumber}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating claim: ${draft.claimNumber}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> createClaimItems({
    required String claimId,
    required ClaimDraft draft,
  }) async {
    if (draft.items.isEmpty) {
      return const Result.ok(null);
    }

    final payload = draft.items
        .map(
          (item) => <String, dynamic>{
            'tenant_id': draft.tenantId,
            'claim_id': claimId,
            'brand': item.brand,
            'color': item.color,
            'warranty': item.warranty.value,
            'serial_or_model': item.serialOrModel,
            'notes': item.notes,
          }..removeWhere((_, value) => value == null),
        )
        .toList(growable: false);

    try {
      await _client.from('claim_items').insert(payload);
      return const Result.ok(null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to create claim items: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating claim items: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<bool>> claimExists({
    required String insurerId,
    required String claimNumber,
  }) async {
    try {
      final data = await _client
          .from('claims')
          .select('id')
          .eq('insurer_id', insurerId)
          .ilike('claim_number', claimNumber.trim())
          .limit(1)
          .maybeSingle();
      return Result.ok(data != null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to check claim existence: $insurerId / $claimNumber',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error checking claim existence: $insurerId / $claimNumber',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String>> createClient({
    required String tenantId,
    required ClientInput input,
  }) async {
    try {
      final record = await _client
          .from('clients')
          .insert({
            'tenant_id': tenantId,
            'first_name': input.firstName.trim(),
            'last_name': input.lastName.trim(),
            'primary_phone': input.primaryPhone.trim(),
            if (input.altPhone != null && input.altPhone!.trim().isNotEmpty)
              'alt_phone': input.altPhone!.trim(),
            if (input.email != null && input.email!.trim().isNotEmpty)
              'email': input.email!.trim(),
          })
          .select('id')
          .single();
      return Result.ok(record['id'] as String);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to create client: ${input.firstName} ${input.lastName}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating client: ${input.firstName} ${input.lastName}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String>> createAddress({
    required String tenantId,
    required String clientId,
    required AddressInput input,
  }) async {
    try {
      final record = await _client
          .from('addresses')
          .insert({
            'tenant_id': tenantId,
            'client_id': clientId,
            if (input.estateId != null && input.estateId!.isNotEmpty)
              'estate_id': input.estateId,
            if (input.complexOrEstate != null &&
                input.complexOrEstate!.trim().isNotEmpty)
              'complex_or_estate': input.complexOrEstate!.trim(),
            if (input.unitNumber != null && input.unitNumber!.trim().isNotEmpty)
              'unit_number': input.unitNumber!.trim(),
            'street': input.street.trim(),
            'suburb': input.suburb.trim(),
            'city': input.city.trim(),
            'province': input.province.trim(),
            'postal_code': input.postalCode.trim(),
            if (input.latitude != null) 'lat': input.latitude,
            if (input.longitude != null) 'lng': input.longitude,
            if (input.googlePlaceId != null &&
                input.googlePlaceId!.trim().isNotEmpty)
              'google_place_id': input.googlePlaceId!.trim(),
            if (input.notes != null && input.notes!.trim().isNotEmpty)
              'notes': input.notes!.trim(),
          })
          .select('id')
          .single();
      return Result.ok(record['id'] as String);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to create address: ${input.street}, ${input.city}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating address: ${input.street}, ${input.city}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<String?>> createServiceProvider({
    required String tenantId,
    required ServiceProviderInput input,
  }) async {
    try {
      final record = await _client
          .from('service_providers')
          .insert({
            'tenant_id': tenantId,
            'company_name': input.companyName.trim(),
            if (input.contactName != null &&
                input.contactName!.trim().isNotEmpty)
              'contact_name': input.contactName!.trim(),
            if (input.contactPhone != null &&
                input.contactPhone!.trim().isNotEmpty)
              'contact_phone': input.contactPhone!.trim(),
            if (input.contactEmail != null &&
                input.contactEmail!.trim().isNotEmpty)
              'contact_email': input.contactEmail!.trim(),
            if (input.referenceNumber != null &&
                input.referenceNumber!.trim().isNotEmpty)
              'reference_number_format': input.referenceNumber!.trim(),
          })
          .select('id')
          .maybeSingle();
      return Result.ok(record?['id'] as String?);
    } on PostgrestException catch (err) {
      // treat unique violation as returning existing provider
      if (err.code == '23505') {
        final company = input.companyName.trim();
        try {
          final existing = await _client
              .from('service_providers')
              .select('id')
              .eq('tenant_id', tenantId)
              .ilike('company_name', company)
              .limit(1)
              .maybeSingle();
          return Result.ok(existing?['id'] as String?);
        } catch (lookupErr) {
          AppLogger.error(
            'Failed to lookup existing service provider: $company',
            name: 'SupabaseClaimRemoteDataSource',
            error: lookupErr,
          );
          return Result.err(mapPostgrestException(err));
        }
      }
      AppLogger.error(
        'Failed to create service provider: ${input.companyName}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error creating service provider: ${input.companyName}',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateTechnician({
    required String claimId,
    required String tenantId,
    String? technicianId,
  }) async {
    try {
      final updatePayload = <String, dynamic>{
        'technician_id': technicianId,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      await _client.from('claims').update(updatePayload).eq('id', claimId);

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to update technician: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error updating technician: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<void>> updateAppointment({
    required String claimId,
    required String tenantId,
    DateTime? appointmentDate,
    String? appointmentTime,
  }) async {
    try {
      final updatePayload = <String, dynamic>{
        'appointment_date': appointmentDate?.toIso8601String().split('T')[0],
        'appointment_time': appointmentTime,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      await _client.from('claims').update(updatePayload).eq('id', claimId);

      return const Result.ok(null);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to update appointment: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error updating appointment: $claimId',
        name: 'SupabaseClaimRemoteDataSource',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }
}
