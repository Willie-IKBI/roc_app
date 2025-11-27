import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:roc_app/core/errors/domain_error.dart';
import 'package:roc_app/core/utils/result.dart';
import 'package:roc_app/data/datasources/claim_remote_data_source.dart';
import 'package:roc_app/data/models/address_row.dart';
import 'package:roc_app/data/models/claim_item_row.dart';
import 'package:roc_app/data/models/claim_row.dart';
import 'package:roc_app/data/models/claim_status_history_row.dart';
import 'package:roc_app/data/models/claim_summary_row.dart';
import 'package:roc_app/data/models/client_row.dart';
import 'package:roc_app/data/models/contact_attempt_row.dart';
import 'package:roc_app/domain/models/contact_attempt_input.dart';
import 'package:roc_app/data/repositories/claim_repository_supabase.dart';
import 'package:roc_app/domain/models/claim_draft.dart';
import 'package:roc_app/domain/value_objects/claim_enums.dart';
import 'package:roc_app/domain/value_objects/contact_method.dart';

class _MockClaimRemoteDataSource extends Mock
    implements ClaimRemoteDataSource {}

void main() {
  late _MockClaimRemoteDataSource dataSource;
  late ClaimRepositorySupabase repository;

  setUp(() {
    dataSource = _MockClaimRemoteDataSource();
    repository = ClaimRepositorySupabase(dataSource);
  });

  final claimRow = ClaimRow(
    id: 'claim-1',
    tenantId: 'tenant-1',
    claimNumber: 'ROC-1',
    insurerId: 'insurer-1',
    clientId: 'client-1',
    addressId: 'address-1',
    serviceProviderId: null,
    status: ClaimStatus.inContact.value,
    priority: PriorityLevel.normal.value,
    damageCause: DamageCause.powerSurge.value,
    surgeProtectionAtDb: false,
    surgeProtectionAtPlug: false,
    agentId: 'agent-1',
    slaStartedAt: DateTime.utc(2025, 11, 1, 10),
    closedAt: null,
    notesPublic: null,
    notesInternal: 'Needs follow up',
    createdAt: DateTime.utc(2025, 11, 1, 9),
    updatedAt: DateTime.utc(2025, 11, 1, 12),
  );

  final itemRow = ClaimItemRow(
    id: 'item-1',
    tenantId: 'tenant-1',
    claimId: 'claim-1',
    brand: 'Samsung',
    color: 'Black',
    warranty: WarrantyStatus.inWarranty.value,
    serialOrModel: 'QA55Q70',
    notes: 'Damaged by surge',
    createdAt: DateTime.utc(2025, 11, 1, 10, 15),
    updatedAt: DateTime.utc(2025, 11, 1, 10, 15),
  );

  final contactRow = ContactAttemptRow(
    id: 'contact-1',
    tenantId: 'tenant-1',
    claimId: 'claim-1',
    attemptedBy: 'agent-1',
    attemptedAt: DateTime.utc(2025, 11, 1, 11),
    method: ContactMethod.phone.value,
    outcome: ContactOutcome.answered.value,
    notes: 'Confirmed visit',
  );

  final contactListRow = ContactAttemptRow(
    id: 'contact-2',
    tenantId: 'tenant-1',
    claimId: 'claim-1',
    attemptedBy: 'agent-1',
    attemptedAt: DateTime.utc(2025, 11, 1, 9, 30),
    method: ContactMethod.sms.value,
    outcome: ContactOutcome.smsSent.value,
    notes: 'Sent reminder',
  );

  final statusChangeRow = ClaimStatusHistoryRow(
    id: 'status-1',
    tenantId: 'tenant-1',
    claimId: 'claim-1',
    fromStatus: ClaimStatus.newClaim.value,
    toStatus: ClaimStatus.inContact.value,
    changedBy: 'agent-1',
    changedAt: DateTime.utc(2025, 11, 1, 11, 5),
    reason: 'Reached client',
  );

  final clientRow = ClientRow(
    id: 'client-1',
    tenantId: 'tenant-1',
    firstName: 'Thandi',
    lastName: 'Nkosi',
    primaryPhone: '+27123456789',
    altPhone: null,
    email: 'thandi@example.com',
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 10, 31),
  );

  final addressRow = AddressRow(
    id: 'address-1',
    tenantId: 'tenant-1',
    clientId: 'client-1',
    complexOrEstate: 'Sunset Villas',
    unitNumber: '15B',
    street: 'Sunset Road',
    suburb: 'Bryanston',
    postalCode: '2191',
    city: 'Johannesburg',
    province: 'Gauteng',
    country: 'South Africa',
    latitude: -26.067,
    longitude: 28.047,
    googlePlaceId: null,
    isPrimary: true,
    createdAt: DateTime.utc(2025, 1, 1),
    updatedAt: DateTime.utc(2025, 1, 1),
  );

  group('fetchQueue', () {
    test('returns mapped domain list on success', () async {
      final row = ClaimSummaryRow(
        claimId: 'claim-1',
        claimNumber: 'ROC-1',
        clientFullName: 'Thandi Nkosi',
        primaryPhone: '+27123456789',
        insurerName: 'InsureCo',
        status: ClaimStatus.inContact.value,
        priority: PriorityLevel.high.value,
        slaStartedAt: DateTime.utc(2025, 11, 1, 10),
        elapsedMinutes: 90,
        latestContactAttemptAt: DateTime.utc(2025, 11, 1, 11),
        latestContactOutcome: 'answered',
        slaTargetMinutes: 240,
        attemptCount: 2,
        retryIntervalMinutes: 120,
        nextRetryAt: DateTime.utc(2025, 11, 1, 13),
        readyForRetry: false,
        addressShort: '15 Sunset Road, Bryanston',
      );

      when(() => dataSource.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.ok([row]));

      final result = await repository.fetchQueue();

      expect(result.isOk, isTrue);
      expect(result.data, hasLength(1));
      expect(result.data.first.claimId, equals('claim-1'));
      expect(result.data.first.status, ClaimStatus.inContact);
      verify(() => dataSource.fetchQueue(status: null)).called(1);
    });

    test('propagates error from data source', () async {
      final error = const PermissionDeniedError();
      when(() => dataSource.fetchQueue(status: any(named: 'status')))
          .thenAnswer((_) async => Result.err(error));

      final result = await repository.fetchQueue(status: ClaimStatus.newClaim);

      expect(result.isErr, isTrue);
      expect(result.error, error);
      verify(() => dataSource.fetchQueue(status: ClaimStatus.newClaim)).called(1);
    });
  });

  group('fetchById', () {

    test('hydrates claim with items, contact attempts, status history, client and address', () async {
      when(() => dataSource.fetchClaim('claim-1'))
          .thenAnswer((_) async => Result.ok(claimRow));
      when(() => dataSource.fetchClaimItems('claim-1'))
          .thenAnswer((_) async => Result.ok([itemRow]));
      when(() => dataSource.fetchLatestContact('claim-1'))
          .thenAnswer((_) async => Result.ok(contactRow));
      when(() => dataSource.fetchContactAttempts('claim-1'))
          .thenAnswer((_) async => Result.ok([contactRow, contactListRow]));
      when(() => dataSource.fetchStatusHistory('claim-1'))
          .thenAnswer((_) async => Result.ok([statusChangeRow]));
      when(() => dataSource.fetchClient('client-1'))
          .thenAnswer((_) async => Result.ok(clientRow));
      when(() => dataSource.fetchAddress('address-1'))
          .thenAnswer((_) async => Result.ok(addressRow));

      final result = await repository.fetchById('claim-1');

      expect(result.isOk, isTrue);
      final claim = result.data;
      expect(claim.id, equals('claim-1'));
      expect(claim.items, hasLength(1));
      expect(claim.latestContact?.outcome, ContactOutcome.answered);
      expect(claim.contactAttempts, hasLength(2));
      expect(claim.statusHistory, hasLength(1));
      expect(claim.client?.fullName, 'Thandi Nkosi');
      expect(claim.address?.street, 'Sunset Road');
      verify(() => dataSource.fetchClaim('claim-1')).called(1);
      verify(() => dataSource.fetchClaimItems('claim-1')).called(1);
      verify(() => dataSource.fetchLatestContact('claim-1')).called(1);
      verify(() => dataSource.fetchContactAttempts('claim-1')).called(1);
      verify(() => dataSource.fetchStatusHistory('claim-1')).called(1);
      verify(() => dataSource.fetchClient('client-1')).called(1);
      verify(() => dataSource.fetchAddress('address-1')).called(1);
    });

    test('returns error if claim fetch fails', () async {
      final error = const NotFoundError('claim');
      when(() => dataSource.fetchClaim('missing'))
          .thenAnswer((_) async => Result.err(error));

      final result = await repository.fetchById('missing');

      expect(result.isErr, isTrue);
      expect(result.error, error);
      verify(() => dataSource.fetchClaim('missing')).called(1);
      verifyNever(() => dataSource.fetchClaimItems(any()));
      verifyNever(() => dataSource.fetchContactAttempts(any()));
    });
  });

  group('createClaim', () {
    final draft = ClaimDraft(
      tenantId: 'tenant-1',
      claimNumber: 'ROC-1',
      insurerId: 'insurer-1',
      clientId: 'client-1',
      addressId: 'address-1',
      items: const [
        ClaimItemDraft(
          brand: 'Samsung',
          warranty: WarrantyStatus.inWarranty,
          notes: 'Damaged',
        ),
      ],
    );

    setUp(() {
      registerFallbackValue(draft);
    });

    test('returns new claim id and persists items', () async {
      when(() => dataSource.createClaim(any()))
          .thenAnswer((_) async => const Result.ok('claim-1'));
      when(
        () => dataSource.createClaimItems(
          claimId: any(named: 'claimId'),
          draft: any(named: 'draft'),
        ),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await repository.createClaim(draft: draft);

      expect(result.isOk, isTrue);
      expect(result.data, equals('claim-1'));
      verify(() => dataSource.createClaim(draft)).called(1);
      verify(() => dataSource.createClaimItems(claimId: 'claim-1', draft: draft))
          .called(1);
    });

    test('propagates error when createClaim fails', () async {
      final error = const AuthError(code: '401');
      when(() => dataSource.createClaim(any()))
          .thenAnswer((_) async => Result.err(error));

      final result = await repository.createClaim(draft: draft);

      expect(result.isErr, isTrue);
      expect(result.error, error);
      verify(() => dataSource.createClaim(draft)).called(1);
      verifyNever(() => dataSource.createClaimItems(
            claimId: any(named: 'claimId'),
            draft: any(named: 'draft'),
          ));
    });

    test('propagates error when createClaimItems fails', () async {
      final error = const ValidationError('invalid item');
      when(() => dataSource.createClaim(any()))
          .thenAnswer((_) async => const Result.ok('claim-1'));
      when(
        () => dataSource.createClaimItems(
          claimId: any(named: 'claimId'),
          draft: any(named: 'draft'),
        ),
      ).thenAnswer((_) async => Result.err(error));

      final result = await repository.createClaim(draft: draft);

      expect(result.isErr, isTrue);
      expect(result.error, error);
      verify(() => dataSource.createClaim(draft)).called(1);
      verify(() => dataSource.createClaimItems(claimId: 'claim-1', draft: draft))
          .called(1);
    });
  });

  group('addContactAttempt', () {
    final attemptInput = ContactAttemptInput(
      method: ContactMethod.phone,
      outcome: ContactOutcome.noAnswer,
      notes: 'Left voicemail',
    );

    setUp(() {
      when(() => dataSource.fetchClaim('claim-1'))
          .thenAnswer((_) async => Result.ok(claimRow));
      when(() => dataSource.fetchClaimItems('claim-1'))
          .thenAnswer((_) async => Result.ok([itemRow]));
      when(() => dataSource.fetchLatestContact('claim-1'))
          .thenAnswer((_) async => Result.ok(contactRow));
      when(() => dataSource.fetchContactAttempts('claim-1'))
          .thenAnswer((_) async => Result.ok([contactRow]));
      when(() => dataSource.fetchStatusHistory('claim-1'))
          .thenAnswer((_) async => Result.ok([statusChangeRow]));
      when(() => dataSource.fetchClient('client-1'))
          .thenAnswer((_) async => Result.ok(clientRow));
      when(() => dataSource.fetchAddress('address-1'))
          .thenAnswer((_) async => Result.ok(addressRow));
    });

    test('persists contact attempt then reloads claim', () async {
      when(
        () => dataSource.createContactAttempt(
          claimId: 'claim-1',
          tenantId: 'tenant-1',
          method: attemptInput.method.value,
          outcome: attemptInput.outcome.value,
          notes: attemptInput.notes,
          sendSmsTemplate: attemptInput.sendSmsTemplate,
          smsTemplateId: attemptInput.smsTemplateId,
        ),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await repository.addContactAttempt(
        claimId: 'claim-1',
        draft: attemptInput,
      );

      expect(result.isOk, isTrue);
      verify(() => dataSource.createContactAttempt(
            claimId: 'claim-1',
            tenantId: 'tenant-1',
            method: attemptInput.method.value,
            outcome: attemptInput.outcome.value,
            notes: attemptInput.notes,
            sendSmsTemplate: attemptInput.sendSmsTemplate,
            smsTemplateId: attemptInput.smsTemplateId,
          )).called(1);
      verify(() => dataSource.fetchContactAttempts('claim-1')).called(1);
    });
  });

  group('changeStatus', () {
    setUp(() {
      when(() => dataSource.fetchClaim('claim-1'))
          .thenAnswer((_) async => Result.ok(claimRow));
      when(() => dataSource.fetchClaimItems('claim-1'))
          .thenAnswer((_) async => Result.ok([itemRow]));
      when(() => dataSource.fetchLatestContact('claim-1'))
          .thenAnswer((_) async => Result.ok(contactRow));
      when(() => dataSource.fetchContactAttempts('claim-1'))
          .thenAnswer((_) async => Result.ok([contactRow]));
      when(() => dataSource.fetchStatusHistory('claim-1'))
          .thenAnswer((_) async => Result.ok([statusChangeRow]));
      when(() => dataSource.fetchClient('client-1'))
          .thenAnswer((_) async => Result.ok(clientRow));
      when(() => dataSource.fetchAddress('address-1'))
          .thenAnswer((_) async => Result.ok(addressRow));
    });

    test('updates claim status and reloads claim', () async {
      when(
        () => dataSource.updateClaimStatus(
          claimId: 'claim-1',
          tenantId: 'tenant-1',
          fromStatus: ClaimStatus.inContact,
          toStatus: ClaimStatus.scheduled,
          reason: 'Appointment booked',
        ),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await repository.changeStatus(
        claimId: 'claim-1',
        newStatus: ClaimStatus.scheduled,
        reason: 'Appointment booked',
      );

      expect(result.isOk, isTrue);
      verify(() => dataSource.updateClaimStatus(
            claimId: 'claim-1',
            tenantId: 'tenant-1',
            fromStatus: ClaimStatus.inContact,
            toStatus: ClaimStatus.scheduled,
            reason: 'Appointment booked',
          )).called(1);
      verify(() => dataSource.fetchStatusHistory('claim-1')).called(1);
    });
  });

  group('claimExists', () {
    test('returns flag from remote source', () async {
      when(() => dataSource.claimExists(
            insurerId: 'insurer-1',
            claimNumber: 'ROC-1',
          )).thenAnswer((_) async => const Result.ok(true));

      final result = await repository.claimExists(
        insurerId: 'insurer-1',
        claimNumber: 'ROC-1',
      );

      expect(result.isOk, isTrue);
      expect(result.data, isTrue);
      verify(() => dataSource.claimExists(
            insurerId: 'insurer-1',
            claimNumber: 'ROC-1',
          )).called(1);
    });

    test('propagates error from remote', () async {
      final error = const PermissionDeniedError();
      when(() => dataSource.claimExists(
            insurerId: 'insurer-1',
            claimNumber: 'ROC-1',
          )).thenAnswer((_) async => Result.err(error));

      final result = await repository.claimExists(
        insurerId: 'insurer-1',
        claimNumber: 'ROC-1',
      );

      expect(result.isErr, isTrue);
      expect(result.error, same(error));
    });
  });
}

