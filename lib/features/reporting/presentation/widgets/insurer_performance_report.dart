import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_empty_state.dart';
import '../../../../core/widgets/glass_error_state.dart';
import '../../../../domain/models/report_models.dart';
import '../../../../domain/repositories/reporting_repository.dart';
import '../../../../data/clients/supabase_client.dart';
import '../../../../data/repositories/reporting_repository_supabase.dart';
import '../../../../data/datasources/supabase_reporting_remote_data_source.dart';
import '../../../../domain/value_objects/claim_enums.dart';

final insurerPerformanceReportProvider =
    FutureProvider<List<InsurerPerformanceReport>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseReportingRemoteDataSource(client);
  final repository = ReportingRepositorySupabase(dataSource);
  final result = await repository.fetchInsurerPerformanceReport();
  if (result.isErr) {
    throw result.error;
  }
  return result.data;
});

class InsurerPerformanceReportWidget extends ConsumerWidget {
  const InsurerPerformanceReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(insurerPerformanceReportProvider);
    final theme = Theme.of(context);

    return reportAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return const GlassEmptyState(
            title: 'No insurer data',
            description: 'No insurers with claims found.',
            icon: Icons.business_outlined,
          );
        }

        // Filter out insurers with 0 claims and sort by total claims
        final filtered = reports.where((r) => r.totalClaims > 0).toList()
          ..sort((a, b) => b.totalClaims.compareTo(a.totalClaims));

        return RefreshIndicator(
          onRefresh: () => ref.refresh(insurerPerformanceReportProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              Text(
                'Insurer Performance',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              ...filtered.map((report) => _InsurerCard(report: report)),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassErrorState(
        title: 'Error loading insurer performance',
        message: error.toString(),
        onRetry: () => ref.refresh(insurerPerformanceReportProvider),
      ),
    );
  }
}

class _InsurerCard extends StatefulWidget {
  const _InsurerCard({required this.report});

  final InsurerPerformanceReport report;

  @override
  State<_InsurerCard> createState() => _InsurerCardState();
}

class _InsurerCardState extends State<_InsurerCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final report = widget.report;

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spaceS),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.insurerName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spaceS),
                        Wrap(
                          spacing: DesignTokens.spaceL,
                          runSpacing: DesignTokens.spaceM,
                          children: [
                            _Metric(
                              icon: Icons.assignment_outlined,
                              label: 'Total Claims',
                              value: report.totalClaims.toString(),
                            ),
                            _Metric(
                              icon: Icons.check_circle_outline,
                              label: 'Closed',
                              value: report.closedClaims.toString(),
                            ),
                            _Metric(
                              icon: Icons.schedule_outlined,
                              label: 'Scheduled',
                              value: report.scheduledClaims.toString(),
                            ),
                            _Metric(
                              icon: Icons.access_time_outlined,
                              label: 'Avg Resolution',
                              value: report.averageResolutionTimeHours != null
                                  ? '${(report.averageResolutionTimeHours! / 24).toStringAsFixed(1)} days'
                                  : '--',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: DesignTokens.spaceL),
            _StatusBreakdown(
              statusBreakdown: report.statusBreakdown,
              totalClaims: report.totalClaims,
            ),
            const SizedBox(height: DesignTokens.spaceM),
            _DamageCauseBreakdown(
              damageCauseBreakdown: report.damageCauseBreakdown,
              totalClaims: report.totalClaims,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBreakdown extends StatelessWidget {
  const _StatusBreakdown({
    required this.statusBreakdown,
    required this.totalClaims,
  });

  final List<InsurerStatusBreakdown> statusBreakdown;
  final int totalClaims;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (statusBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = [...statusBreakdown]..sort((a, b) => b.claimCount.compareTo(a.claimCount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Distribution',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        ...sorted.map((breakdown) {
          final statusName = breakdown.status.name.replaceAll('_', ' ').split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      statusName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${breakdown.claimCount} (${(breakdown.percentage * 100).toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: breakdown.percentage,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _DamageCauseBreakdown extends StatelessWidget {
  const _DamageCauseBreakdown({
    required this.damageCauseBreakdown,
    required this.totalClaims,
  });

  final List<InsurerDamageCauseBreakdown> damageCauseBreakdown;
  final int totalClaims;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (damageCauseBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = [...damageCauseBreakdown]..sort((a, b) => b.claimCount.compareTo(a.claimCount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Claim Types (Damage Causes)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        ...sorted.map((breakdown) {
          final causeName = breakdown.damageCause.name.replaceAll('_', ' ').split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        causeName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${breakdown.claimCount} (${(breakdown.percentage * 100).toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: breakdown.percentage,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

