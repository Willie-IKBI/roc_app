// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QueueSettingsController)
const queueSettingsControllerProvider = QueueSettingsControllerProvider._();

final class QueueSettingsControllerProvider
    extends $AsyncNotifierProvider<QueueSettingsController, QueueSettings> {
  const QueueSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueSettingsControllerHash();

  @$internal
  @override
  QueueSettingsController create() => QueueSettingsController();
}

String _$queueSettingsControllerHash() =>
    r'b849cc2c7ce23b277066d5d342dff2862c70c2ce';

abstract class _$QueueSettingsController extends $AsyncNotifier<QueueSettings> {
  FutureOr<QueueSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<QueueSettings>, QueueSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QueueSettings>, QueueSettings>,
              AsyncValue<QueueSettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
