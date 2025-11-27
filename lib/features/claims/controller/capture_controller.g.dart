// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClaimCaptureController)
const claimCaptureControllerProvider = ClaimCaptureControllerProvider._();

final class ClaimCaptureControllerProvider
    extends $AsyncNotifierProvider<ClaimCaptureController, String?> {
  const ClaimCaptureControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'claimCaptureControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$claimCaptureControllerHash();

  @$internal
  @override
  ClaimCaptureController create() => ClaimCaptureController();
}

String _$claimCaptureControllerHash() =>
    r'90cea8e37465c01f493c2b2d0eb3a211b77dd344';

abstract class _$ClaimCaptureController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
