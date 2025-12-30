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

final agentPerformanceReportProvider = FutureProvider<List<AgentPerformanceReport>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = SupabaseReportingRemoteDataSource(client);
  final repository = ReportingRepositorySupabase(dataSource);
  final result = await repository.fetchAgentPerformanceReport();
  if (result.isErr) {
    throw result.error;
  }
  return result.data;
});

class AgentPerformanceReportWidget extends ConsumerWidget {
  const AgentPerformanceReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(agentPerformanceReportProvider);
    final theme = Theme.of(context);

    return reportAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return const GlassEmptyState(
            title: 'No agent performance data',
            description: 'No agents have handled claims yet.',
            icon: Icons.people_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(agentPerformanceReportProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              Text(
                'Agent Performance',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              ...reports.map((report) => _AgentPerformanceCard(report: report)),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassErrorState(
        title: 'Error loading agent performance',
        message: error.toString(),
        onRetry: () => ref.refresh(agentPerformanceReportProvider),
      ),
    );
  }
}

class _AgentPerformanceCard extends StatelessWidget {
  const _AgentPerformanceCard({required this.report});

  final AgentPerformanceReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.agentName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          Wrap(
            spacing: DesignTokens.spaceL,
            runSpacing: DesignTokens.spaceM,
            children: [
              _Metric(
                icon: Icons.assignment_outlined,
                label: 'Claims Handled',
                value: report.claimsHandled.toString(),
              ),
              _Metric(
                icon: Icons.check_circle_outline,
                label: 'Claims Closed',
                value: report.claimsClosed.toString(),
              ),
              _Metric(
                icon: Icons.timer_outlined,
                label: 'Avg First Contact',
                value: report.averageMinutesToFirstContact != null
                    ? '${report.averageMinutesToFirstContact!.toStringAsFixed(1)} min'
                    : '--',
              ),
              _Metric(
                icon: Icons.task_alt_outlined,
                label: 'SLA Compliance',
                value: '${(report.slaComplianceRate * 100).toStringAsFixed(1)}%',
              ),
              _Metric(
                icon: Icons.access_time_outlined,
                label: 'Avg Resolution',
                value: report.averageResolutionTimeMinutes != null
                    ? '${(report.averageResolutionTimeMinutes! / 60).toStringAsFixed(1)} hrs'
                    : '--',
              ),
              _Metric(
                icon: Icons.phone_callback_outlined,
                label: 'Contact Success',
                value: '${(report.contactSuccessRate * 100).toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
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

