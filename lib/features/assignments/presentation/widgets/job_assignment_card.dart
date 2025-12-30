import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_badge.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../domain/models/claim_summary.dart';
import '../../../../domain/value_objects/claim_enums.dart';

/// Card widget for displaying job details and assignment status.
class JobAssignmentCard extends StatelessWidget {
  const JobAssignmentCard({
    super.key,
    required this.claim,
    this.technicianName,
    this.appointmentDate,
    this.appointmentTime,
    this.onAssign,
    this.onReassign,
  });

  final ClaimSummary claim;
  final String? technicianName;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final VoidCallback? onAssign;
  final VoidCallback? onReassign;

  Color _statusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.newClaim:
        return const Color(0xFFFF0000);
      case ClaimStatus.inContact:
        return const Color(0xFFFF9800);
      case ClaimStatus.scheduled:
        return const Color(0xFFFFEB3B);
      case ClaimStatus.workInProgress:
        return const Color(0xFF2196F3);
      case ClaimStatus.awaitingClient:
        return const Color(0xFF9C27B0);
      case ClaimStatus.onHold:
        return const Color(0xFF9E9E9E);
      case ClaimStatus.closed:
      case ClaimStatus.cancelled:
        return const Color(0xFF4CAF50);
    }
  }

  String _formatAppointment() {
    if (appointmentDate == null && appointmentTime == null) {
      return 'No appointment set';
    }
    
    final parts = <String>[];
    if (appointmentDate != null) {
      parts.add('${appointmentDate!.day}/${appointmentDate!.month}/${appointmentDate!.year}');
    }
    if (appointmentTime != null) {
      final timeParts = appointmentTime!.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        parts.add('${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period');
      }
    }
    return parts.join(' at ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAssigned = technicianName != null;
    final statusColor = _statusColor(claim.status);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate badge max width from card constraints
          // Card padding: 16px × 2 = 32px
          // Fixed elements: 12 (indicator) + 8 (spacing) + 4 (spacing) = 24px
          // Reserve minimum 100px for claim number
          // Total fixed: 32 + 24 + 100 = 156px
          final badgeMaxWidth = constraints.maxWidth.isFinite
              ? (constraints.maxWidth - 156).clamp(80.0, 180.0)
              : 150.0;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with claim number and status
              Row(
                children: [
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceS),
                  // Claim number - use Expanded to take available space
                  Expanded(
                    child: Text(
                      claim.claimNumber,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceXS),
                  // Status badge - use Flexible with explicit width constraint
                  Flexible(
                    child: SizedBox(
                      width: badgeMaxWidth,
                      child: GlassBadge.custom(
                        label: claim.status.label,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
          const SizedBox(height: DesignTokens.spaceS),
          
          // Client name
          Text(
            claim.clientFullName,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.spaceXS),
          
          // Address
          Text(
            claim.addressShort,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: DesignTokens.spaceS),
          
          // Assignment info
          if (isAssigned) ...[
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: DesignTokens.spaceXS),
                Expanded(
                  child: Text(
                    'Assigned to: $technicianName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceXS),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: DesignTokens.spaceXS),
                Text(
                  'Unassigned',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.spaceXS),
          ],
          
          // Appointment info
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: DesignTokens.spaceXS),
              Expanded(
                child: Text(
                  _formatAppointment(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceM),
          
          // Priority and actions
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 400;
              
              if (isSmallScreen) {
                // Stack vertically on very small screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassBadge.custom(
                      label: claim.priority.value.toUpperCase(),
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(height: DesignTokens.spaceS),
                    Wrap(
                      spacing: DesignTokens.spaceS,
                      runSpacing: DesignTokens.spaceS,
                      children: [
                        if (isAssigned)
                          GlassButton.outlined(
                            onPressed: onReassign,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: DesignTokens.spaceXS),
                                Text('Reassign'),
                              ],
                            ),
                          )
                        else
                          GlassButton.primary(
                            onPressed: onAssign,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_add_outlined, size: 16),
                                SizedBox(width: DesignTokens.spaceXS),
                                Text('Assign'),
                              ],
                            ),
                          ),
                        GlassButton.ghost(
                          onPressed: () => context.push('/claims/${claim.claimId}'),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new_outlined, size: 16),
                              SizedBox(width: DesignTokens.spaceXS),
                              Text('Details'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              
              // Horizontal layout on larger screens
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority badge
                  GlassBadge.custom(
                    label: claim.priority.value.toUpperCase(),
                    color: theme.colorScheme.secondary,
                  ),
                  const Spacer(),
                  // Action buttons - use Wrap for buttons to prevent overflow
                  // Wrap in Expanded to ensure it respects constraints
                  Expanded(
                    child: Wrap(
                      spacing: DesignTokens.spaceS,
                      runSpacing: DesignTokens.spaceS,
                      alignment: WrapAlignment.end,
                      children: [
                        if (isAssigned)
                          GlassButton.outlined(
                            onPressed: onReassign,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: DesignTokens.spaceXS),
                                Text('Reassign'),
                              ],
                            ),
                          )
                        else
                          GlassButton.primary(
                            onPressed: onAssign,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_add_outlined, size: 16),
                                SizedBox(width: DesignTokens.spaceXS),
                                Text('Assign'),
                              ],
                            ),
                          ),
                        GlassButton.ghost(
                          onPressed: () => context.push('/claims/${claim.claimId}'),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new_outlined, size: 16),
                              SizedBox(width: DesignTokens.spaceXS),
                              Text('Details'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
            ],
          );
        },
      ),
    );
  }
}

