// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporting_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportingWindowController)
const reportingWindowControllerProvider = ReportingWindowControllerProvider._();

final class ReportingWindowControllerProvider
    extends $NotifierProvider<ReportingWindowController, ReportingWindow> {
  const ReportingWindowControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportingWindowControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportingWindowControllerHash();

  @$internal
  @override
  ReportingWindowController create() => ReportingWindowController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportingWindow value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportingWindow>(value),
    );
  }
}

String _$reportingWindowControllerHash() =>
    r'e847aa67e6cf6b9a0422e1747ad33920176353d9';

abstract class _$ReportingWindowController extends $Notifier<ReportingWindow> {
  ReportingWindow build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReportingWindow, ReportingWindow>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportingWindow, ReportingWindow>,
              ReportingWindow,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ReportingController)
const reportingControllerProvider = ReportingControllerProvider._();

final class ReportingControllerProvider
    extends $AsyncNotifierProvider<ReportingController, ReportingState> {
  const ReportingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportingControllerHash();

  @$internal
  @override
  ReportingController create() => ReportingController();
}

String _$reportingControllerHash() =>
    r'388d0edde456c8e9ae35c459d05ef115fd04561c';

abstract class _$ReportingController extends $AsyncNotifier<ReportingState> {
  FutureOr<ReportingState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ReportingState>, ReportingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReportingState>, ReportingState>,
              AsyncValue<ReportingState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
