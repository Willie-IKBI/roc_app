import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_empty_state.dart';
import '../../../../core/widgets/glass_error_state.dart';
import '../../../../domain/models/report_models.dart';
import '../../../../data/clients/supabase_client.dart';
import '../../../../data/repositories/reporting_repository_supabase.dart';
import '../../../../data/datasources/supabase_reporting_remote_data_source.dart';

final statusDistributionReportProvider =
    FutureProvider<List<StatusDistributionReport>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseReportingRemoteDataSource(client);
  final repository = ReportingRepositorySupabase(dataSource);
  final result = await repository.fetchStatusDistributionReport();
  if (result.isErr) {
    throw result.error;
  }
  return result.data;
});

class StatusDistributionReportWidget extends ConsumerWidget {
  const StatusDistributionReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(statusDistributionReportProvider);
    final theme = Theme.of(context);

    return reportAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return const GlassEmptyState(
            title: 'No status data',
            description: 'No claims found.',
            icon: Icons.timeline_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(statusDistributionReportProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              Text(
                'Status Distribution',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              GlassCard(
                padding: const EdgeInsets.all(DesignTokens.spaceM),
                margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Claims by Status',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    ...reports.map((report) => _StatusRow(report: report)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassErrorState(
        title: 'Error loading status distribution',
        message: error.toString(),
        onRetry: () => ref.refresh(statusDistributionReportProvider),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.report});

  final StatusDistributionReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusName = report.status.name.replaceAll('_', ' ').split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${report.count} (${(report.percentage * 100).toStringAsFixed(1)}%)',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: report.percentage,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
          if (report.averageTimeInStatusHours != null) ...[
            const SizedBox(height: 4),
            Text(
              'Avg time: ${(report.averageTimeInStatusHours! / 24).toStringAsFixed(1)} days',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (report.stuckClaims > 0) ...[
            const SizedBox(height: 4),
            Text(
              '⚠️ ${report.stuckClaims} claims stuck (>7 days)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

