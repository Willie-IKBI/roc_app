import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../claims/controller/technician_controller.dart';
import '../../../../domain/models/user_account.dart';

class TechnicianSelector extends ConsumerWidget {
  const TechnicianSelector({
    super.key,
    this.selectedTechnicianId,
    this.onTechnicianSelected,
    this.appointmentDate,
  });

  final String? selectedTechnicianId;
  final ValueChanged<String?>? onTechnicianSelected;
  final DateTime? appointmentDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniciansAsync = ref.watch(techniciansProvider);
    final theme = Theme.of(context);

    return techniciansAsync.when(
      data: (technicians) {
        if (technicians.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Technician',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'No technicians available. Add technicians in Admin > Users.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }

        String? selectedId = selectedTechnicianId;
        UserAccount? selectedTechnician;
        if (selectedId != null) {
          selectedTechnician = technicians.firstWhere(
            (t) => t.id == selectedId,
            orElse: () => technicians.first,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technician',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: DesignTokens.spaceS),
            DropdownMenu<String?>(
              initialSelection: selectedId,
              label: const Text('Select technician'),
              dropdownMenuEntries: [
                const DropdownMenuEntry(
                  value: null,
                  label: 'No technician assigned',
                ),
                ...technicians.map(
                  (technician) => DropdownMenuEntry(
                    value: technician.id,
                    label: technician.fullName,
                  ),
                ),
              ],
              onSelected: (value) {
                onTechnicianSelected?.call(value);
                if (appointmentDate != null && value != null) {
                  // Refresh availability for selected technician
                  ref.invalidate(
                    technicianAvailabilityProvider(
                      technicianId: value,
                      date: appointmentDate!,
                    ),
                  );
                }
              },
            ),
            if (selectedTechnician != null && appointmentDate != null) ...[
              const SizedBox(height: DesignTokens.spaceS),
              _TechnicianAvailabilityIndicator(
                technicianId: selectedTechnician.id,
                appointmentDate: appointmentDate!,
              ),
            ],
          ],
        );
      },
      loading: () => const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technician',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Error loading technicians: ${error.toString()}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnicianAvailabilityIndicator extends ConsumerWidget {
  const _TechnicianAvailabilityIndicator({
    required this.technicianId,
    required this.appointmentDate,
  });

  final String technicianId;
  final DateTime appointmentDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availabilityAsync = ref.watch(
      technicianAvailabilityProvider(
        technicianId: technicianId,
        date: appointmentDate,
      ),
    );
    final theme = Theme.of(context);

    return availabilityAsync.when(
      data: (data) {
        final totalAppointments = data['totalAppointments'] as int? ?? 0;
        final availableSlots = data['availableSlots'] as List<dynamic>? ?? [];
        
        return Container(
          padding: const EdgeInsets.all(DesignTokens.spaceS),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: DesignTokens.spaceS),
              Text(
                '$totalAppointments jobs scheduled, ${availableSlots.length} slots available',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

