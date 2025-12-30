import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/clients/supabase_client.dart';
import '../../../domain/value_objects/claim_enums.dart';

part 'map_view_controller.g.dart';

class ClaimMapMarker {
  const ClaimMapMarker({
    required this.claimId,
    required this.claimNumber,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.technicianName,
    this.clientName,
    this.address,
  });

  final String claimId;
  final String claimNumber;
  final ClaimStatus status;
  final double latitude;
  final double longitude;
  final String? technicianName;
  final String? clientName;
  final String? address;
}

@riverpod
Future<List<ClaimMapMarker>> claimMapMarkers(
  Ref ref, {
  ClaimStatus? statusFilter,
  String? technicianId,
}) async {
  final client = ref.watch(supabaseClientProvider);
  
  try {
    var query = client
        .from('claims')
        .select('''
          id,
          claim_number,
          status,
          technician_id,
          address:addresses!claims_address_id_fkey(
            lat,
            lng,
            street,
            suburb,
            city,
            province
          ),
          technician:profiles!claims_technician_id_fkey(
            full_name
          ),
          client:clients!claims_client_id_fkey(
            first_name,
            last_name
          )
        ''')
        .neq('status', ClaimStatus.closed.value)
        .neq('status', ClaimStatus.cancelled.value);

    // Filter by status if provided
    if (statusFilter != null) {
      query = query.eq('status', statusFilter.value);
    }

    // Filter by technician if provided
    if (technicianId != null) {
      query = query.eq('technician_id', technicianId);
    }

    final response = await query;

    final markers = <ClaimMapMarker>[];
    for (final row in response as List<dynamic>) {
      final address = row['address'] as Map<String, dynamic>?;
      if (address == null) continue;

      final lat = address['lat'];
      final lng = address['lng'];
      if (lat == null || lng == null) continue;

      final latitude = double.tryParse(lat.toString());
      final longitude = double.tryParse(lng.toString());
      if (latitude == null || longitude == null) continue;

      final technician = row['technician'] as Map<String, dynamic>?;
      final clientData = row['client'] as Map<String, dynamic>?;

      final street = address['street'] as String? ?? '';
      final suburb = address['suburb'] as String? ?? '';
      final city = address['city'] as String? ?? '';
      final province = address['province'] as String? ?? '';

      final addressParts = [
        street,
        suburb,
        city,
        province,
      ].where((p) => p.isNotEmpty).join(', ');

      markers.add(ClaimMapMarker(
        claimId: row['id'] as String,
        claimNumber: row['claim_number'] as String,
        status: ClaimStatus.fromJson(row['status'] as String),
        latitude: latitude,
        longitude: longitude,
        technicianName: technician?['full_name'] as String?,
        clientName: clientData != null
            ? '${clientData['first_name'] ?? ''} ${clientData['last_name'] ?? ''}'.trim()
            : null,
        address: addressParts.isNotEmpty ? addressParts : null,
      ));
    }

    return markers;
  } catch (err) {
    return [];
  }
}

