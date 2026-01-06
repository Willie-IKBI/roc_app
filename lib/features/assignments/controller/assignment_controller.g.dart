// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssignableJobsController)
const assignableJobsControllerProvider = AssignableJobsControllerFamily._();

final class AssignableJobsControllerProvider
    extends
        $AsyncNotifierProvider<AssignableJobsController, AssignableJobsState> {
  const AssignableJobsControllerProvider._({
    required AssignableJobsControllerFamily super.from,
    required ({
      ClaimStatus? statusFilter,
      bool? assignedFilter,
      String? technicianIdFilter,
      DateTime? dateFrom,
      DateTime? dateTo,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'assignableJobsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assignableJobsControllerHash();

  @override
  String toString() {
    return r'assignableJobsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AssignableJobsController create() => AssignableJobsController();

  @override
  bool operator ==(Object other) {
    return other is AssignableJobsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assignableJobsControllerHash() =>
    r'abe7f62a1957b362e5881e1a312afd7e598f0572';

final class AssignableJobsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AssignableJobsController,
          AsyncValue<AssignableJobsState>,
          AssignableJobsState,
          FutureOr<AssignableJobsState>,
          ({
            ClaimStatus? statusFilter,
            bool? assignedFilter,
            String? technicianIdFilter,
            DateTime? dateFrom,
            DateTime? dateTo,
          })
        > {
  const AssignableJobsControllerFamily._()
    : super(
        retry: null,
        name: r'assignableJobsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssignableJobsControllerProvider call({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) => AssignableJobsControllerProvider._(
    argument: (
      statusFilter: statusFilter,
      assignedFilter: assignedFilter,
      technicianIdFilter: technicianIdFilter,
      dateFrom: dateFrom,
      dateTo: dateTo,
    ),
    from: this,
  );

  @override
  String toString() => r'assignableJobsControllerProvider';
}

abstract class _$AssignableJobsController
    extends $AsyncNotifier<AssignableJobsState> {
  late final _$args =
      ref.$arg
          as ({
            ClaimStatus? statusFilter,
            bool? assignedFilter,
            String? technicianIdFilter,
            DateTime? dateFrom,
            DateTime? dateTo,
          });
  ClaimStatus? get statusFilter => _$args.statusFilter;
  bool? get assignedFilter => _$args.assignedFilter;
  String? get technicianIdFilter => _$args.technicianIdFilter;
  DateTime? get dateFrom => _$args.dateFrom;
  DateTime? get dateTo => _$args.dateTo;

  FutureOr<AssignableJobsState> build({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      statusFilter: _$args.statusFilter,
      assignedFilter: _$args.assignedFilter,
      technicianIdFilter: _$args.technicianIdFilter,
      dateFrom: _$args.dateFrom,
      dateTo: _$args.dateTo,
    );
    final ref =
        this.ref as $Ref<AsyncValue<AssignableJobsState>, AssignableJobsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AssignableJobsState>, AssignableJobsState>,
              AsyncValue<AssignableJobsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Controller for assignment operations.

@ProviderFor(AssignmentController)
const assignmentControllerProvider = AssignmentControllerProvider._();

/// Controller for assignment operations.
final class AssignmentControllerProvider
    extends $AsyncNotifierProvider<AssignmentController, void> {
  /// Controller for assignment operations.
  const AssignmentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignmentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignmentControllerHash();

  @$internal
  @override
  AssignmentController create() => AssignmentController();
}

String _$assignmentControllerHash() =>
    r'49c616f9effcb76c4d6cb459d14953f453a183cf';

/// Controller for assignment operations.

abstract class _$AssignmentController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
