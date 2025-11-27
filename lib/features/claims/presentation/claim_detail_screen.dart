import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final clientName = claimData?.client?.fullName?.trim();
    final titleParts = <String>[];
    if (resolvedInsurer != null && resolvedInsurer!.isNotEmpty) {
      titleParts.add(resolvedInsurer!);
    }
    if (clientName != null && clientName.isNotEmpty) {
      titleParts.add(clientName);
    }
    final appBarTitle = titleParts.isEmpty
        ? 'Claim ${claimData?.claimNumber ?? claimId}'
        : titleParts.join(' • ');

    Future<void> logContactAttempt(Claim detail) async {
      final input = await showDialog<ContactAttemptInput>(
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
          const SnackBar(content: Text('Contact attempt logged')),
        ),
        error: (error, _) => messenger.showSnackBar(
          SnackBar(content: Text('Failed to log attempt: $error')),
        ),
        loading: () {},
      );
    }

    Future<void> changeStatus(Claim detail) async {
      final result = await showDialog<_ChangeStatusResult>(
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
            content: Text(
              'Status changed to ${result.newStatus.name.replaceAll('_', ' ')}',
            ),
          ),
        ),
        error: (error, _) => messenger.showSnackBar(
          SnackBar(content: Text('Failed to change status: $error')),
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
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.65),
            indicatorColor: Theme.of(context).colorScheme.primary,
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
                ),
                _ItemsTab(items: detail.items),
                _ContactAttemptsTab(attempts: detail.contactAttempts),
                _StatusHistoryTab(history: detail.statusHistory),
              ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _DetailError(
              message: error.toString(),
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
  });

  final Claim detail;
  final bool isBusy;
  final VoidCallback onLogContact;
  final VoidCallback onChangeStatus;
  final String? agentName;

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
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Claim', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _KeyValueRow(label: 'Claim number', value: detail.claimNumber),
                _KeyValueRow(
                  label: 'Status',
                  value: detail.status.name.replaceAll('_', ' '),
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SLA', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: isBusy ? null : onLogContact,
                      icon: const Icon(Icons.call_outlined),
                      label: const Text('Contact client'),
                    ),
                    OutlinedButton.icon(
                      onPressed: isBusy ? null : onChangeStatus,
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Change status'),
                    ),
                    Chip(
                      avatar: Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: slaColor,
                      ),
                      backgroundColor: slaColor.withValues(alpha: 0.15),
                      label: Text(isBreached ? 'SLA breached' : 'Within SLA'),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color: slaColor,
                      ),
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
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
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
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
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
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
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
        ),
      ],
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab({required this.items});

  final List<ClaimItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyState(message: 'No items captured yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
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
      return const _EmptyState(message: 'No contact attempts logged yet.');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: attempts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final attempt = attempts[index];
        return Card(
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
      return const _EmptyState(message: 'No status changes yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final change = history[index];
        final agentNameAsync = ref.watch(agentNameProvider(change.changedBy));
        final changedByName = agentNameAsync.asData?.value ??
            change.changedBy ??
            'System';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
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
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Unable to load claim',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
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
    return AlertDialog(
      title: const Text('Log contact attempt'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ContactMethod>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Method'),
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
              decoration: const InputDecoration(labelText: 'Outcome'),
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
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Outcome notes or next steps',
              ),
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
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
    return AlertDialog(
      title: const Text('Change status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ClaimStatus>(
            initialValue: _selectedStatus,
            decoration: const InputDecoration(labelText: 'New status'),
            items: options
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(status.name.replaceAll('_', ' ')),
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
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Reason (optional)',
              hintText: 'Provide context for this change',
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
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

