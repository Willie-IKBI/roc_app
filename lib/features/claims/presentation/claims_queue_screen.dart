import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/roc_color_scheme.dart';
import '../../../core/widgets/glass_badge.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../claims/controller/queue_controller.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';

class ClaimsQueueScreen extends ConsumerStatefulWidget {
  const ClaimsQueueScreen({
    super.key,
    this.initialStatusFilter,
  });

  final ClaimStatus? initialStatusFilter;

  @override
  ConsumerState<ClaimsQueueScreen> createState() => _ClaimsQueueScreenState();
}

class _ClaimsQueueScreenState extends ConsumerState<ClaimsQueueScreen> {
  ClaimStatus? _statusFilter;
  PriorityLevel? _priorityFilter;
  String? _insurerFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initialStatusFilter;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _statusFilter = null;
      _priorityFilter = null;
      _insurerFilter = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(claimsQueueControllerProvider());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claims Queue'),
        actions: const [],
      ),
      body: SafeArea(
        child: queue.when(
          data: (claims) {
            final insurers = {
              for (final claim in claims) claim.insurerName,
            }.toList()
              ..sort();

            final query = _searchController.text.trim().toLowerCase();
            final filteredClaims = claims.where((claim) {
              final matchesStatus =
                  _statusFilter == null || claim.status == _statusFilter;
              final matchesPriority = _priorityFilter == null ||
                  claim.priority == _priorityFilter;
              final matchesInsurer = _insurerFilter == null ||
                  claim.insurerName == _insurerFilter;
              final matchesSearch = query.isEmpty ||
                  claim.clientFullName.toLowerCase().contains(query) ||
                  claim.claimNumber.toLowerCase().contains(query);
              return matchesStatus && matchesPriority && matchesInsurer && matchesSearch;
            }).toList()
              ..sort((a, b) {
                final cmp = a.slaStartedAt.compareTo(b.slaStartedAt);
                if (cmp != 0) return cmp;
                return b.priority.index.compareTo(a.priority.index);
              });

            if (claims.isEmpty) {
              return const _EmptyQueue();
            }

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(claimsQueueControllerProvider().notifier).refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _FiltersBar(
                    status: _statusFilter,
                    onStatusChanged: (value) => setState(() {
                      _statusFilter = value;
                    }),
                    priority: _priorityFilter,
                    onPriorityChanged: (value) => setState(() {
                      _priorityFilter = value;
                    }),
                    insurer: _insurerFilter,
                    insurers: insurers,
                    onInsurerChanged: (value) => setState(() {
                      _insurerFilter = value;
                    }),
                    searchController: _searchController,
                  onSearchChanged: (_) => setState(() {}),
                    onReset: _resetFilters,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${filteredClaims.length} of ${claims.length} claims',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  if (filteredClaims.isEmpty)
                    const _EmptyQueue(
                      message: 'No claims match the current filters.',
                    )
                  else
                    for (final claim in filteredClaims)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ClaimCard(
                          claim: claim,
                          onTap: () => context.push('/claims/${claim.claimId}'),
                        ),
                      ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => GlassErrorState(
            title: 'Unable to load claims',
            message: error.toString(),
            onRetry: () =>
                ref.read(claimsQueueControllerProvider().notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claim, required this.onTap});

  final ClaimSummary claim;
  final VoidCallback onTap;

  Color _statusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.closed:
        return RocSemanticColors.success;
      case ClaimStatus.awaitingClient:
      case ClaimStatus.onHold:
        return RocSemanticColors.warning;
      case ClaimStatus.cancelled:
        return RocColors.primaryAccent;
      default:
        return RocSemanticColors.neutral;
    }
  }

  Color _slaColor(ThemeData theme) {
    if (claim.isBreached) {
      return theme.colorScheme.error;
    }
    if (claim.isDueSoon) {
      return theme.colorScheme.tertiary;
    }
    return theme.colorScheme.primary;
  }

  String _slaLabel() {
    final elapsedMinutes = claim.elapsed.inMinutes;
    final targetMinutes = claim.slaTarget.inMinutes;
    if (claim.isBreached) {
      final over = elapsedMinutes - targetMinutes;
      return 'SLA breached +${over}m';
    }
    final remaining = targetMinutes - elapsedMinutes;
    return 'SLA ${remaining}m left';
  }

  double _slaProgress() {
    if (claim.isBreached) return 1;
    final target = claim.slaTarget.inSeconds;
    if (target <= 0) return 1;
    final ratio = claim.elapsed.inSeconds / target;
    return ratio.clamp(0, 1).toDouble();
  }

  String _retryLabel() {
    if (claim.readyForRetry) {
      return 'Ready for retry';
    }
    final remaining = claim.timeUntilRetry;
    if (remaining == null) {
      return 'Retry cadence ${claim.retryInterval.inMinutes}m';
    }
    return 'Retry in ${_formatDuration(remaining)}';
  }

  String _formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;
    if (totalMinutes <= 0) return '<1m';
    final hours = duration.inHours;
    final minutes = totalMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    }
    if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slaColor = _slaColor(theme);
    final retryReady = claim.readyForRetry;
    final retryBackground = retryReady
        ? theme.colorScheme.secondary
        : theme.colorScheme.surfaceContainerHighest;
    final retryForeground = retryReady
        ? theme.colorScheme.onSecondary
        : theme.colorScheme.onSurfaceVariant;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    claim.claimNumber,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)
                        ?.monospace(),
                  ),
                  GlassBadge.custom(
                    label: claim.status.label,
                    color: _statusColor(claim.status),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                claim.clientFullName,
                style: theme.textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: DesignTokens.spaceXS),
              Text(
                claim.addressShort,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: DesignTokens.spaceM),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoPill(
                    icon: Icons.local_police_outlined,
                    label: claim.insurerName,
                    color: theme.colorScheme.surfaceContainerHighest,
                    textColor: theme.colorScheme.onSurfaceVariant,
                  ),
                  _InfoPill(
                    icon: Icons.priority_high_outlined,
                    label: 'Priority ${claim.priority.name}',
                    color: theme.colorScheme.surfaceContainerHighest,
                    textColor: theme.colorScheme.onSurfaceVariant,
                  ),
                  _InfoPill(
                    icon: Icons.timer_outlined,
                    label: _slaLabel(),
                    color: slaColor.withValues(alpha: 0.16),
                    textColor: slaColor,
                    iconColor: slaColor,
                  ),
                  _InfoPill(
                    icon: Icons.refresh_outlined,
                    label: 'Attempts ${claim.attemptCount}',
                    color: theme.colorScheme.surfaceContainerHighest,
                    textColor: theme.colorScheme.onSurfaceVariant,
                  ),
                  _InfoPill(
                    icon: Icons.restart_alt_outlined,
                    label: _retryLabel(),
                    color: retryBackground,
                    textColor: retryForeground,
                    iconColor: retryForeground,
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceM),
              ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: _slaProgress(),
                  backgroundColor: DesignTokens.glassBase(theme.brightness),
                  valueColor: AlwaysStoppedAnimation<Color>(slaColor),
                ),
              ),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'Elapsed ${claim.elapsed.inMinutes}m of ${claim.slaTarget.inMinutes}m target',
                style: theme.textTheme.labelSmall?.copyWith(color: slaColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
    this.textColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue({this.message = 'All caught up! New claims will appear here.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined,
              size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text('No claims yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(message,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.status,
    required this.onStatusChanged,
    required this.priority,
    required this.onPriorityChanged,
    required this.insurer,
    required this.insurers,
    required this.onInsurerChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.onReset,
  });

  final ClaimStatus? status;
  final ValueChanged<ClaimStatus?> onStatusChanged;
  final PriorityLevel? priority;
  final ValueChanged<PriorityLevel?> onPriorityChanged;
  final String? insurer;
  final List<String> insurers;
  final ValueChanged<String?> onInsurerChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownMenu<ClaimStatus?>(
                    initialSelection: status,
                    label: const Text('Status'),
                    dropdownMenuEntries: [
                      const DropdownMenuEntry(
                        value: null,
                        label: 'All statuses',
                      ),
                      ...ClaimStatus.values.map(
                        (status) => DropdownMenuEntry(
                          value: status,
                          label: status.label,
                        ),
                      ),
                    ],
                    onSelected: onStatusChanged,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownMenu<PriorityLevel?>(
                    initialSelection: priority,
                    label: const Text('Priority'),
                    dropdownMenuEntries: [
                      const DropdownMenuEntry(
                        value: null,
                        label: 'All priorities',
                      ),
                      ...PriorityLevel.values.map(
                        (priority) => DropdownMenuEntry(
                          value: priority,
                          label: priority.name,
                        ),
                      ),
                    ],
                    onSelected: onPriorityChanged,
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: DropdownMenu<String?>(
                    initialSelection: insurer,
                    label: const Text('Insurer'),
                    dropdownMenuEntries: [
                      const DropdownMenuEntry(
                        value: null,
                        label: 'All insurers',
                      ),
                      ...insurers.map(
                        (insurer) => DropdownMenuEntry(
                          value: insurer,
                          label: insurer,
                        ),
                      ),
                    ],
                    onSelected: onInsurerChanged,
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Client or claim number',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Reset filters'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}


