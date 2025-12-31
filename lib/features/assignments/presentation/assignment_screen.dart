import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_empty_state.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../data/repositories/claim_repository_supabase.dart';
import '../../../domain/models/claim.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/models/user_account.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../claims/controller/technician_controller.dart';
import '../controller/assignment_controller.dart';
import 'widgets/assignment_dialog.dart';
import 'widgets/job_assignment_card.dart';

/// Main assignment screen for viewing and assigning technicians to jobs.
class AssignmentScreen extends ConsumerStatefulWidget {
  const AssignmentScreen({super.key});

  @override
  ConsumerState<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends ConsumerState<AssignmentScreen> {
  ClaimStatus? _statusFilter;
  bool? _assignedFilter; // null = all, true = assigned, false = unassigned
  String? _technicianFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _highlightClaimId; // For scrolling to a specific claim

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Parse query parameters
    final uri = GoRouterState.of(context).uri;
    final queryParams = uri.queryParameters;
    
    // Parse date
    if (queryParams.containsKey('date')) {
      try {
        final dateStr = queryParams['date']!;
        final date = DateTime.parse(dateStr);
        _dateFrom = date;
        _dateTo = date;
      } catch (_) {
        // Invalid date, ignore
      }
    }
    
    // Parse claimId
    if (queryParams.containsKey('claimId')) {
      _highlightClaimId = queryParams['claimId'];
    }
    
    // Parse technicianId
    if (queryParams.containsKey('technicianId')) {
      _technicianFilter = queryParams['technicianId'];
    }
    
    // Parse status
    if (queryParams.containsKey('status')) {
      try {
        _statusFilter = ClaimStatus.fromJson(queryParams['status']!);
      } catch (_) {
        // Invalid status, ignore
      }
    }
    
    // Parse assigned
    if (queryParams.containsKey('assigned')) {
      _assignedFilter = queryParams['assigned'] == 'true';
    }
  }

  void _clearFilters() {
    setState(() {
      _statusFilter = null;
      _assignedFilter = null;
      _technicianFilter = null;
      _dateFrom = null;
      _dateTo = null;
    });
    ref.read(assignableJobsControllerProvider(
      statusFilter: null,
      assignedFilter: null,
      technicianIdFilter: null,
      dateFrom: null,
      dateTo: null,
    ).notifier).updateFilters(
      statusFilter: null,
      assignedFilter: null,
      technicianIdFilter: null,
      dateFrom: null,
      dateTo: null,
    );
  }

  Future<void> _showAssignmentDialog(ClaimSummary claimSummary) async {
    // Fetch full claim to get current assignment details
    final claimRepository = ref.read(claimRepositoryProvider);
    final claimResult = await claimRepository.fetchById(claimSummary.claimId);
    
    if (claimResult.isErr) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load claim details: ${claimResult.error}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final claim = claimResult.data;
    final result = await showGlassDialog<bool>(
      context: context,
      builder: (context) => AssignmentDialog(
        claimId: claimSummary.claimId,
        currentTechnicianId: claim.technicianId,
        currentAppointmentDate: claim.appointmentDate,
        currentAppointmentTime: claim.appointmentTime,
      ),
    );

    if (result == true && mounted) {
      // Refresh the list
      ref.read(assignableJobsControllerProvider(
        statusFilter: _statusFilter,
        assignedFilter: _assignedFilter,
        technicianIdFilter: _technicianFilter,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      ).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobsStateAsync = ref.watch(assignableJobsControllerProvider(
      statusFilter: _statusFilter,
      assignedFilter: _assignedFilter,
      technicianIdFilter: _technicianFilter,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    ));
    final techniciansAsync = ref.watch(techniciansProvider);
    final selectedDate = _dateFrom ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Assignments'),
        actions: [
          GlassButton.ghost(
            onPressed: () {
              final dateStr = selectedDate.toIso8601String().split('T')[0];
              context.push('/scheduling?date=$dateStr');
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('View Schedule'),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter bar
            _FilterBar(
              statusFilter: _statusFilter,
              assignedFilter: _assignedFilter,
              technicianFilter: _technicianFilter,
              dateFrom: _dateFrom,
              dateTo: _dateTo,
              techniciansAsync: techniciansAsync,
              onStatusChanged: (status) {
                setState(() => _statusFilter = status);
                ref.read(assignableJobsControllerProvider(
                  statusFilter: status,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                ).notifier).updateFilters(
                  statusFilter: status,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                );
              },
              onAssignedChanged: (assigned) {
                setState(() => _assignedFilter = assigned);
                ref.read(assignableJobsControllerProvider(
                  statusFilter: _statusFilter,
                  assignedFilter: assigned,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                ).notifier).updateFilters(
                  statusFilter: _statusFilter,
                  assignedFilter: assigned,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                );
              },
              onTechnicianChanged: (technicianId) {
                setState(() => _technicianFilter = technicianId);
                ref.read(assignableJobsControllerProvider(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: technicianId,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                ).notifier).updateFilters(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: technicianId,
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                );
              },
              onDateFromChanged: (date) {
                setState(() => _dateFrom = date);
                ref.read(assignableJobsControllerProvider(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: date,
                  dateTo: _dateTo,
                ).notifier).updateFilters(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: date,
                  dateTo: _dateTo,
                );
              },
              onDateToChanged: (date) {
                setState(() => _dateTo = date);
                ref.read(assignableJobsControllerProvider(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: date,
                ).notifier).updateFilters(
                  statusFilter: _statusFilter,
                  assignedFilter: _assignedFilter,
                  technicianIdFilter: _technicianFilter,
                  dateFrom: _dateFrom,
                  dateTo: date,
                );
              },
              onClearFilters: _clearFilters,
            ),
            
            // Summary cards
            jobsStateAsync.when(
              data: (state) => _SummaryCards(jobs: state.items),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: DesignTokens.spaceM),
            
            // Job list
            Expanded(
              child: jobsStateAsync.when(
                data: (state) {
                  if (state.items.isEmpty && !state.isLoading) {
                    return const GlassEmptyState(
                      icon: Icons.assignment_outlined,
                      title: 'No jobs found',
                      description: 'Try adjusting your filters or check back later.',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(assignableJobsControllerProvider(
                        statusFilter: _statusFilter,
                        assignedFilter: _assignedFilter,
                        technicianIdFilter: _technicianFilter,
                        dateFrom: _dateFrom,
                        dateTo: _dateTo,
                      ).notifier).refresh();
                    },
                    child: Consumer(
                      builder: (context, ref, child) {
                        final techniciansAsync = ref.watch(techniciansProvider);
                        final techniciansMap = techniciansAsync.maybeWhen(
                          data: (technicians) => {for (var t in technicians) t.id: t.fullName},
                          orElse: () => <String, String>{},
                        );
                        
                        return ListView.builder(
                          padding: const EdgeInsets.all(DesignTokens.spaceM),
                          itemCount: state.items.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Load more trigger
                            if (index == state.items.length) {
                              // Trigger load more when near bottom
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref.read(assignableJobsControllerProvider(
                                  statusFilter: _statusFilter,
                                  assignedFilter: _assignedFilter,
                                  technicianIdFilter: _technicianFilter,
                                  dateFrom: _dateFrom,
                                  dateTo: _dateTo,
                                ).notifier).loadNextPage();
                              });
                              return state.isLoadingMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(DesignTokens.spaceM),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            }

                            final job = state.items[index];
                            // Note: v_claims_list may not have appointment_date/appointment_time
                            // For now, we'll fetch only when dialog opens (not for each card)
                            // This eliminates N+1 queries for the list view
                            return JobAssignmentCard(
                              claim: job,
                              technicianName: null, // Will be shown in dialog if needed
                              appointmentDate: null, // Will be fetched in dialog if needed
                              appointmentTime: null, // Will be fetched in dialog if needed
                              onAssign: () => _showAssignmentDialog(job),
                              onReassign: () => _showAssignmentDialog(job),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => GlassErrorState(
                  title: 'Failed to load jobs',
                  message: error.toString(),
                  onRetry: () {
                    ref.read(assignableJobsControllerProvider(
                      statusFilter: _statusFilter,
                      assignedFilter: _assignedFilter,
                      technicianIdFilter: _technicianFilter,
                      dateFrom: _dateFrom,
                      dateTo: _dateTo,
                    ).notifier).refresh();
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.statusFilter,
    required this.assignedFilter,
    required this.technicianFilter,
    required this.dateFrom,
    required this.dateTo,
    required this.techniciansAsync,
    required this.onStatusChanged,
    required this.onAssignedChanged,
    required this.onTechnicianChanged,
    required this.onDateFromChanged,
    required this.onDateToChanged,
    required this.onClearFilters,
  });

  final ClaimStatus? statusFilter;
  final bool? assignedFilter;
  final String? technicianFilter;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final AsyncValue<List<UserAccount>> techniciansAsync;
  final ValueChanged<ClaimStatus?> onStatusChanged;
  final ValueChanged<bool?> onAssignedChanged;
  final ValueChanged<String?> onTechnicianChanged;
  final ValueChanged<DateTime?> onDateFromChanged;
  final ValueChanged<DateTime?> onDateToChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFilters = statusFilter != null ||
        assignedFilter != null ||
        technicianFilter != null ||
        dateFrom != null ||
        dateTo != null;

    return GlassCard(
      margin: const EdgeInsets.all(DesignTokens.spaceM),
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (hasFilters)
                GlassButton.ghost(
                  onPressed: onClearFilters,
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceM),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              final filterWidth = isSmallScreen
                  ? constraints.maxWidth - (DesignTokens.spaceM * 2)
                  : () {
                      // Calculate available width accounting for card padding
                      final availableWidth = constraints.maxWidth - (DesignTokens.spaceM * 2);
                      // Calculate total spacing between 5 filters (4 gaps)
                      final totalSpacing = (5 - 1) * DesignTokens.spaceM;
                      // Calculate width per filter, clamped between 120px and 200px
                      return ((availableWidth - totalSpacing) / 5).clamp(120.0, 200.0);
                    }();
              
              return Wrap(
                spacing: DesignTokens.spaceM,
                runSpacing: DesignTokens.spaceM,
                children: [
                  // Status filter
                  SizedBox(
                    width: filterWidth,
                    child: DropdownButtonFormField<ClaimStatus?>(
                      value: statusFilter,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All statuses')),
                        ...ClaimStatus.values.map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        ),
                      ],
                      onChanged: onStatusChanged,
                    ),
                  ),
                  
                  // Assignment filter
                  SizedBox(
                    width: filterWidth,
                    child: DropdownButtonFormField<bool?>(
                      value: assignedFilter,
                      decoration: InputDecoration(
                        labelText: 'Assignment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All')),
                        DropdownMenuItem(value: true, child: Text('Assigned')),
                        DropdownMenuItem(value: false, child: Text('Unassigned')),
                      ],
                      onChanged: onAssignedChanged,
                    ),
                  ),
                  
                  // Technician filter
                  techniciansAsync.when(
                    data: (technicians) => SizedBox(
                      width: filterWidth,
                      child: DropdownButtonFormField<String?>(
                        value: technicianFilter,
                        decoration: InputDecoration(
                          labelText: 'Technician',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All technicians')),
                          ...technicians.map(
                            (tech) => DropdownMenuItem(
                              value: tech.id,
                              child: Text(tech.fullName),
                            ),
                          ),
                        ],
                        onChanged: onTechnicianChanged,
                      ),
                    ),
                    loading: () => SizedBox(width: filterWidth, height: 56),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  
                  // Date from
                  SizedBox(
                    width: filterWidth,
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dateFrom ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          onDateFromChanged(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date from',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          dateFrom != null
                              ? DateFormat('yyyy-MM-dd').format(dateFrom!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                  
                  // Date to
                  SizedBox(
                    width: filterWidth,
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dateTo ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          onDateToChanged(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date to',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          dateTo != null
                              ? DateFormat('yyyy-MM-dd').format(dateTo!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.jobs});

  final List<ClaimSummary> jobs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Count assigned/unassigned by checking technician assignment
    // Note: This is approximate since we're working with ClaimSummary
    // For accurate counts, we'd need to fetch full claims, but that's expensive
    // The provider should handle this filtering
    final totalCount = jobs.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceM),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          
          if (isSmallScreen) {
            // Stack vertically on small screens
            return Column(
              children: [
                _SummaryCard(
                  icon: Icons.assignment_outlined,
                  label: 'Total Jobs',
                  value: jobs.length.toString(),
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: DesignTokens.spaceM),
                _SummaryCard(
                  icon: Icons.check_circle_outline,
                  label: 'Total',
                  value: totalCount.toString(),
                  color: Colors.green,
                ),
                const SizedBox(height: DesignTokens.spaceM),
                _SummaryCard(
                  icon: Icons.filter_list_outlined,
                  label: 'Filtered',
                  value: totalCount.toString(),
                  color: Colors.blue,
                ),
              ],
            );
          }
          
          // Use Row on larger screens
          return Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.assignment_outlined,
                  label: 'Total Jobs',
                  value: jobs.length.toString(),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: DesignTokens.spaceM),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.check_circle_outline,
                  label: 'Total',
                  value: totalCount.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: DesignTokens.spaceM),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.filter_list_outlined,
                  label: 'Filtered',
                  value: totalCount.toString(),
                  color: Colors.blue,
                ),
              ),
            ],
          );
        },
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
                  color: theme.colorScheme.onSurfaceVariant,
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

