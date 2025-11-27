// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BrandsController)
const brandsControllerProvider = BrandsControllerProvider._();

final class BrandsControllerProvider
    extends $AsyncNotifierProvider<BrandsController, List<Brand>> {
  const BrandsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandsControllerHash();

  @$internal
  @override
  BrandsController create() => BrandsController();
}

String _$brandsControllerHash() => r'4addc14263e426adfde5a6a3db0c35138f437295';

abstract class _$BrandsController extends $AsyncNotifier<List<Brand>> {
  FutureOr<List<Brand>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Brand>>, List<Brand>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Brand>>, List<Brand>>,
              AsyncValue<List<Brand>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
