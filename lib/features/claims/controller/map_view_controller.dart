import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/map_view_repository_supabase.dart';
import '../../../domain/models/claim_map_marker.dart';
import '../../../domain/value_objects/claim_enums.dart';

part 'map_view_controller.g.dart';

@riverpod
Future<List<ClaimMapMarker>> claimMapMarkers(
  Ref ref, {
  ClaimStatus? statusFilter,
  String? technicianId,
  bool? technicianAssignmentFilter,
}) async {
  final repository = ref.watch(mapViewRepositoryProvider);
  final result = await repository.fetchMapClaims(
    bounds: null, // Initial load: all claims (bounds filtering can be added later)
    dateRange: null, // No date range filter by default
    status: statusFilter,
    technicianId: technicianId,
    technicianAssignmentFilter: technicianAssignmentFilter,
    limit: 500, // Default limit
  );

  if (result.isErr) {
    // Surface error to UI - AsyncValue will be AsyncError
    throw result.error;
  }

  return result.data;
}

