// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_report_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AgentPerformanceReportController)
const agentPerformanceReportControllerProvider =
    AgentPerformanceReportControllerProvider._();

final class AgentPerformanceReportControllerProvider
    extends
        $AsyncNotifierProvider<
          AgentPerformanceReportController,
          PaginatedReportState<AgentPerformanceReport>
        > {
  const AgentPerformanceReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agentPerformanceReportControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agentPerformanceReportControllerHash();

  @$internal
  @override
  AgentPerformanceReportController create() =>
      AgentPerformanceReportController();
}

String _$agentPerformanceReportControllerHash() =>
    r'13e79811b14d2e751e58658926fef26cdbd8d515';

abstract class _$AgentPerformanceReportController
    extends $AsyncNotifier<PaginatedReportState<AgentPerformanceReport>> {
  FutureOr<PaginatedReportState<AgentPerformanceReport>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedReportState<AgentPerformanceReport>>,
              PaginatedReportState<AgentPerformanceReport>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedReportState<AgentPerformanceReport>>,
                PaginatedReportState<AgentPerformanceReport>
              >,
              AsyncValue<PaginatedReportState<AgentPerformanceReport>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(StatusDistributionReportController)
const statusDistributionReportControllerProvider =
    StatusDistributionReportControllerProvider._();

final class StatusDistributionReportControllerProvider
    extends
        $AsyncNotifierProvider<
          StatusDistributionReportController,
          PaginatedReportState<StatusDistributionReport>
        > {
  const StatusDistributionReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusDistributionReportControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$statusDistributionReportControllerHash();

  @$internal
  @override
  StatusDistributionReportController create() =>
      StatusDistributionReportController();
}

String _$statusDistributionReportControllerHash() =>
    r'9e4ab4270a35ecefbfbc932f62c04f43f625634e';

abstract class _$StatusDistributionReportController
    extends $AsyncNotifier<PaginatedReportState<StatusDistributionReport>> {
  FutureOr<PaginatedReportState<StatusDistributionReport>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedReportState<StatusDistributionReport>>,
              PaginatedReportState<StatusDistributionReport>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedReportState<StatusDistributionReport>>,
                PaginatedReportState<StatusDistributionReport>
              >,
              AsyncValue<PaginatedReportState<StatusDistributionReport>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DamageCauseReportController)
const damageCauseReportControllerProvider =
    DamageCauseReportControllerProvider._();

final class DamageCauseReportControllerProvider
    extends
        $AsyncNotifierProvider<
          DamageCauseReportController,
          PaginatedReportState<DamageCauseReport>
        > {
  const DamageCauseReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'damageCauseReportControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$damageCauseReportControllerHash();

  @$internal
  @override
  DamageCauseReportController create() => DamageCauseReportController();
}

String _$damageCauseReportControllerHash() =>
    r'4213731c7385c2362b609c752991af084295f806';

abstract class _$DamageCauseReportController
    extends $AsyncNotifier<PaginatedReportState<DamageCauseReport>> {
  FutureOr<PaginatedReportState<DamageCauseReport>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedReportState<DamageCauseReport>>,
              PaginatedReportState<DamageCauseReport>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedReportState<DamageCauseReport>>,
                PaginatedReportState<DamageCauseReport>
              >,
              AsyncValue<PaginatedReportState<DamageCauseReport>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(GeographicReportController)
const geographicReportControllerProvider = GeographicReportControllerFamily._();

final class GeographicReportControllerProvider
    extends
        $AsyncNotifierProvider<
          GeographicReportController,
          PaginatedReportState<GeographicReport>
        > {
  const GeographicReportControllerProvider._({
    required GeographicReportControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'geographicReportControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$geographicReportControllerHash();

  @override
  String toString() {
    return r'geographicReportControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GeographicReportController create() => GeographicReportController();

  @override
  bool operator ==(Object other) {
    return other is GeographicReportControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$geographicReportControllerHash() =>
    r'16ecfa0fa0010020cabcb7e6e1ffbc2b1c2abbeb';

final class GeographicReportControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          GeographicReportController,
          AsyncValue<PaginatedReportState<GeographicReport>>,
          PaginatedReportState<GeographicReport>,
          FutureOr<PaginatedReportState<GeographicReport>>,
          String?
        > {
  const GeographicReportControllerFamily._()
    : super(
        retry: null,
        name: r'geographicReportControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GeographicReportControllerProvider call(String? groupBy) =>
      GeographicReportControllerProvider._(argument: groupBy, from: this);

  @override
  String toString() => r'geographicReportControllerProvider';
}

abstract class _$GeographicReportController
    extends $AsyncNotifier<PaginatedReportState<GeographicReport>> {
  late final _$args = ref.$arg as String?;
  String? get groupBy => _$args;

  FutureOr<PaginatedReportState<GeographicReport>> build(String? groupBy);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedReportState<GeographicReport>>,
              PaginatedReportState<GeographicReport>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedReportState<GeographicReport>>,
                PaginatedReportState<GeographicReport>
              >,
              AsyncValue<PaginatedReportState<GeographicReport>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InsurerPerformanceReportController)
const insurerPerformanceReportControllerProvider =
    InsurerPerformanceReportControllerProvider._();

final class InsurerPerformanceReportControllerProvider
    extends
        $AsyncNotifierProvider<
          InsurerPerformanceReportController,
          PaginatedReportState<InsurerPerformanceReport>
        > {
  const InsurerPerformanceReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insurerPerformanceReportControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$insurerPerformanceReportControllerHash();

  @$internal
  @override
  InsurerPerformanceReportController create() =>
      InsurerPerformanceReportController();
}

String _$insurerPerformanceReportControllerHash() =>
    r'0f36992bde27e9bfe5407302c4c8844dc97b7bb2';

abstract class _$InsurerPerformanceReportController
    extends $AsyncNotifier<PaginatedReportState<InsurerPerformanceReport>> {
  FutureOr<PaginatedReportState<InsurerPerformanceReport>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedReportState<InsurerPerformanceReport>>,
              PaginatedReportState<InsurerPerformanceReport>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedReportState<InsurerPerformanceReport>>,
                PaginatedReportState<InsurerPerformanceReport>
              >,
              AsyncValue<PaginatedReportState<InsurerPerformanceReport>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
