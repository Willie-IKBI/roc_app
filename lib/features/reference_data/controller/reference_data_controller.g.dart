// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for insurer options (id + name)
/// Returns AsyncValue&lt;List&lt;ReferenceOption&gt;&gt; for UI consumption.
/// Errors are surfaced as AsyncError (no silent failures).

@ProviderFor(insurerOptions)
const insurerOptionsProvider = InsurerOptionsProvider._();

/// Provider for insurer options (id + name)
/// Returns AsyncValue&lt;List&lt;ReferenceOption&gt;&gt; for UI consumption.
/// Errors are surfaced as AsyncError (no silent failures).

final class InsurerOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReferenceOption>>,
          List<ReferenceOption>,
          FutureOr<List<ReferenceOption>>
        >
    with
        $FutureModifier<List<ReferenceOption>>,
        $FutureProvider<List<ReferenceOption>> {
  /// Provider for insurer options (id + name)
  /// Returns AsyncValue&lt;List&lt;ReferenceOption&gt;&gt; for UI consumption.
  /// Errors are surfaced as AsyncError (no silent failures).
  const InsurerOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insurerOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insurerOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReferenceOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReferenceOption>> create(Ref ref) {
    return insurerOptions(ref);
  }
}

String _$insurerOptionsHash() => r'e195687e45a86acb72eec66d311601c070786db8';

/// Provider for service provider options (id + company_name)

@ProviderFor(serviceProviderOptions)
const serviceProviderOptionsProvider = ServiceProviderOptionsProvider._();

/// Provider for service provider options (id + company_name)

final class ServiceProviderOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReferenceOption>>,
          List<ReferenceOption>,
          FutureOr<List<ReferenceOption>>
        >
    with
        $FutureModifier<List<ReferenceOption>>,
        $FutureProvider<List<ReferenceOption>> {
  /// Provider for service provider options (id + company_name)
  const ServiceProviderOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serviceProviderOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serviceProviderOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReferenceOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReferenceOption>> create(Ref ref) {
    return serviceProviderOptions(ref);
  }
}

String _$serviceProviderOptionsHash() =>
    r'1d0c10e6005787477590225a43a813743ed7eb1b';

/// Provider for brand options (id + name)

@ProviderFor(brandOptions)
const brandOptionsProvider = BrandOptionsProvider._();

/// Provider for brand options (id + name)

final class BrandOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReferenceOption>>,
          List<ReferenceOption>,
          FutureOr<List<ReferenceOption>>
        >
    with
        $FutureModifier<List<ReferenceOption>>,
        $FutureProvider<List<ReferenceOption>> {
  /// Provider for brand options (id + name)
  const BrandOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReferenceOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReferenceOption>> create(Ref ref) {
    return brandOptions(ref);
  }
}

String _$brandOptionsHash() => r'45ddcc820c78f45cc0c316acb16ea0d803277c28';

/// Provider for estate options (id + formatted label)

@ProviderFor(estateOptions)
const estateOptionsProvider = EstateOptionsProvider._();

/// Provider for estate options (id + formatted label)

final class EstateOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReferenceOption>>,
          List<ReferenceOption>,
          FutureOr<List<ReferenceOption>>
        >
    with
        $FutureModifier<List<ReferenceOption>>,
        $FutureProvider<List<ReferenceOption>> {
  /// Provider for estate options (id + formatted label)
  const EstateOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'estateOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$estateOptionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReferenceOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReferenceOption>> create(Ref ref) {
    return estateOptions(ref);
  }
}

String _$estateOptionsHash() => r'59f5c24bbb51931346975e357aa9b333511b4291';
