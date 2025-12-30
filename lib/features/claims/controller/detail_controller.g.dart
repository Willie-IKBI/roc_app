// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClaimDetailController)
const claimDetailControllerProvider = ClaimDetailControllerFamily._();

final class ClaimDetailControllerProvider
    extends $AsyncNotifierProvider<ClaimDetailController, Claim> {
  const ClaimDetailControllerProvider._({
    required ClaimDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'claimDetailControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimDetailControllerHash();

  @override
  String toString() {
    return r'claimDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClaimDetailController create() => ClaimDetailController();

  @override
  bool operator ==(Object other) {
    return other is ClaimDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimDetailControllerHash() =>
    r'7fab69d3daf420007f3ab6e6cd6d84baadf56c58';

final class ClaimDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimDetailController,
          AsyncValue<Claim>,
          Claim,
          FutureOr<Claim>,
          String
        > {
  const ClaimDetailControllerFamily._()
    : super(
        retry: null,
        name: r'claimDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ClaimDetailControllerProvider call(String claimId) =>
      ClaimDetailControllerProvider._(argument: claimId, from: this);

  @override
  String toString() => r'claimDetailControllerProvider';
}

abstract class _$ClaimDetailController extends $AsyncNotifier<Claim> {
  late final _$args = ref.$arg as String;
  String get claimId => _$args;

  FutureOr<Claim> build(String claimId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Claim>, Claim>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Claim>, Claim>,
              AsyncValue<Claim>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
