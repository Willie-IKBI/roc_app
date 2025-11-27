// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sla_rules_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SlaRulesController)
const slaRulesControllerProvider = SlaRulesControllerProvider._();

final class SlaRulesControllerProvider
    extends $AsyncNotifierProvider<SlaRulesController, SlaRule> {
  const SlaRulesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'slaRulesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$slaRulesControllerHash();

  @$internal
  @override
  SlaRulesController create() => SlaRulesController();
}

String _$slaRulesControllerHash() =>
    r'6b9f4bfbd88e2676192b09f94f5f9223761dea71';

abstract class _$SlaRulesController extends $AsyncNotifier<SlaRule> {
  FutureOr<SlaRule> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SlaRule>, SlaRule>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SlaRule>, SlaRule>,
              AsyncValue<SlaRule>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
