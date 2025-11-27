// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_templates_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmsTemplatesController)
const smsTemplatesControllerProvider = SmsTemplatesControllerProvider._();

final class SmsTemplatesControllerProvider
    extends $AsyncNotifierProvider<SmsTemplatesController, List<SmsTemplate>> {
  const SmsTemplatesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smsTemplatesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smsTemplatesControllerHash();

  @$internal
  @override
  SmsTemplatesController create() => SmsTemplatesController();
}

String _$smsTemplatesControllerHash() =>
    r'4224fca9df67894a270af2e12dff8300ca6f0682';

abstract class _$SmsTemplatesController
    extends $AsyncNotifier<List<SmsTemplate>> {
  FutureOr<List<SmsTemplate>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SmsTemplate>>, List<SmsTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SmsTemplate>>, List<SmsTemplate>>,
              AsyncValue<List<SmsTemplate>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SmsSenderController)
const smsSenderControllerProvider = SmsSenderControllerProvider._();

final class SmsSenderControllerProvider
    extends $AsyncNotifierProvider<SmsSenderController, SmsSenderSettings> {
  const SmsSenderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smsSenderControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smsSenderControllerHash();

  @$internal
  @override
  SmsSenderController create() => SmsSenderController();
}

String _$smsSenderControllerHash() =>
    r'f68af4ab05ea115b3e7bd09440ff757e82d24a0f';

abstract class _$SmsSenderController extends $AsyncNotifier<SmsSenderSettings> {
  FutureOr<SmsSenderSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<SmsSenderSettings>, SmsSenderSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SmsSenderSettings>, SmsSenderSettings>,
              AsyncValue<SmsSenderSettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
