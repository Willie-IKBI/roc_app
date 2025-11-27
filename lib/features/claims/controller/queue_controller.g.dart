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
    extends $AsyncNotifierProvider<ClaimsQueueController, List<ClaimSummary>> {
  const ClaimsQueueControllerProvider._({
    required ClaimsQueueControllerFamily super.from,
    required ClaimStatus? super.argument,
  }) : super(
         retry: null,
         name: r'claimsQueueControllerProvider',
         isAutoDispose: false,
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
    r'e20132992e46e5a97cac84d2e14842cee9a065f6';

final class ClaimsQueueControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClaimsQueueController,
          AsyncValue<List<ClaimSummary>>,
          List<ClaimSummary>,
          FutureOr<List<ClaimSummary>>,
          ClaimStatus?
        > {
  const ClaimsQueueControllerFamily._()
    : super(
        retry: null,
        name: r'claimsQueueControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ClaimsQueueControllerProvider call({ClaimStatus? status}) =>
      ClaimsQueueControllerProvider._(argument: status, from: this);

  @override
  String toString() => r'claimsQueueControllerProvider';
}

abstract class _$ClaimsQueueController
    extends $AsyncNotifier<List<ClaimSummary>> {
  late final _$args = ref.$arg as ClaimStatus?;
  ClaimStatus? get status => _$args;

  FutureOr<List<ClaimSummary>> build({ClaimStatus? status});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(status: _$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<ClaimSummary>>, List<ClaimSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ClaimSummary>>, List<ClaimSummary>>,
              AsyncValue<List<ClaimSummary>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
