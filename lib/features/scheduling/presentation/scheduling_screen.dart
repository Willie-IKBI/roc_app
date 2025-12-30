import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_empty_state.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../domain/models/scheduling_models.dart';
import '../controller/scheduling_controller.dart';
import 'widgets/timeline_view.dart';
import 'widgets/appointment_card.dart';

/// Main scheduling screen for viewing and managing technician appointments.
/// 
/// Features:
/// - Date picker to select day
/// - Summary cards showing statistics
/// - Timeline view showing all technicians' schedules
/// - Unassigned appointments list
/// - Filter options
class SchedulingScreen extends ConsumerStatefulWidget {
  const SchedulingScreen({super.key});

  @override
  ConsumerState<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends ConsumerState<SchedulingScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayScheduleAsync = ref.watch(dayScheduleProvider(date: _selectedDate));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with date picker
            _Header(
              selectedDate: _selectedDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            
            // Summary cards
            dayScheduleAsync.when(
              data: (schedule) => _SummaryCards(schedule: schedule),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: DesignTokens.spaceM),
            
            // Main content
            Expanded(
              child: dayScheduleAsync.when(
                data: (schedule) => _MainContent(schedule: schedule),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => GlassErrorState(
                  title: 'Failed to load schedule',
                  message: error.toString(),
                  onRetry: () {
                    ref.invalidate(dayScheduleProvider(date: _selectedDate));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      margin: const EdgeInsets.all(DesignTokens.spaceM),
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Text(
            'Scheduling',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          
          // Date navigation
          GlassButton.ghost(
            onPressed: () {
              onDateChanged(selectedDate.subtract(const Duration(days: 1)));
            },
            child: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: DesignTokens.spaceS),
          
          // Date picker
          GlassButton.outlined(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                onDateChanged(picked);
              }
            },
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: DesignTokens.spaceS),
          
          GlassButton.ghost(
            onPressed: () {
              onDateChanged(selectedDate.add(const Duration(days: 1)));
            },
            child: const Icon(Icons.chevron_right),
          ),
          const SizedBox(width: DesignTokens.spaceS),
          
          // Today button
          GlassButton.ghost(
            onPressed: () {
              onDateChanged(DateTime.now());
            },
            child: const Text('Today'),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          // Assign Jobs button
          GlassButton.outlined(
            onPressed: () {
              final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
              context.push('/assignments?date=$dateStr');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.assignment_ind_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('Assign Jobs'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.schedule});

  final DaySchedule schedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceM),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              icon: Icons.event,
              label: 'Total',
              value: schedule.totalAppointments.toString(),
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryCard(
              icon: Icons.person,
              label: 'Assigned',
              value: schedule.assignedAppointments.toString(),
              color: Colors.green,
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryCard(
              icon: Icons.person_outline,
              label: 'Unassigned',
              value: schedule.unassignedAppointments.length.toString(),
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: _SummaryCard(
              icon: Icons.group,
              label: 'Technicians',
              value: schedule.techniciansWithAppointments.toString(),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: DesignTokens.spaceS),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.schedule});

  final DaySchedule schedule;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline view (main content)
        Expanded(
          flex: 3,
          child: TimelineView(daySchedule: schedule),
        ),
        
        // Unassigned appointments sidebar
        if (schedule.unassignedAppointments.isNotEmpty) ...[
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            flex: 1,
            child: _UnassignedAppointmentsList(
              appointments: schedule.unassignedAppointments,
            ),
          ),
        ],
      ],
    );
  }
}

class _UnassignedAppointmentsList extends StatelessWidget {
  const _UnassignedAppointmentsList({required this.appointments});

  final List<AppointmentSlot> appointments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GlassCard(
      margin: const EdgeInsets.only(right: DesignTokens.spaceM),
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: DesignTokens.spaceS),
              Text(
                'Unassigned Appointments',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceM),
          
          Expanded(
            child: appointments.isEmpty
                ? Center(
                    child: Text(
                      'All appointments are assigned',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
                        child: Column(
                          children: [
                            AppointmentCard(
                              appointment: appointment,
                            ),
                            const SizedBox(height: DesignTokens.spaceXS),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GlassButton.outlined(
                                onPressed: () {
                                  final dateStr = appointment.appointmentDate.toIso8601String().split('T')[0];
                                  context.push('/assignments?claimId=${appointment.claimId}&date=$dateStr');
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person_add_outlined, size: 16),
                                    SizedBox(width: DesignTokens.spaceXS),
                                    Text('Assign'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

