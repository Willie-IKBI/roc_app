// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClaimsQueueController)
const claimsQueueControllerProvider = ClaimsQueueControllerFamily._();

final class ClaimsQueueControllerProvider
    extends $AsyncNotifierProvider<ClaimsQueueController, ClaimsQueueState> {
  const ClaimsQueueControllerProvider._({
    required ClaimsQueueControllerFamily super.from,
    required ClaimStatus? super.argument,
  }) : super(
         retry: null,
         name: r'claimsQueueControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$claimsQueueControllerHash();

  @override
  String toString() {
    return r'claimsQueueControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClaimsQueueController create() => ClaimsQueueController();

  @override
  bool operator ==(Object other) {
    return other is ClaimsQueueControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimsQueueControllerHash() =>
    r'598e4d4c48069f71ed15781e53582c4922cb3223';

final class ClaimsQueueControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimsQueueController,
          AsyncValue<ClaimsQueueState>,
          ClaimsQueueState,
          FutureOr<ClaimsQueueState>,
          ClaimStatus?
        > {
  const ClaimsQueueControllerFamily._()
    : super(
        retry: null,
        name: r'claimsQueueControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClaimsQueueControllerProvider call({ClaimStatus? status}) =>
      ClaimsQueueControllerProvider._(argument: status, from: this);

  @override
  String toString() => r'claimsQueueControllerProvider';
}

abstract class _$ClaimsQueueController
    extends $AsyncNotifier<ClaimsQueueState> {
  late final _$args = ref.$arg as ClaimStatus?;
  ClaimStatus? get status => _$args;

  FutureOr<ClaimsQueueState> build({ClaimStatus? status});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(status: _$args);
    final ref =
        this.ref as $Ref<AsyncValue<ClaimsQueueState>, ClaimsQueueState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ClaimsQueueState>, ClaimsQueueState>,
              AsyncValue<ClaimsQueueState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
