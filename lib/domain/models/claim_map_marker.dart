import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/claim_enums.dart';

part 'claim_map_marker.freezed.dart';

/// Minimal claim data for map marker display
@freezed
abstract class ClaimMapMarker with _$ClaimMapMarker {
  const factory ClaimMapMarker({
    required String claimId,
    required String claimNumber,
    required ClaimStatus status,
    required double latitude,
    required double longitude,
    String? technicianId,
    String? technicianName,
    String? clientName,
    String? address,
  }) = _ClaimMapMarker;

  const ClaimMapMarker._();

  bool get hasTechnician => technicianId != null && technicianName != null;
}

