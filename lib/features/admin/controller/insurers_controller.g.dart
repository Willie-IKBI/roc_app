// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminInsurersController)
const adminInsurersControllerProvider = AdminInsurersControllerProvider._();

final class AdminInsurersControllerProvider
    extends $AsyncNotifierProvider<AdminInsurersController, List<Insurer>> {
  const AdminInsurersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminInsurersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminInsurersControllerHash();

  @$internal
  @override
  AdminInsurersController create() => AdminInsurersController();
}

String _$adminInsurersControllerHash() =>
    r'5a7892171df7c36c5e6d2f25f1444386453819e0';

abstract class _$AdminInsurersController extends $AsyncNotifier<List<Insurer>> {
  FutureOr<List<Insurer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Insurer>>, List<Insurer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Insurer>>, List<Insurer>>,
              AsyncValue<List<Insurer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
