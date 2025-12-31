import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/domain_error.dart';
import '../../core/logging/logger.dart';
import '../../core/utils/result.dart';
import '../../domain/models/claim_map_marker.dart';
import '../../domain/models/map_bounds.dart';
import '../../domain/repositories/map_view_repository.dart';
import '../../domain/value_objects/claim_enums.dart';
import '../clients/supabase_client.dart';
import '../datasources/map_view_remote_data_source.dart';
import '../datasources/supabase_map_view_remote_data_source.dart';

final mapViewRepositoryProvider = Provider<MapViewRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseMapViewRemoteDataSource(client);
  return MapViewRepositorySupabase(dataSource);
});

class MapViewRepositorySupabase implements MapViewRepository {
  MapViewRepositorySupabase(this._remote);

  final MapViewRemoteDataSource _remote;

  @override
  Future<Result<List<ClaimMapMarker>>> fetchMapClaims({
    MapBounds? bounds,
    DateRange? dateRange,
    ClaimStatus? status,
    String? technicianId,
    bool? technicianAssignmentFilter,
    int limit = 500,
  }) async {
    try {
      // Convert domain models to data source format
      final boundsMap = bounds != null
          ? {
              'north': bounds.north,
              'south': bounds.south,
              'east': bounds.east,
              'west': bounds.west,
            }
          : null;

      final dateRangeMap = dateRange != null
          ? {
              'startDate': dateRange.startDate,
              'endDate': dateRange.endDate,
            }
          : null;

      final rows = await _remote.fetchMapClaims(
        bounds: boundsMap,
        dateRange: dateRangeMap,
        status: status?.value,
        technicianId: technicianId,
        technicianAssignmentFilter: technicianAssignmentFilter,
        limit: limit,
      );

      // Transform rows to ClaimMapMarker
      final markers = <ClaimMapMarker>[];

      for (final row in rows) {
        try {
          final marker = _mapRowToMarker(row);
          if (marker != null) {
            markers.add(marker);
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error processing map marker row for claim ${row['id']}: $e',
            name: 'MapViewRepositorySupabase',
            error: e,
            stackTrace: stackTrace,
          );
          // Continue processing other markers
        }
      }

      return Result.ok(markers);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch map claims: $e',
        name: 'MapViewRepositorySupabase',
        error: e,
        stackTrace: stackTrace,
      );

      // Convert to DomainError
      DomainError error;
      if (e is PostgrestException) {
        if (e.code == 'PGRST116' ||
            (e.message.contains('permission')) ||
            (e.message.contains('denied'))) {
          error = const PermissionDeniedError('Failed to fetch map claims: permission denied');
        } else if (e.code == 'PGRST301' || (e.message.contains('not found'))) {
          error = const NotFoundError('Map claims data');
        } else {
          error = NetworkError(e);
        }
      } else {
        error = UnknownError(e);
      }

      return Result.err(error);
    }
  }

  /// Maps a Supabase row to ClaimMapMarker
  ClaimMapMarker? _mapRowToMarker(Map<String, dynamic> row) {
    // Extract claim data
    final claimId = row['id'] as String?;
    final claimNumber = row['claim_number'] as String?;
    final statusStr = row['status'] as String?;
    final technicianId = row['technician_id'] as String?;

    if (claimId == null || claimNumber == null || statusStr == null) {
      return null;
    }

    // Extract address data
    final addressData = row['address'] as Map<String, dynamic>?;
    if (addressData == null) {
      return null;
    }

    final lat = addressData['lat'];
    final lng = addressData['lng'];
    if (lat == null || lng == null) {
      return null;
    }

    final latitude = (lat is num) ? lat.toDouble() : double.tryParse(lat.toString());
    final longitude = (lng is num) ? lng.toDouble() : double.tryParse(lng.toString());
    if (latitude == null || longitude == null) {
      return null;
    }

    // Build address string
    final street = addressData['street'] as String? ?? '';
    final suburb = addressData['suburb'] as String? ?? '';
    final city = addressData['city'] as String? ?? '';
    final province = addressData['province'] as String? ?? '';

    final addressParts = [street, suburb, city, province]
        .where((p) => p.isNotEmpty)
        .join(', ');
    final address = addressParts.isNotEmpty ? addressParts : null;

    // Extract technician data
    final technicianData = row['technician'] as Map<String, dynamic>?;
    final technicianName = technicianData?['full_name'] as String?;

    // Extract client data
    final clientData = row['client'] as Map<String, dynamic>?;
    final clientName = clientData != null
        ? '${clientData['first_name'] ?? ''} ${clientData['last_name'] ?? ''}'.trim()
        : null;
    if (clientName != null && clientName.isEmpty) {
      AppLogger.warn(
        'Client name is empty for claim $claimId',
        name: 'MapViewRepositorySupabase',
      );
    }

    // Parse status
    final status = ClaimStatus.fromJson(statusStr);

    return ClaimMapMarker(
      claimId: claimId,
      claimNumber: claimNumber,
      status: status,
      latitude: latitude,
      longitude: longitude,
      technicianId: technicianId,
      technicianName: technicianName,
      clientName: clientName,
      address: address,
    );
  }
}

