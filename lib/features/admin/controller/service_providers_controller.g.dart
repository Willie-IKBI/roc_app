// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServiceProvidersController)
const serviceProvidersControllerProvider =
    ServiceProvidersControllerProvider._();

final class ServiceProvidersControllerProvider
    extends
        $AsyncNotifierProvider<
          ServiceProvidersController,
          List<ServiceProvider>
        > {
  const ServiceProvidersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceProvidersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceProvidersControllerHash();

  @$internal
  @override
  ServiceProvidersController create() => ServiceProvidersController();
}

String _$serviceProvidersControllerHash() =>
    r'932b4bfd8ee5245a52c5ebf030d3c56870af127e';

abstract class _$ServiceProvidersController
    extends $AsyncNotifier<List<ServiceProvider>> {
  FutureOr<List<ServiceProvider>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ServiceProvider>>, List<ServiceProvider>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ServiceProvider>>,
                List<ServiceProvider>
              >,
              AsyncValue<List<ServiceProvider>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
