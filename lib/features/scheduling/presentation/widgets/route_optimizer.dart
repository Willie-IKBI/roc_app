import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../domain/models/scheduling_models.dart';
import '../../../../domain/value_objects/claim_enums.dart';
import '../../controller/scheduling_controller.dart';
import 'appointment_card.dart';

/// Widget showing technician route with travel times and optimization suggestions.
/// 
/// Displays appointments in order with travel times between them,
/// suggests optimal route order, and detects conflicts.
class RouteOptimizer extends ConsumerWidget {
  const RouteOptimizer({
    super.key,
    required this.technicianId,
    required this.date,
  });

  final String technicianId;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAsync = ref.watch(
      optimizeRouteProvider(technicianId: technicianId, date: date),
    );

    return routeAsync.when(
      data: (route) {
        if (route.optimizedOrder.isEmpty) {
          return Center(
            child: Text(
              'No appointments scheduled for this technician',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            _RouteSummary(route: route),
            const SizedBox(height: DesignTokens.spaceM),
            
            // Conflicts warning
            if (route.hasConflicts) ...[
              _ConflictsWarning(conflicts: route.conflicts!),
              const SizedBox(height: DesignTokens.spaceM),
            ],
            
            // Route list
            Expanded(
              child: ListView.builder(
                itemCount: route.optimizedOrder.length,
                itemBuilder: (context, index) {
                  final appointment = route.optimizedOrder[index];
                  final travelTime = index > 0 ? route.travelTimes[index - 1] : null;
                  
                  return _RouteItem(
                    appointment: appointment,
                    travelTime: travelTime,
                    isFirst: index == 0,
                    isLast: index == route.optimizedOrder.length - 1,
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading route: $error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.route});

  final RouteOptimization route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.work_outline,
              label: 'Work Time',
              value: '${route.totalWorkTimeMinutes} min',
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryItem(
              icon: Icons.directions_car_outlined,
              label: 'Travel Time',
              value: '${route.totalTravelTimeMinutes} min',
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryItem(
              icon: Icons.access_time,
              label: 'Total Time',
              value: '${route.totalTimeMinutes} min',
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryItem(
              icon: Icons.list_alt,
              label: 'Appointments',
              value: '${route.optimizedOrder.length}',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: DesignTokens.spaceXS),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spaceXS),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ConflictsWarning extends StatelessWidget {
  const _ConflictsWarning({required this.conflicts});

  final List<String> conflicts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
      borderColor: theme.colorScheme.error.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: DesignTokens.spaceS),
              Text(
                'Route Conflicts Detected',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceS),
          ...conflicts.map((conflict) => Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spaceXS),
            child: Text(
              '• $conflict',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _RouteItem extends StatelessWidget {
  const _RouteItem({
    required this.appointment,
    this.travelTime,
    required this.isFirst,
    required this.isLast,
  });

  final AppointmentSlot appointment;
  final int? travelTime;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Travel time indicator (if not first)
        if (!isFirst && travelTime != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: DesignTokens.spaceXS),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceM,
              vertical: DesignTokens.spaceS,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: DesignTokens.spaceXS),
                Text(
                  '$travelTime min travel',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // Appointment card
        AppointmentCard(appointment: appointment),
      ],
    );
  }
}

