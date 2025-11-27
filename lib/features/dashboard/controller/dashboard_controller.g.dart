// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
const dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardState> {
  const DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();
}

String _$dashboardControllerHash() =>
    r'f1fc4d5b9718473a17b486bc7b59e7b4dbe91fca';

abstract class _$DashboardController extends $AsyncNotifier<DashboardState> {
  FutureOr<DashboardState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<DashboardState>, DashboardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardState>, DashboardState>,
              AsyncValue<DashboardState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
