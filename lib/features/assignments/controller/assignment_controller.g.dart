// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches assignable jobs with filtering support.

@ProviderFor(assignableJobs)
const assignableJobsProvider = AssignableJobsFamily._();

/// Fetches assignable jobs with filtering support.

final class AssignableJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClaimSummary>>,
          List<ClaimSummary>,
          FutureOr<List<ClaimSummary>>
        >
    with
        $FutureModifier<List<ClaimSummary>>,
        $FutureProvider<List<ClaimSummary>> {
  /// Fetches assignable jobs with filtering support.
  const AssignableJobsProvider._({
    required AssignableJobsFamily super.from,
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
         name: r'assignableJobsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assignableJobsHash();

  @override
  String toString() {
    return r'assignableJobsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClaimSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClaimSummary>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              ClaimStatus? statusFilter,
              bool? assignedFilter,
              String? technicianIdFilter,
              DateTime? dateFrom,
              DateTime? dateTo,
            });
    return assignableJobs(
      ref,
      statusFilter: argument.statusFilter,
      assignedFilter: argument.assignedFilter,
      technicianIdFilter: argument.technicianIdFilter,
      dateFrom: argument.dateFrom,
      dateTo: argument.dateTo,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssignableJobsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assignableJobsHash() => r'252558991f390b517e4c49e92397cca0e8ac3556';

/// Fetches assignable jobs with filtering support.

final class AssignableJobsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClaimSummary>>,
          ({
            ClaimStatus? statusFilter,
            bool? assignedFilter,
            String? technicianIdFilter,
            DateTime? dateFrom,
            DateTime? dateTo,
          })
        > {
  const AssignableJobsFamily._()
    : super(
        retry: null,
        name: r'assignableJobsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches assignable jobs with filtering support.

  AssignableJobsProvider call({
    ClaimStatus? statusFilter,
    bool? assignedFilter,
    String? technicianIdFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) => AssignableJobsProvider._(
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
  String toString() => r'assignableJobsProvider';
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
    r'8083676c68baac90f63d19741e7b63cf9d447a92';

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
