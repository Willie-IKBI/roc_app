import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/roc_color_scheme.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/models/daily_claim_report.dart';
import '../controller/reporting_controller.dart';
import '../domain/reporting_state.dart';
import 'widgets/report_tabs.dart';
import 'widgets/agent_performance_report.dart';
import 'widgets/status_distribution_report.dart';
import 'widgets/damage_cause_report.dart';
import 'widgets/geographic_report.dart';
import 'widgets/insurer_performance_report.dart';

class ReportingScreen extends ConsumerStatefulWidget {
  const ReportingScreen({super.key});

  @override
  ConsumerState<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends ConsumerState<ReportingScreen> {
  ReportTab _selectedTab = ReportTab.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporting'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _TabBar(
            selectedTab: _selectedTab,
            onTabSelected: (tab) => setState(() => _selectedTab = tab),
          ),
        ),
      ),
      body: SafeArea(
        child: _buildTabContent(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case ReportTab.overview:
        return _buildOverviewTab();
      case ReportTab.agentPerformance:
        return const AgentPerformanceReportWidget();
      case ReportTab.statusDistribution:
        return const StatusDistributionReportWidget();
      case ReportTab.damageCause:
        return const DamageCauseReportWidget();
      case ReportTab.geographic:
        return const GeographicReportWidget();
      case ReportTab.insurerPerformance:
        return const InsurerPerformanceReportWidget();
    }
  }

  Widget _buildOverviewTab() {
    final reportAsync = ref.watch(reportingControllerProvider);

    return reportAsync.when(
      data: (data) {
        final reports = data.reports;
        if (reports.isEmpty) {
          return const _EmptyReportingState();
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(reportingControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(DesignTokens.spaceM),
                child: _WindowSelector(
                  selected: data.window,
                  onChanged: (window) => ref
                      .read(reportingControllerProvider.notifier)
                      .changeWindow(window),
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              _SummaryCards(
                totalClaims: data.totalClaims,
                averageMinutes: data.averageMinutesToFirstContact,
                complianceRate: data.complianceRate,
                window: data.window,
              ),
              const SizedBox(height: DesignTokens.spaceL),
              _DailyTrendChart(
                reports: reports,
                window: data.window,
              ),
              const SizedBox(height: DesignTokens.spaceL),
              Text(
                'Daily performance',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              for (final report in reports)
                Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                  child: _DailyReportCard(report: report),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorReportState(
        message: error.toString(),
        onRetry: () =>
            ref.read(reportingControllerProvider.notifier).refresh(),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final ReportTab selectedTab;
  final ValueChanged<ReportTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceM),
      child: Row(
        children: ReportTab.values.map((tab) {
          final isSelected = tab == selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: DesignTokens.spaceS),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.icon, size: 18),
                  const SizedBox(width: 8),
                  Text(tab.label),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => onTabSelected(tab),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WindowSelector extends StatelessWidget {
  const _WindowSelector({
    required this.selected,
    required this.onChanged,
  });

  final ReportingWindow selected;
  final ValueChanged<ReportingWindow> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ReportingWindow>(
      segments: [
        ButtonSegment(
          value: ReportingWindow.last7,
          label: const Text('7d'),
          icon: const Icon(Icons.calendar_view_week),
        ),
        ButtonSegment(
          value: ReportingWindow.last14,
          label: const Text('14d'),
          icon: const Icon(Icons.calendar_view_week_outlined),
        ),
        ButtonSegment(
          value: ReportingWindow.last30,
          label: const Text('30d'),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ],
      selected: <ReportingWindow>{selected},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({
    required this.totalClaims,
    required this.averageMinutes,
    required this.complianceRate,
    required this.window,
  });

  final int totalClaims;
  final double? averageMinutes;
  final double complianceRate;
  final ReportingWindow window;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatAverage() {
      if (averageMinutes == null) return '--';
      return '${averageMinutes!.toStringAsFixed(1)} min';
    }

    String formatCompliance() {
      final percent = (complianceRate * 100).clamp(0, 100);
      return '${percent.toStringAsFixed(1)}%';
    }

    final children = <Widget>[
      _SummaryTile(
        icon: Icons.playlist_add_check_circle_outlined,
        label: 'Claims captured',
        value: totalClaims.toString(),
        color: theme.colorScheme.primary,
      ),
      _SummaryTile(
        icon: Icons.timer_outlined,
        label: 'Avg first contact',
        value: formatAverage(),
        color: theme.colorScheme.tertiary,
      ),
      _SummaryTile(
        icon: Icons.task_alt_outlined,
        label: 'SLA compliance',
        value: formatCompliance(),
        color: theme.colorScheme.secondary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          window.label,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 720;
            if (isWide) {
              return Row(
                children: [
                  for (var i = 0; i < children.length; i++)
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: i == children.length - 1 ? 0 : 12),
                        child: children[i],
                      ),
                    ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final child in children)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
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
      backgroundColor: color.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
    );
  }
}

class _DailyTrendChart extends StatelessWidget {
  const _DailyTrendChart({
    required this.reports,
    required this.window,
  });

  final List<DailyClaimReport> reports;
  final ReportingWindow window;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final formatter = DateFormat.MMMd();
    final sorted = [...reports]..sort((a, b) => a.date.compareTo(b.date));
    final targetCount = window.days;
    final visible = sorted.length > targetCount
        ? sorted.sublist(sorted.length - targetCount)
        : sorted;
    final maxClaims = visible.fold<int>(
      1,
      (max, report) => report.claimsCaptured > max ? report.claimsCaptured : max,
    );

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Claims captured trend',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Daily volumes over ${window.label.toLowerCase()}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final report in visible)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: maxClaims == 0
                                      ? 0
                                      : (report.claimsCaptured / maxClaims)
                                          .clamp(0, 1)
                                          .toDouble(),
                                  child: Tooltip(
                                    message:
                                        '${formatter.format(report.date)} · ${report.claimsCaptured} claims',
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.primary
                                                .withValues(alpha: 0.4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              report.claimsCaptured.toString(),
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatter.format(report.date),
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _DailyReportCard extends StatelessWidget {
  const _DailyReportCard({required this.report});

  final DailyClaimReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = report.date;
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final complianceRate = report.complianceRate;
    final compliancePercent = (complianceRate * 100).clamp(0, 100);
    final avgMinutes = report.averageMinutesToFirstContact;

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Chip(
                  avatar: const Icon(Icons.task_alt_outlined, size: 18),
                  label: Text('${compliancePercent.toStringAsFixed(1)}% SLA'),
                  backgroundColor: complianceRate >= 0.8
                      ? RocSemanticColors.success.withValues(alpha: 0.18)
                      : RocSemanticColors.warning.withValues(alpha: 0.18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _ReportMetric(
                  icon: Icons.playlist_add_check_outlined,
                  label: 'Claims captured',
                  value: report.claimsCaptured.toString(),
                ),
                _ReportMetric(
                  icon: Icons.support_agent,
                  label: 'Contacted',
                  value:
                      '${report.contactedClaims} (${_formatRate(report.contactedClaims, report.claimsCaptured)})',
                ),
                _ReportMetric(
                  icon: Icons.timer_outlined,
                  label: 'Avg first contact',
                  value: avgMinutes == null
                      ? '--'
                      : '${avgMinutes.toStringAsFixed(1)} min',
                ),
              ],
            ),
          ],
        ),
    );
  }

  String _formatRate(int numerator, int denominator) {
    if (denominator == 0) return '0%';
    final percent = (numerator / denominator) * 100;
    return '${percent.toStringAsFixed(0)}%';
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            Text(
              value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyReportingState extends StatelessWidget {
  const _EmptyReportingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.equalizer_outlined,
                size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'No reporting data yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Once claims start flowing, you\'ll see daily insights here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorReportState extends StatelessWidget {
  const _ErrorReportState({required this.message, required this.onRetry});

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
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load reporting data',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            GlassButton.primary(
              onPressed: onRetry,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: DesignTokens.spaceS),
                  Text('Retry'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


