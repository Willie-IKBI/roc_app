// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all appointments for a specific date, grouped by technician.

@ProviderFor(daySchedule)
const dayScheduleProvider = DayScheduleFamily._();

/// Fetches all appointments for a specific date, grouped by technician.

final class DayScheduleProvider
    extends
        $FunctionalProvider<
          AsyncValue<DaySchedule>,
          DaySchedule,
          FutureOr<DaySchedule>
        >
    with $FutureModifier<DaySchedule>, $FutureProvider<DaySchedule> {
  /// Fetches all appointments for a specific date, grouped by technician.
  const DayScheduleProvider._({
    required DayScheduleFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'dayScheduleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dayScheduleHash();

  @override
  String toString() {
    return r'dayScheduleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DaySchedule> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DaySchedule> create(Ref ref) {
    final argument = this.argument as DateTime;
    return daySchedule(ref, date: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DayScheduleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dayScheduleHash() => r'08cf7146d43c224dfc07747752b80b224c666eda';

/// Fetches all appointments for a specific date, grouped by technician.

final class DayScheduleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DaySchedule>, DateTime> {
  const DayScheduleFamily._()
    : super(
        retry: null,
        name: r'dayScheduleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all appointments for a specific date, grouped by technician.

  DayScheduleProvider call({required DateTime date}) =>
      DayScheduleProvider._(argument: date, from: this);

  @override
  String toString() => r'dayScheduleProvider';
}

/// Fetches a technician's schedule for a specific date.

@ProviderFor(technicianSchedule)
const technicianScheduleProvider = TechnicianScheduleFamily._();

/// Fetches a technician's schedule for a specific date.

final class TechnicianScheduleProvider
    extends
        $FunctionalProvider<
          AsyncValue<TechnicianSchedule>,
          TechnicianSchedule,
          FutureOr<TechnicianSchedule>
        >
    with
        $FutureModifier<TechnicianSchedule>,
        $FutureProvider<TechnicianSchedule> {
  /// Fetches a technician's schedule for a specific date.
  const TechnicianScheduleProvider._({
    required TechnicianScheduleFamily super.from,
    required ({String technicianId, DateTime date}) super.argument,
  }) : super(
         retry: null,
         name: r'technicianScheduleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$technicianScheduleHash();

  @override
  String toString() {
    return r'technicianScheduleProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<TechnicianSchedule> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TechnicianSchedule> create(Ref ref) {
    final argument = this.argument as ({String technicianId, DateTime date});
    return technicianSchedule(
      ref,
      technicianId: argument.technicianId,
      date: argument.date,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianScheduleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$technicianScheduleHash() =>
    r'efd60f33fa01ce94b3293004d3a65d3a781c3519';

/// Fetches a technician's schedule for a specific date.

final class TechnicianScheduleFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<TechnicianSchedule>,
          ({String technicianId, DateTime date})
        > {
  const TechnicianScheduleFamily._()
    : super(
        retry: null,
        name: r'technicianScheduleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a technician's schedule for a specific date.

  TechnicianScheduleProvider call({
    required String technicianId,
    required DateTime date,
  }) => TechnicianScheduleProvider._(
    argument: (technicianId: technicianId, date: date),
    from: this,
  );

  @override
  String toString() => r'technicianScheduleProvider';
}

/// Calculates travel time between two addresses.

@ProviderFor(calculateTravelTime)
const calculateTravelTimeProvider = CalculateTravelTimeFamily._();

/// Calculates travel time between two addresses.

final class CalculateTravelTimeProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Calculates travel time between two addresses.
  const CalculateTravelTimeProvider._({
    required CalculateTravelTimeFamily super.from,
    required ({Address from, Address to}) super.argument,
  }) : super(
         retry: null,
         name: r'calculateTravelTimeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calculateTravelTimeHash();

  @override
  String toString() {
    return r'calculateTravelTimeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as ({Address from, Address to});
    return calculateTravelTime(ref, from: argument.from, to: argument.to);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateTravelTimeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calculateTravelTimeHash() =>
    r'7ad6b2949213645748a56251ea58d1b7bf161874';

/// Calculates travel time between two addresses.

final class CalculateTravelTimeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<int?>,
          ({Address from, Address to})
        > {
  const CalculateTravelTimeFamily._()
    : super(
        retry: null,
        name: r'calculateTravelTimeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calculates travel time between two addresses.

  CalculateTravelTimeProvider call({
    required Address from,
    required Address to,
  }) =>
      CalculateTravelTimeProvider._(argument: (from: from, to: to), from: this);

  @override
  String toString() => r'calculateTravelTimeProvider';
}

/// Optimizes route for a technician on a specific date.

@ProviderFor(optimizeRoute)
const optimizeRouteProvider = OptimizeRouteFamily._();

/// Optimizes route for a technician on a specific date.

final class OptimizeRouteProvider
    extends
        $FunctionalProvider<
          AsyncValue<RouteOptimization>,
          RouteOptimization,
          FutureOr<RouteOptimization>
        >
    with
        $FutureModifier<RouteOptimization>,
        $FutureProvider<RouteOptimization> {
  /// Optimizes route for a technician on a specific date.
  const OptimizeRouteProvider._({
    required OptimizeRouteFamily super.from,
    required ({String technicianId, DateTime date}) super.argument,
  }) : super(
         retry: null,
         name: r'optimizeRouteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$optimizeRouteHash();

  @override
  String toString() {
    return r'optimizeRouteProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RouteOptimization> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RouteOptimization> create(Ref ref) {
    final argument = this.argument as ({String technicianId, DateTime date});
    return optimizeRoute(
      ref,
      technicianId: argument.technicianId,
      date: argument.date,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OptimizeRouteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$optimizeRouteHash() => r'83db4f960cc8102318bbcf1b22f9a48dcffcbc30';

/// Optimizes route for a technician on a specific date.

final class OptimizeRouteFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RouteOptimization>,
          ({String technicianId, DateTime date})
        > {
  const OptimizeRouteFamily._()
    : super(
        retry: null,
        name: r'optimizeRouteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Optimizes route for a technician on a specific date.

  OptimizeRouteProvider call({
    required String technicianId,
    required DateTime date,
  }) => OptimizeRouteProvider._(
    argument: (technicianId: technicianId, date: date),
    from: this,
  );

  @override
  String toString() => r'optimizeRouteProvider';
}

/// Gets available time slots for a technician on a specific date.

@ProviderFor(availableTimeSlots)
const availableTimeSlotsProvider = AvailableTimeSlotsFamily._();

/// Gets available time slots for a technician on a specific date.

final class AvailableTimeSlotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AvailabilityWindow>>,
          List<AvailabilityWindow>,
          FutureOr<List<AvailabilityWindow>>
        >
    with
        $FutureModifier<List<AvailabilityWindow>>,
        $FutureProvider<List<AvailabilityWindow>> {
  /// Gets available time slots for a technician on a specific date.
  const AvailableTimeSlotsProvider._({
    required AvailableTimeSlotsFamily super.from,
    required ({String technicianId, DateTime date, int requiredDurationMinutes})
    super.argument,
  }) : super(
         retry: null,
         name: r'availableTimeSlotsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$availableTimeSlotsHash();

  @override
  String toString() {
    return r'availableTimeSlotsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AvailabilityWindow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AvailabilityWindow>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String technicianId,
              DateTime date,
              int requiredDurationMinutes,
            });
    return availableTimeSlots(
      ref,
      technicianId: argument.technicianId,
      date: argument.date,
      requiredDurationMinutes: argument.requiredDurationMinutes,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableTimeSlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availableTimeSlotsHash() =>
    r'42890e8a76b174d8790ecca7110d643a970354fd';

/// Gets available time slots for a technician on a specific date.

final class AvailableTimeSlotsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AvailabilityWindow>>,
          ({String technicianId, DateTime date, int requiredDurationMinutes})
        > {
  const AvailableTimeSlotsFamily._()
    : super(
        retry: null,
        name: r'availableTimeSlotsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gets available time slots for a technician on a specific date.

  AvailableTimeSlotsProvider call({
    required String technicianId,
    required DateTime date,
    required int requiredDurationMinutes,
  }) => AvailableTimeSlotsProvider._(
    argument: (
      technicianId: technicianId,
      date: date,
      requiredDurationMinutes: requiredDurationMinutes,
    ),
    from: this,
  );

  @override
  String toString() => r'availableTimeSlotsProvider';
}

/// Gets unassigned appointments for a specific date.

@ProviderFor(unassignedAppointments)
const unassignedAppointmentsProvider = UnassignedAppointmentsFamily._();

/// Gets unassigned appointments for a specific date.

final class UnassignedAppointmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentSlot>>,
          List<AppointmentSlot>,
          FutureOr<List<AppointmentSlot>>
        >
    with
        $FutureModifier<List<AppointmentSlot>>,
        $FutureProvider<List<AppointmentSlot>> {
  /// Gets unassigned appointments for a specific date.
  const UnassignedAppointmentsProvider._({
    required UnassignedAppointmentsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'unassignedAppointmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unassignedAppointmentsHash();

  @override
  String toString() {
    return r'unassignedAppointmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppointmentSlot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentSlot>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return unassignedAppointments(ref, date: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnassignedAppointmentsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unassignedAppointmentsHash() =>
    r'9e4bc8e6ccabfe5a371c565b64a17d58a42a6e2e';

/// Gets unassigned appointments for a specific date.

final class UnassignedAppointmentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AppointmentSlot>>, DateTime> {
  const UnassignedAppointmentsFamily._()
    : super(
        retry: null,
        name: r'unassignedAppointmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gets unassigned appointments for a specific date.

  UnassignedAppointmentsProvider call({required DateTime date}) =>
      UnassignedAppointmentsProvider._(argument: date, from: this);

  @override
  String toString() => r'unassignedAppointmentsProvider';
}
