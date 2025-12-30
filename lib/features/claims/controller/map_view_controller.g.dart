// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_view_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(claimMapMarkers)
const claimMapMarkersProvider = ClaimMapMarkersFamily._();

final class ClaimMapMarkersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClaimMapMarker>>,
          List<ClaimMapMarker>,
          FutureOr<List<ClaimMapMarker>>
        >
    with
        $FutureModifier<List<ClaimMapMarker>>,
        $FutureProvider<List<ClaimMapMarker>> {
  const ClaimMapMarkersProvider._({
    required ClaimMapMarkersFamily super.from,
    required ({ClaimStatus? statusFilter, String? technicianId}) super.argument,
  }) : super(
         retry: null,
         name: r'claimMapMarkersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimMapMarkersHash();

  @override
  String toString() {
    return r'claimMapMarkersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClaimMapMarker>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClaimMapMarker>> create(Ref ref) {
    final argument =
        this.argument as ({ClaimStatus? statusFilter, String? technicianId});
    return claimMapMarkers(
      ref,
      statusFilter: argument.statusFilter,
      technicianId: argument.technicianId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimMapMarkersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimMapMarkersHash() => r'ee96d609cf3a90659fd2f752a91e4760efd838a6';

final class ClaimMapMarkersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClaimMapMarker>>,
          ({ClaimStatus? statusFilter, String? technicianId})
        > {
  const ClaimMapMarkersFamily._()
    : super(
        retry: null,
        name: r'claimMapMarkersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClaimMapMarkersProvider call({
    ClaimStatus? statusFilter,
    String? technicianId,
  }) => ClaimMapMarkersProvider._(
    argument: (statusFilter: statusFilter, technicianId: technicianId),
    from: this,
  );

  @override
  String toString() => r'claimMapMarkersProvider';
}
