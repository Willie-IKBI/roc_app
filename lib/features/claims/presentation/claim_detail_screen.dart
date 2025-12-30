import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/design_tokens.dart';
import 'package:flutter/foundation.dart';
import '../../../core/widgets/glass_badge.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_empty_state.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../domain/models/claim.dart';
import '../../../domain/models/claim_item.dart';
import '../../../domain/models/claim_status_change.dart';
import '../../../domain/models/contact_attempt.dart';
import '../../../domain/models/contact_attempt_input.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../../domain/value_objects/contact_method.dart';
import '../controller/agent_lookup_provider.dart';
import '../../claims/controller/detail_controller.dart';
import '../../claims/controller/reference_data_providers.dart';
import '../../claims/controller/technician_controller.dart';
import 'widgets/technician_selector.dart';
import 'widgets/appointment_picker.dart';

class ClaimDetailScreen extends ConsumerWidget {
  const ClaimDetailScreen({required this.claimId, super.key});

  final String claimId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claim = ref.watch(claimDetailControllerProvider(claimId));
    final notifier = ref.read(claimDetailControllerProvider(claimId).notifier);
    final isBusy = claim.isLoading;
    final insurers = ref.watch(insurersOptionsProvider);
    final claimData = claim.asData?.value;

    String? resolvedInsurer;
    if (claimData != null) {
      resolvedInsurer = insurers.maybeWhen(
        data: (options) => options
            .firstWhereOrNull((option) => option.id == claimData.insurerId)
            ?.label,
        orElse: () => null,
      );
    }
    final clientName = claimData != null 
        ? (claimData.client?.fullName ?? '').trim()
        : null;
    final titleParts = <String>[];
    if (resolvedInsurer != null && resolvedInsurer.isNotEmpty) {
      titleParts.add(resolvedInsurer);
    }
    if (clientName != null && clientName.isNotEmpty) {
      titleParts.add(clientName);
    }
    final appBarTitle = titleParts.isEmpty
        ? 'Claim ${claimData?.claimNumber ?? claimId}'
        : titleParts.join(' • ');

    Future<void> logContactAttempt(Claim detail) async {
      final input = await showGlassDialog<ContactAttemptInput>(
        context: context,
        builder: (context) => const _ContactAttemptDialog(),
      );
      if (input == null) return;

      await notifier.addContactAttempt(claimId: claimId, input: input);
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final state = ref.read(claimDetailControllerProvider(claimId));
      state.when(
        data: (_) => messenger.showSnackBar(
          const SnackBar(content: Text(AppStrings.contactAttemptLogged)),
        ),
        error: (error, _) => messenger.showSnackBar(
          SnackBar(content: Text('${AppStrings.contactAttemptFailed}: $error')),
        ),
        loading: () {},
      );
    }

    Future<void> changeStatus(Claim detail) async {
      final result = await showGlassDialog<_ChangeStatusResult>(
        context: context,
        builder: (context) => _ChangeStatusDialog(currentStatus: detail.status),
      );
      if (result == null) return;
      if (!context.mounted) return;
      if (result.newStatus == detail.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status unchanged')),
        );
        return;
      }

      await notifier.changeStatus(
        claimId: claimId,
        newStatus: result.newStatus,
        reason: result.reason,
      );
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final state = ref.read(claimDetailControllerProvider(claimId));
      state.when(
        data: (_) => messenger.showSnackBar(
          SnackBar(
            content: Text('${AppStrings.statusChanged}: ${result.newStatus.label}'),
          ),
        ),
        error: (error, _) => messenger.showSnackBar(
          SnackBar(content: Text('${AppStrings.statusChangeFailed}: $error')),
        ),
        loading: () {},
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.65),
            indicatorColor: DesignTokens.textPrimary(Theme.of(context).brightness),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Items'),
              Tab(text: 'Contact'),
              Tab(text: 'Status'),
            ],
          ),
        ),
        body: SafeArea(
          child: claim.when(
            data: (detail) {
              final agentNameAsync =
                  ref.watch(agentNameProvider(detail.agentId));
              final resolvedAgentName = agentNameAsync.asData?.value;

              return TabBarView(
              children: [
                _OverviewTab(
                  detail: detail,
                  isBusy: isBusy,
                  onLogContact: () => logContactAttempt(detail),
                    onChangeStatus: () => changeStatus(detail),
                    agentName: resolvedAgentName,
                    claimId: claimId,
                    notifier: notifier,
                ),
                _ItemsTab(items: detail.items),
                _ContactAttemptsTab(attempts: detail.contactAttempts),
                _StatusHistoryTab(history: detail.statusHistory),
              ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => GlassErrorState(
              title: 'Unable to load claim',
              message: getUserFriendlyErrorMessage(error, isDebugMode: kDebugMode),
              onRetry: notifier.refresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.detail,
    required this.isBusy,
    required this.onLogContact,
    required this.onChangeStatus,
    this.agentName,
    required this.claimId,
    required this.notifier,
  });

  final Claim detail;
  final bool isBusy;
  final VoidCallback onLogContact;
  final VoidCallback onChangeStatus;
  final String? agentName;
  final String claimId;
  final ClaimDetailController notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const slaTarget = Duration(minutes: 120);
    final elapsed = DateTime.now().difference(detail.slaStartedAt);
    final elapsedMinutes = elapsed.inMinutes;
    final bool isClosed = detail.closedAt != null;
    final bool isBreached = !isClosed && elapsed > slaTarget;
    final double progress = slaTarget.inSeconds == 0
        ? 1
        : (elapsed.inSeconds / slaTarget.inSeconds).clamp(0, 1);

    Color slaColor;
    if (isBreached) {
      slaColor = theme.colorScheme.error;
    } else if (progress >= 0.75) {
      slaColor = theme.colorScheme.tertiary;
    } else {
      slaColor = theme.colorScheme.primary;
    }

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      children: [
        GlassCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Claim', style: theme.textTheme.titleMedium),
                const SizedBox(height: DesignTokens.spaceM),
                _KeyValueRow(label: 'Claim number', value: detail.claimNumber),
                _KeyValueRow(
                  label: 'Status',
                  value: detail.status.label,
                ),
                _KeyValueRow(label: 'Priority', value: detail.priority.name),
                _KeyValueRow(
                  label: 'Damage cause',
                  value: detail.damageCause.name,
                ),
                _KeyValueRow(
                  label: 'Agent',
                  value: agentName ??
                      (detail.agentId == null
                          ? 'Unassigned'
                          : detail.agentId!),
                ),
                if (detail.technicianId != null || detail.appointmentDate != null) ...[
                  const SizedBox(height: DesignTokens.spaceM),
                  const Divider(),
                  const SizedBox(height: DesignTokens.spaceM),
                  Text('Technician & Appointment', style: theme.textTheme.titleSmall),
                  const SizedBox(height: DesignTokens.spaceS),
                  if (detail.technicianId != null)
                    Consumer(
                      builder: (context, ref, _) {
                        final techniciansAsync = ref.watch(techniciansProvider);
                        return techniciansAsync.when(
                          data: (technicians) {
                            final technician = technicians.firstWhere(
                              (t) => t.id == detail.technicianId,
                              orElse: () => technicians.first,
                            );
                            return _KeyValueRow(
                              label: 'Technician',
                              value: technician.fullName,
                            );
                          },
                          loading: () => const _KeyValueRow(
                            label: 'Technician',
                            value: 'Loading...',
                          ),
                          error: (_, __) => const _KeyValueRow(
                            label: 'Technician',
                            value: 'Unknown',
                          ),
                        );
                      },
                    ),
                  if (detail.appointmentDate != null)
                    _KeyValueRow(
                      label: 'Appointment Date',
                      value: detail.appointmentDate!.toLocal().toString().split(' ')[0],
                    ),
                  if (detail.appointmentTime != null)
                    _KeyValueRow(
                      label: 'Appointment Time',
                      value: detail.appointmentTime!,
                    ),
                ],
              ],
            ),
          ),
        const SizedBox(height: DesignTokens.spaceM),
        GlassCard(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SLA', style: theme.textTheme.titleMedium),
                const SizedBox(height: DesignTokens.spaceM),
                Text(
                  'Started at ${detail.slaStartedAt.toLocal()}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(slaColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$elapsedMinutes min elapsed • Target ${slaTarget.inMinutes} min',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: DesignTokens.spaceM),
                Wrap(
                  spacing: DesignTokens.spaceS,
                  runSpacing: DesignTokens.spaceS,
                  children: [
                    GlassButton.primary(
                      onPressed: isBusy ? null : onLogContact,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.call_outlined),
                          SizedBox(width: DesignTokens.spaceS),
                          Text('Contact client'),
                        ],
                      ),
                    ),
                    GlassButton.outlined(
                      onPressed: isBusy ? null : onChangeStatus,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz),
                          SizedBox(width: DesignTokens.spaceS),
                          Text('Change status'),
                        ],
                      ),
                    ),
                    GlassButton.outlined(
                      onPressed: isBusy ? null : () => _showTechnicianDialog(context, detail),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: DesignTokens.spaceS),
                          Text('Assign technician'),
                        ],
                      ),
                    ),
                    GlassBadge.custom(
                      label: isBreached ? 'SLA breached' : 'Within SLA',
                      color: slaColor,
                    ),
                    if (detail.latestContact != null)
                      Chip(
                        avatar: const Icon(Icons.history, size: 16),
                        label: Text(
                          'Last contact ${detail.latestContact!.attemptedAt.toLocal()}',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: DesignTokens.spaceM),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client', style: theme.textTheme.titleMedium),
                const SizedBox(height: DesignTokens.spaceM),
                _KeyValueRow(
                  label: 'Name',
                  value: detail.client?.fullName ?? 'Unknown client',
                ),
                _KeyValueRow(
                  label: 'Primary phone',
                  value: detail.client?.primaryPhone ?? '–',
                ),
                _KeyValueRow(
                  label: 'Email',
                  value: detail.client?.email ?? '–',
                ),
              ],
            ),
          ),
        const SizedBox(height: DesignTokens.spaceM),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address', style: theme.textTheme.titleMedium),
                const SizedBox(height: DesignTokens.spaceM),
                _KeyValueRow(
                  label: 'Street',
                  value: detail.address?.street ?? '–',
                ),
                _KeyValueRow(
                  label: 'Suburb',
                  value: detail.address?.suburb ?? '–',
                ),
                _KeyValueRow(
                  label: 'Postal code',
                  value: detail.address?.postalCode ?? '–',
                ),
                _KeyValueRow(
                  label: 'City',
                  value: detail.address?.city ?? '–',
                ),
              ],
            ),
          ),
        const SizedBox(height: DesignTokens.spaceM),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes', style: theme.textTheme.titleMedium),
                const SizedBox(height: DesignTokens.spaceM),
                Text(
                  detail.notesInternal ?? 'No internal notes captured.',
                  style: theme.textTheme.bodyMedium,
                ),
                const Divider(height: 24),
                Text(
                  detail.notesPublic ?? 'No client-facing notes captured.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showTechnicianDialog(BuildContext context, Claim detail) {
    showGlassDialog(
      context: context,
      builder: (context) => _TechnicianAppointmentDialog(
        claimId: claimId,
        notifier: notifier,
        currentTechnicianId: detail.technicianId,
        currentAppointmentDate: detail.appointmentDate,
        currentAppointmentTime: detail.appointmentTime,
      ),
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab({required this.items});

  final List<ClaimItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const GlassEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No items captured yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
          child: ListTile(
            title: Text(item.brand),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.serialOrModel != null)
                  Text('Serial/model: ${item.serialOrModel}'),
                Text('Warranty: ${item.warranty.name}'),
                if (item.notes != null) Text('Notes: ${item.notes}'),
              ],
            ),
            trailing: Text('#${index + 1}'),
          ),
        );
      },
    );
  }
}

class _ContactAttemptsTab extends StatelessWidget {
  const _ContactAttemptsTab({required this.attempts});

  final List<ContactAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    if (attempts.isEmpty) {
      return const GlassEmptyState(
        icon: Icons.phone_outlined,
        title: 'No contact attempts logged yet',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      itemCount: attempts.length,
      separatorBuilder: (_, __) => const SizedBox(height: DesignTokens.spaceS),
      itemBuilder: (context, index) {
        final attempt = attempts[index];
        return GlassCard(
          child: ListTile(
            title: Text(
              '${attempt.method.label} • ${attempt.outcome.name.replaceAll('_', ' ')}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By ${attempt.attemptedBy} at ${attempt.attemptedAt.toLocal()}',
                ),
                if (attempt.notes != null) Text(attempt.notes!),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusHistoryTab extends ConsumerWidget {
  const _StatusHistoryTab({required this.history});

  final List<ClaimStatusChange> history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (history.isEmpty) {
      return const GlassEmptyState(
        icon: Icons.history_outlined,
        title: 'No status changes yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final change = history[index];
        final agentNameAsync = ref.watch(agentNameProvider(change.changedBy));
        final changedByName = agentNameAsync.asData?.value ??
            change.changedBy ??
            'System';
        return GlassCard(
          margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
          child: ListTile(
            title: Text(
              '${change.fromStatus.name} → ${change.toStatus.name}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Changed by $changedByName'),
                Text('At ${change.changedAt.toLocal()}'),
                if (change.reason != null) Text('Reason: ${change.reason}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.monospace(),
            ),
          ),
        ],
      ),
    );
  }
}


class _ContactAttemptDialog extends StatefulWidget {
  const _ContactAttemptDialog();

  @override
  State<_ContactAttemptDialog> createState() => _ContactAttemptDialogState();
}

class _ContactAttemptDialogState extends State<_ContactAttemptDialog> {
  final _formKey = GlobalKey<FormState>();
  ContactMethod _method = ContactMethod.phone;
  ContactOutcome _outcome = ContactOutcome.noAnswer;
  final TextEditingController _notesController = TextEditingController();
  bool _sendSms = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: const Text('Log contact attempt'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ContactMethod>(
              initialValue: _method,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Method',
              ),
              items: ContactMethod.values
                  .map(
                    (method) => DropdownMenuItem(
                      value: method,
                      child: Text(method.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _method = value);
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ContactOutcome>(
              initialValue: _outcome,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Outcome',
              ),
              items: ContactOutcome.values
                  .map(
                    (outcome) => DropdownMenuItem(
                      value: outcome,
                      child: Text(outcome.name.replaceAll('_', ' ')),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _outcome = value);
                }
              },
            ),
            const SizedBox(height: 12),
            GlassInput.textForm(
              context: context,
              controller: _notesController,
              label: 'Notes',
              hint: 'Outcome notes or next steps',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Send follow-up SMS'),
              value: _sendSms,
              onChanged: (value) => setState(() => _sendSms = value),
            ),
          ],
        ),
      ),
      actions: [
        GlassButton.ghost(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        GlassButton.primary(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(
                ContactAttemptInput(
                  method: _method,
                  outcome: _outcome,
                  notes: _notesController.text.trim().isEmpty
                      ? null
                      : _notesController.text.trim(),
                  sendSmsTemplate: _sendSms,
                ),
              );
            }
          },
          child: const Text('Log attempt'),
        ),
      ],
    );
  }
}

class _ChangeStatusDialog extends StatefulWidget {
  const _ChangeStatusDialog({required this.currentStatus});

  final ClaimStatus currentStatus;

  @override
  State<_ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<_ChangeStatusDialog> {
  late ClaimStatus _selectedStatus;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = ClaimStatus.values.toList(growable: false);
    return GlassDialog(
      title: const Text('Change status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ClaimStatus>(
            initialValue: _selectedStatus,
            decoration: GlassInput.decoration(
              context: context,
              label: 'New status',
            ),
            items: options
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStatus = value);
              }
            },
          ),
          const SizedBox(height: 12),
          GlassInput.text(
            context: context,
            controller: _reasonController,
            label: 'Reason (optional)',
            hint: 'Provide context for this change',
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        GlassButton.ghost(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        GlassButton.primary(
          onPressed: () {
            Navigator.of(context).pop(
              _ChangeStatusResult(
                newStatus: _selectedStatus,
                reason: _reasonController.text.trim().isEmpty
                    ? null
                    : _reasonController.text.trim(),
              ),
            );
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

class _ChangeStatusResult {
  _ChangeStatusResult({required this.newStatus, this.reason});

  final ClaimStatus newStatus;
  final String? reason;
}

class _TechnicianAppointmentDialog extends ConsumerStatefulWidget {
  const _TechnicianAppointmentDialog({
    required this.claimId,
    required this.notifier,
    this.currentTechnicianId,
    this.currentAppointmentDate,
    this.currentAppointmentTime,
  });

  final String claimId;
  final ClaimDetailController notifier;
  final String? currentTechnicianId;
  final DateTime? currentAppointmentDate;
  final String? currentAppointmentTime;

  @override
  ConsumerState<_TechnicianAppointmentDialog> createState() => _TechnicianAppointmentDialogState();
}

class _TechnicianAppointmentDialogState extends ConsumerState<_TechnicianAppointmentDialog> {
  String? _selectedTechnicianId;
  DateTime? _selectedAppointmentDate;
  String? _selectedAppointmentTime;

  @override
  void initState() {
    super.initState();
    _selectedTechnicianId = widget.currentTechnicianId;
    _selectedAppointmentDate = widget.currentAppointmentDate;
    _selectedAppointmentTime = widget.currentAppointmentTime;
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: const Text('Assign Technician & Appointment'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TechnicianSelector(
              selectedTechnicianId: _selectedTechnicianId,
              appointmentDate: _selectedAppointmentDate,
              onTechnicianSelected: (technicianId) {
                setState(() {
                  _selectedTechnicianId = technicianId;
                });
              },
            ),
            const SizedBox(height: DesignTokens.spaceM),
            AppointmentPicker(
              selectedDate: _selectedAppointmentDate,
              selectedTime: _selectedAppointmentTime,
              onDateSelected: (date) {
                setState(() {
                  _selectedAppointmentDate = date;
                });
              },
              onTimeSelected: (time) {
                setState(() {
                  _selectedAppointmentTime = time;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        GlassButton.ghost(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        GlassButton.primary(
          onPressed: () async {
            await widget.notifier.updateTechnician(
              claimId: widget.claimId,
              technicianId: _selectedTechnicianId,
            );
            await widget.notifier.updateAppointment(
              claimId: widget.claimId,
              appointmentDate: _selectedAppointmentDate,
              appointmentTime: _selectedAppointmentTime,
            );
            if (!context.mounted) return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Technician and appointment updated')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

