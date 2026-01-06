// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authChanges)
const authChangesProvider = AuthChangesProvider._();

final class AuthChangesProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  const AuthChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authChangesHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authChanges(ref);
  }
}

String _$authChangesHash() => r'f566fd08dd77579fa35f66174c38da4131fe674a';

/// Tracks whether the last logout was due to token expiration

@ProviderFor(SessionExpirationReason)
const sessionExpirationReasonProvider = SessionExpirationReasonProvider._();

/// Tracks whether the last logout was due to token expiration
final class SessionExpirationReasonProvider
    extends $NotifierProvider<SessionExpirationReason, bool> {
  /// Tracks whether the last logout was due to token expiration
  const SessionExpirationReasonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpirationReasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpirationReasonHash();

  @$internal
  @override
  SessionExpirationReason create() => SessionExpirationReason();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sessionExpirationReasonHash() =>
    r'6a56889c388f0a164461906d512fd126333237b8';

/// Tracks whether the last logout was due to token expiration

abstract class _$SessionExpirationReason extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<Profile?>, Profile?, FutureOr<Profile?>>
    with $FutureModifier<Profile?>, $FutureProvider<Profile?> {
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<Profile?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Profile?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'e3f273e845da500423f41ea4941884e48bda80fb';
