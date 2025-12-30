import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../domain/models/scheduling_models.dart';
import '../../../../domain/value_objects/claim_enums.dart';
import 'appointment_card.dart';

/// Timeline view showing technicians' schedules for a day.
/// 
/// Displays a horizontal timeline (8am-6pm) with each technician as a row.
/// Appointments are shown as blocks on the timeline with travel time visualization.
class TimelineView extends ConsumerWidget {
  const TimelineView({
    super.key,
    required this.daySchedule,
    this.onAppointmentTap,
  });

  final DaySchedule daySchedule;
  final void Function(AppointmentSlot)? onAppointmentTap;

  static const int startHour = 8;
  static const int endHour = 18; // 6pm
  static const int totalHours = endHour - startHour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    if (daySchedule.technicianSchedules.isEmpty) {
      return Center(
        child: Text(
          'No appointments scheduled for this day',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Timeline header with hours
        _TimelineHeader(),
        const SizedBox(height: DesignTokens.spaceM),
        
        // Technician rows
        Expanded(
          child: ListView.builder(
            itemCount: daySchedule.technicianSchedules.length,
            itemBuilder: (context, index) {
              final schedule = daySchedule.technicianSchedules[index];
              return _TechnicianTimelineRow(
                schedule: schedule,
                onAppointmentTap: onAppointmentTap,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      child: Row(
        children: [
          // Technician name column (fixed width)
          SizedBox(
            width: 150,
            child: Text(
              'Technician',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          
          // Timeline hours
          Expanded(
            child: Row(
              children: List.generate(
                TimelineView.totalHours,
                (index) {
                  final hour = TimelineView.startHour + index;
                  return Expanded(
                    child: Center(
                      child: Text(
                        _formatHour(hour),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour$period';
  }
}

class _TechnicianTimelineRow extends StatelessWidget {
  const _TechnicianTimelineRow({
    required this.schedule,
    this.onAppointmentTap,
  });

  final TechnicianSchedule schedule;
  final void Function(AppointmentSlot)? onAppointmentTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedAppointments = schedule.sortedAppointments;

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      child: GlassCard(
        padding: const EdgeInsets.all(DesignTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Technician name and summary
            Row(
              children: [
                Text(
                  schedule.technicianName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${schedule.totalAppointments} appointments',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceS),
            
            // Timeline row
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  // Technician name (fixed width)
                  SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          schedule.technicianName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (schedule.totalTravelTimeMinutes > 0)
                          Text(
                            '${schedule.totalTravelTimeMinutes} min travel',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceM),
                  
                  // Timeline with appointments
                  Expanded(
                    child: Stack(
                      children: [
                        // Background grid
                        _TimelineGrid(),
                        
                        // Appointment blocks
                        ...sortedAppointments.map((appointment) {
                          return _AppointmentBlock(
                            appointment: appointment,
                            onTap: () => onAppointmentTap?.call(appointment),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: List.generate(
        TimelineView.totalHours,
        (index) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppointmentBlock extends StatelessWidget {
  const _AppointmentBlock({
    required this.appointment,
    this.onTap,
  });

  final AppointmentSlot appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (appointment.appointmentDateTime == null) {
      return const SizedBox.shrink();
    }

    // Calculate position and width based on time
    final appointmentTime = appointment.appointmentDateTime!;
    final startMinutes = (appointmentTime.hour - TimelineView.startHour) * 60 + appointmentTime.minute;
    final durationMinutes = appointment.estimatedDurationMinutes;
    
    final startPosition = startMinutes / (TimelineView.totalHours * 60.0);
    final width = durationMinutes / (TimelineView.totalHours * 60.0);
    
    // Clamp to valid range
    final clampedStart = startPosition.clamp(0.0, 1.0);
    final clampedWidth = (startPosition + width).clamp(0.0, 1.0) - clampedStart;

    if (clampedWidth <= 0) {
      return const SizedBox.shrink();
    }

    final color = _getStatusColor(context, appointment.status);

    return Positioned(
      left: MediaQuery.of(context).size.width * clampedStart * 0.7, // Adjust for fixed width column
      width: MediaQuery.of(context).size.width * clampedWidth * 0.7,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            border: Border.all(
              color: color,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appointment.claimNumber,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (durationMinutes > 30)
                  Text(
                    '${durationMinutes}min',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, ClaimStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case ClaimStatus.newClaim:
        return theme.colorScheme.primary;
      case ClaimStatus.inContact:
        return Colors.blue;
      case ClaimStatus.scheduled:
        return Colors.orange;
      case ClaimStatus.workInProgress:
        return Colors.purple;
      case ClaimStatus.closed:
        return Colors.green;
      case ClaimStatus.cancelled:
        return Colors.grey;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}

