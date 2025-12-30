import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../domain/models/address.dart';
import '../../../../domain/models/scheduling_models.dart';
import '../../../../domain/value_objects/claim_enums.dart';
import '../../../claims/presentation/claim_detail_screen.dart';

/// Card widget displaying appointment details with travel time and status.
/// 
/// Shows claim number, client name, address, appointment time, duration,
/// travel time from previous appointment, status, and priority.
/// Supports clicking to view claim details and drag-and-drop for reassignment.
class AppointmentCard extends ConsumerWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onDragStart,
  });

  final AppointmentSlot appointment;
  final VoidCallback? onTap;
  final VoidCallback? onDragStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap ?? () {
        context.push('/claims/${appointment.claimId}');
      },
      child: GlassCard(
        padding: const EdgeInsets.all(DesignTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Claim number and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.claimNumber,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StatusChip(status: appointment.status),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceS),
            
            // Client name
            Text(
              appointment.clientName,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: DesignTokens.spaceXS),
            
            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: DesignTokens.spaceXS),
                Expanded(
                  child: Text(
                    _formatAddress(appointment.address),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceS),
            
            // Time and duration
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: DesignTokens.spaceXS),
                Text(
                  _formatTime(appointment.appointmentTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: DesignTokens.spaceS),
                Text(
                  '(${appointment.estimatedDurationMinutes} min)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            
            // Travel time (if available)
            if (appointment.travelTimeMinutes != null && appointment.travelTimeMinutes! > 0) ...[
              const SizedBox(height: DesignTokens.spaceXS),
              Row(
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 16,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: DesignTokens.spaceXS),
                  Text(
                    '${appointment.travelTimeMinutes} min travel',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
            
            // Priority badge
            if (appointment.priority != PriorityLevel.normal) ...[
              const SizedBox(height: DesignTokens.spaceXS),
              _PriorityBadge(priority: appointment.priority),
            ],
            
            // Actions
            const SizedBox(height: DesignTokens.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GlassButton.ghost(
                  onPressed: () {
                    final dateStr = appointment.appointmentDate.toIso8601String().split('T')[0];
                    context.push('/assignments?claimId=${appointment.claimId}&date=$dateStr');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 16),
                      SizedBox(width: DesignTokens.spaceXS),
                      Text('Reassign'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(Address address) {
    final parts = <String>[];
    if (address.street.isNotEmpty) parts.add(address.street);
    if (address.suburb.isNotEmpty) parts.add(address.suburb);
    if (parts.isEmpty && address.city != null && address.city!.isNotEmpty) parts.add(address.city!);
    return parts.join(', ');
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getStatusColor(context, status);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: DesignTokens.spaceXS / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
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

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final PriorityLevel priority;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getPriorityColor(context, priority);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceS,
        vertical: DesignTokens.spaceXS / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: DesignTokens.spaceXS / 2),
          Text(
            priority.value.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.normal:
        return Colors.blue;
      case PriorityLevel.high:
        return Colors.orange;
      case PriorityLevel.urgent:
        return Colors.red;
    }
  }
}

