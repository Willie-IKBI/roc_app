import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_empty_state.dart';
import '../../../../core/widgets/glass_error_state.dart';
import '../../../../domain/models/report_models.dart';
import '../../../../data/repositories/reporting_repository_supabase.dart';
import '../../controller/reporting_controller.dart';
import '../../domain/reporting_state.dart';

final damageCauseReportProvider = FutureProvider<List<DamageCauseReport>>((ref) async {
  // Get date range from reporting window
  final window = ref.watch(reportingWindowControllerProvider);
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  final startDate = today.subtract(Duration(days: window.days - 1));
  final endDate = today.add(const Duration(days: 1));

  // Use repository provider (no direct Supabase calls)
  final repository = ref.watch(reportingRepositoryProvider);
  final result = await repository.fetchDamageCauseReportPage(
    startDate: startDate,
    endDate: endDate,
    limit: 100, // First page only for now
  );
  if (result.isErr) {
    throw result.error;
  }
  return result.data.items; // Return items from paginated result
});

class DamageCauseReportWidget extends ConsumerWidget {
  const DamageCauseReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(damageCauseReportProvider);
    final theme = Theme.of(context);

    return reportAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return const GlassEmptyState(
            title: 'No damage cause data',
            description: 'No claims found.',
            icon: Icons.build_outlined,
          );
        }

        // Sort by count descending
        final sorted = [...reports]..sort((a, b) => b.count.compareTo(a.count));

        return RefreshIndicator(
          onRefresh: () => ref.refresh(damageCauseReportProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              Text(
                'Damage Cause Analysis',
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
                      'Top Damage Causes',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    ...sorted.map((report) => _DamageCauseRow(report: report)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassErrorState(
        title: 'Error loading damage cause report',
        message: error.toString(),
        onRetry: () => ref.refresh(damageCauseReportProvider),
      ),
    );
  }
}

class _DamageCauseRow extends StatelessWidget {
  const _DamageCauseRow({required this.report});

  final DamageCauseReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final causeName = report.cause.name.replaceAll('_', ' ').split(' ')
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
              Expanded(
                child: Text(
                  causeName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
          if (report.averageResolutionTimeHours != null) ...[
            const SizedBox(height: 4),
            Text(
              'Avg resolution: ${(report.averageResolutionTimeHours! / 24).toStringAsFixed(1)} days',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

