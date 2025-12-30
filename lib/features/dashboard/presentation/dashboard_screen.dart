import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/ambient_glow.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_empty_state.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../core/widgets/pipeline_flow.dart';
import '../../../domain/models/claim_summary.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../controller/dashboard_controller.dart';
import '../domain/dashboard_state.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claims Ops Command Center'),
        actions: [
          IconButton(
            tooltip: 'My profile',
            onPressed: () => context.pushNamed('profile'),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: dashboardState.when(
          data: (data) => _DashboardContent(
            state: data,
            onRefresh: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => GlassErrorState(
            title: 'Could not load dashboard',
            message: error.toString(),
            onRetry: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.state,
    required this.onRefresh,
  });

  final DashboardState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        // Ambient glow background
        if (theme.brightness == Brightness.dark) ...[
          AmbientGlow(
            radius: 320,
            color: DesignTokens.primaryRed.withValues(alpha: 0.2),
            top: -180,
            right: -140,
          ),
          AmbientGlow(
            radius: 360,
            color: const Color(0x331E88F5), // violet
            bottom: -220,
            left: -160,
          ),
        ],
        RefreshIndicator(
          onRefresh: onRefresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              final isTablet = constraints.maxWidth >= 900;
              final horizontalPadding = isDesktop ? DesignTokens.spaceXL : DesignTokens.spaceL;

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: DesignTokens.spaceL,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _QuickActionsBar(isDesktop: isDesktop),
                  const SizedBox(height: DesignTokens.spaceL),
                  _HeroMetricsGrid(
                    state: state,
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: DesignTokens.spaceXL),
                  _CriticalFocusStrip(
                    state: state,
                    isDesktop: isDesktop,
                  ),
                  const SizedBox(height: DesignTokens.spaceXL),
                  _PipelineOverview(state: state),
                  const SizedBox(height: DesignTokens.spaceXL),
                  _LatestActivityTimeline(claims: state.recentClaims),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionsBar extends StatelessWidget {
  const _QuickActionsBar({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operational snapshot',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor claim velocity, SLA exposure, and contact load in real time.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.end,
          children: [
            GlassButton.primary(
              onPressed: () => context.pushNamed('claim-create'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: DesignTokens.spaceS),
                  Text('Capture claim'),
                ],
              ),
            ),
            GlassButton.outlined(
              onPressed: () => context.pushNamed('claims-queue'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt_outlined),
                  SizedBox(width: DesignTokens.spaceS),
                  Text('View queue'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroMetricsGrid extends StatelessWidget {
  const _HeroMetricsGrid({
    required this.state,
    required this.isDesktop,
    required this.isTablet,
  });

  final DashboardState state;
  final bool isDesktop;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final primaryCards = [
      _MetricEmphasisCard(
        title: 'Active claims',
        value: state.totalActiveClaims.toString(),
        subtitle: 'Across all pipelines',
        accent: Colors.redAccent,
      ),
      _MetricEmphasisCard(
        title: 'Overdue SLAs',
        value: state.overdueCount.toString(),
        subtitle: 'Requires immediate attention',
        accent: Colors.deepOrangeAccent,
      ),
    ];

    final secondaryCards = [
      _MetricTileCard(
        title: 'Due soon',
        value: state.dueSoon.toString(),
        subtitle: 'Within SLA window',
        accent: Colors.orangeAccent,
      ),
      _MetricTileCard(
        title: 'Follow-ups',
        value: state.followUpCount.toString(),
        subtitle: 'No contact in last 4h',
        accent: Colors.blueAccent,
      ),
    ];

    if (isDesktop) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: primaryCards[0]),
              const SizedBox(width: 24),
              Expanded(child: primaryCards[1]),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: secondaryCards[0]),
              const SizedBox(width: 24),
              Expanded(child: secondaryCards[1]),
            ],
          ),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: primaryCards[0]),
              const SizedBox(width: 16),
              Expanded(child: primaryCards[1]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: secondaryCards[0]),
              const SizedBox(width: 16),
              Expanded(child: secondaryCards[1]),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        ...primaryCards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: card,
            )),
        ...secondaryCards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: card,
            )),
      ],
    );
  }
}

class _MetricEmphasisCard extends StatelessWidget {
  const _MetricEmphasisCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceM,
              vertical: DesignTokens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
            ),
            child: Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: DesignTokens.textSecondary(theme.brightness),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTileCard extends StatelessWidget {
  const _MetricTileCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: accent.darken(),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style:
                theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CriticalFocusStrip extends StatelessWidget {
  const _CriticalFocusStrip({
    required this.state,
    required this.isDesktop,
  });

  final DashboardState state;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final panels = [
      _FocusPanel(
        title: 'Priority alerts',
        subtitle: 'Claims breaching or at risk within SLA.',
        claims: state.overdueClaims,
        accent: Colors.redAccent,
        emptyTitle: 'No priority alerts',
        emptyDescription: 'Your pipelines are on track. Monitor queue to stay ahead.',
      ),
      _FocusPanel(
        title: 'Follow-ups needed',
        subtitle: 'Clients waiting on our contact.',
        claims: state.needsFollowUp,
        accent: Colors.orangeAccent,
        emptyTitle: 'All clients engaged',
        emptyDescription: 'No outstanding callbacks. Keep monitoring the queue.',
      ),
    ];

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: panels[0]),
          const SizedBox(width: 24),
          Expanded(child: panels[1]),
        ],
      );
    }

    return Column(
      children: [
        panels[0],
        const SizedBox(height: 24),
        panels[1],
      ],
    );
  }
}

class _FocusPanel extends StatelessWidget {
  const _FocusPanel({
    required this.title,
    required this.subtitle,
    required this.claims,
    required this.accent,
    required this.emptyTitle,
    required this.emptyDescription,
  });

  final String title;
  final String subtitle;
  final List<ClaimSummary> claims;
  final Color accent;
  final String emptyTitle;
  final String emptyDescription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showClaims = claims.take(4).toList();
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style:
                theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          if (showClaims.isEmpty)
            GlassEmptyState(
              icon: Icons.verified_outlined,
              title: emptyTitle,
              description: emptyDescription,
            )
          else
            Column(
              children: [
                for (final claim in showClaims) ...[
                  _FocusClaimTile(claim: claim, accent: accent),
                  if (claim != showClaims.last)
                    Divider(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                      height: 20,
                    ),
                ],
                if (claims.length > showClaims.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      '+${claims.length - showClaims.length} more in queue',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FocusClaimTile extends StatelessWidget {
  const _FocusClaimTile({
    required this.claim,
    required this.accent,
  });

  final ClaimSummary claim;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = claim.slaTarget - claim.elapsed;
    final breached = remaining.isNegative;
    final badgeColor = breached ? Colors.redAccent : Colors.amber;
    final badgeLabel = breached
        ? 'Breached by ${remaining.abs().inMinutes}m'
        : 'Due in ${remaining.inMinutes}m';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => GoRouter.of(context).push('/claims/${claim.claimId}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${claim.claimNumber} • ${claim.clientFullName}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${claim.insurerName} • ${claim.addressShort}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: badgeColor.darken(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  claim.priority.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineOverview extends StatelessWidget {
  const _PipelineOverview({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    // Main workflow stages (sequential flow)
    final mainStages = [
      ClaimStatus.newClaim,
      ClaimStatus.inContact,
      ClaimStatus.awaitingClient,
      ClaimStatus.scheduled,
      ClaimStatus.workInProgress,
    ];

    // Calculate activity indicators (claims added/changed in last hour)
    final activityCounts = <ClaimStatus, int>{};
    for (final claim in state.claims) {
      // Use slaStartedAt as proxy for when claim entered this status
      if (claim.slaStartedAt.isAfter(oneHourAgo)) {
        activityCounts.update(claim.status, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    // Calculate total for progress bars (using total active claims as capacity)
    final totalActive = state.totalActiveClaims;
    final maxCount = mainStages.map((s) => state.summaryCount(s)).fold(0, (a, b) => a > b ? a : b);

    final stages = mainStages.map((status) {
      final count = state.summaryCount(status);
      final activity = activityCounts[status];
      // Progress based on count relative to max (capped at 1.0)
      final progress = maxCount > 0 ? (count / maxCount).clamp(0.0, 1.0) : 0.0;

      return PipelineStage(
        label: _statusLabel(status).toUpperCase(),
        count: count,
        icon: _statusIcon(status),
        activityCount: activity,
        activityLabel: activity != null && activity > 0 ? 'this hour' : null,
        progress: progress,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pipeline status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: DesignTokens.spaceS),
            Text(
              'Live operational flow visualization',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spaceL),
        PipelineFlow(
          stages: stages,
          onStageTap: (index) {
            if (index >= 0 && index < mainStages.length) {
              final status = mainStages[index];
              context.pushNamed(
                'claims-queue',
                queryParameters: {'status': status.value},
              );
            }
          },
        ),
      ],
    );
  }

  IconData _statusIcon(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.newClaim:
        return Icons.add_circle_outline;
      case ClaimStatus.inContact:
        return Icons.phone_outlined;
      case ClaimStatus.awaitingClient:
        return Icons.schedule_outlined;
      case ClaimStatus.scheduled:
        return Icons.event_outlined;
      case ClaimStatus.workInProgress:
        return Icons.build_circle_outlined;
      case ClaimStatus.onHold:
        return Icons.pause_circle_outline;
      case ClaimStatus.closed:
        return Icons.verified_outlined;
      case ClaimStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}


class _LatestActivityTimeline extends StatelessWidget {
  const _LatestActivityTimeline({required this.claims});

  final List<ClaimSummary> claims;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Newest claim movements across the network.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          if (claims.isEmpty)
            const GlassEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No activity yet today',
              description:
                  'Queue updates and escalations will appear here as agents respond.',
            )
          else
            Column(
              children: [
                for (final claim in claims.take(6))
                  _TimelineTile(
                    claim: claim,
                    isLast: claim == claims.take(6).last,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.claim,
    required this.isLast,
  });

  final ClaimSummary claim;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timelineColor = theme.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: timelineColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: timelineColor.withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      claim.claimNumber,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      claim.clientFullName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${claim.insurerName} • ${claim.status.label}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).push('/claims/${claim.claimId}'),
          child: const Text('Open'),
        ),
      ],
    );
  }
}


String _statusLabel(ClaimStatus status) {
  switch (status) {
    case ClaimStatus.newClaim:
      return 'New';
    case ClaimStatus.inContact:
      return 'In contact';
    case ClaimStatus.awaitingClient:
      return 'Awaiting client';
    case ClaimStatus.scheduled:
      return 'Scheduled';
    case ClaimStatus.workInProgress:
      return 'In progress';
    case ClaimStatus.onHold:
      return 'On hold';
    case ClaimStatus.closed:
      return 'Closed';
    case ClaimStatus.cancelled:
      return 'Cancelled';
  }
}

extension _ColorShade on Color {
  Color darken([double amount = .15]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}


