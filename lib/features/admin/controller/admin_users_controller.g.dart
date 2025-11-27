// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_users_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminUsersController)
const adminUsersControllerProvider = AdminUsersControllerProvider._();

final class AdminUsersControllerProvider
    extends $AsyncNotifierProvider<AdminUsersController, List<UserAccount>> {
  const AdminUsersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminUsersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminUsersControllerHash();

  @$internal
  @override
  AdminUsersController create() => AdminUsersController();
}

String _$adminUsersControllerHash() =>
    r'184b81e40d50c23302c87d0fd4f2f6cb644d8dfd';

abstract class _$AdminUsersController
    extends $AsyncNotifier<List<UserAccount>> {
  FutureOr<List<UserAccount>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<UserAccount>>, List<UserAccount>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserAccount>>, List<UserAccount>>,
              AsyncValue<List<UserAccount>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
