// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(technicians)
const techniciansProvider = TechniciansProvider._();

final class TechniciansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserAccount>>,
          List<UserAccount>,
          FutureOr<List<UserAccount>>
        >
    with
        $FutureModifier<List<UserAccount>>,
        $FutureProvider<List<UserAccount>> {
  const TechniciansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'techniciansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$techniciansHash();

  @$internal
  @override
  $FutureProviderElement<List<UserAccount>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserAccount>> create(Ref ref) {
    return technicians(ref);
  }
}

String _$techniciansHash() => r'001ebe6df58a1848fe310271d631b89ad32c52de';

@ProviderFor(technicianAssignments)
const technicianAssignmentsProvider = TechnicianAssignmentsFamily._();

final class TechnicianAssignmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  const TechnicianAssignmentsProvider._({
    required TechnicianAssignmentsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'technicianAssignmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianAssignmentsHash();

  @override
  String toString() {
    return r'technicianAssignmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return technicianAssignments(ref, date: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianAssignmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianAssignmentsHash() =>
    r'2f4b7e65ee6e2f541066ddc34af683ff7d2da58f';

final class TechnicianAssignmentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, int>>, DateTime> {
  const TechnicianAssignmentsFamily._()
    : super(
        retry: null,
        name: r'technicianAssignmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TechnicianAssignmentsProvider call({required DateTime date}) =>
      TechnicianAssignmentsProvider._(argument: date, from: this);

  @override
  String toString() => r'technicianAssignmentsProvider';
}

@ProviderFor(technicianAvailability)
const technicianAvailabilityProvider = TechnicianAvailabilityFamily._();

final class TechnicianAvailabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  const TechnicianAvailabilityProvider._({
    required TechnicianAvailabilityFamily super.from,
    required ({String technicianId, DateTime date}) super.argument,
  }) : super(
         retry: null,
         name: r'technicianAvailabilityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianAvailabilityHash();

  @override
  String toString() {
    return r'technicianAvailabilityProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as ({String technicianId, DateTime date});
    return technicianAvailability(
      ref,
      technicianId: argument.technicianId,
      date: argument.date,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianAvailabilityProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianAvailabilityHash() =>
    r'866928163f774188f3fd03a9ae2dd557ca3da0b9';

final class TechnicianAvailabilityFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({String technicianId, DateTime date})
        > {
  const TechnicianAvailabilityFamily._()
    : super(
        retry: null,
        name: r'technicianAvailabilityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TechnicianAvailabilityProvider call({
    required String technicianId,
    required DateTime date,
  }) => TechnicianAvailabilityProvider._(
    argument: (technicianId: technicianId, date: date),
    from: this,
  );

  @override
  String toString() => r'technicianAvailabilityProvider';
}
