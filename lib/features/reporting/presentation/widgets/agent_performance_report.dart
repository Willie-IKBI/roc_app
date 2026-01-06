import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_empty_state.dart';
import '../../../../core/widgets/glass_error_state.dart';
import '../../../../domain/models/report_models.dart';
import '../../controller/paginated_report_controller.dart';
import '../../domain/paginated_report_state.dart';
import 'report_date_filter.dart';

class AgentPerformanceReportWidget extends ConsumerStatefulWidget {
  const AgentPerformanceReportWidget({super.key});

  @override
  ConsumerState<AgentPerformanceReportWidget> createState() => _AgentPerformanceReportWidgetState();
}

class _AgentPerformanceReportWidgetState extends ConsumerState<AgentPerformanceReportWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Defer state changes to avoid issues during pointer events
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final asyncState = ref.read(agentPerformanceReportControllerProvider);
        if (!asyncState.hasValue) return;
        final state = asyncState.value!;
        if (!state.hasMore || state.isLoadingMore) return;
        ref.read(agentPerformanceReportControllerProvider.notifier).loadMore();
      });
    }
  }

  int _calculateItemCount(PaginatedReportState<AgentPerformanceReport>? state) {
    if (state == null) return 3; // Date filter + Title + Loading
    int count = 2; // Date filter + Title
    if (state.isLoading && state.items.isEmpty) return count + 1; // Loading
    if (state.error != null && state.items.isEmpty) return count + 1; // Error
    if (state.items.isEmpty) return count + 1; // Empty
    // When items exist, they start at index 2 (no skip slot needed)
    count += state.items.length; // Report items
    if (state.hasMore) count += 1; // Load more button/indicator
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(agentPerformanceReportControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(agentPerformanceReportControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => controller.refresh(),
      child: asyncState.when(
        data: (state) => ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          itemCount: _calculateItemCount(state),
          itemBuilder: (context, index) {
          // Bounds check - should never happen if itemCount is correct
          final itemCount = _calculateItemCount(state);
          if (index < 0 || index >= itemCount) {
            return const SizedBox(height: 1);
          }
          
          // Index 0: Date Filter
          if (index == 0) {
            return GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: const ReportDateFilter(),
            );
          }
          
          // Index 1: Title
          if (index == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agent Performance',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
              ],
            );
          }
          
          // Index 2: Loading/Error/Empty states OR first report item
          if (index == 2) {
            if (state.isLoading && state.items.isEmpty) {
              return const SizedBox(
                height: 400,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(DesignTokens.spaceL),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            if (state.error != null && state.items.isEmpty) {
              return SizedBox(
                height: 400,
                child: GlassErrorState(
                  title: 'Error loading agent performance',
                  message: state.error.toString(),
                  onRetry: () => controller.refresh(),
                ),
              );
            }
            if (state.items.isEmpty) {
              return const SizedBox(
                height: 400,
                child: GlassEmptyState(
                  title: 'No agent performance data',
                  description: 'No agents have handled claims in the selected date range.\nTry selecting a different date range.',
                  icon: Icons.people_outlined,
                ),
              );
            }
            // If we have items, this IS the first item (index 2 = item 0)
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: _AgentPerformanceCard(report: state.items[0]),
            );
          }
          
          // Index 3+: Remaining report items or Load more
          final itemIndex = index - 2;
          
          // Check if this is a report item
          if (itemIndex < state.items.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: _AgentPerformanceCard(report: state.items[itemIndex]),
            );
          }
          
          // If we have more items to load, show load more button/indicator
          if (state.hasMore && itemIndex == state.items.length) {
            if (state.isLoadingMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spaceM),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceM),
                child: OutlinedButton.icon(
                  onPressed: () => controller.loadMore(),
                  icon: const Icon(Icons.expand_more),
                  label: const Text('Load More'),
                ),
              ),
            );
          }
          
          // Fallback: return empty container (should never reach here)
          return const SizedBox(height: 1);
        },
      ),
        loading: () => ListView(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: const ReportDateFilter(),
            ),
            const SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
        error: (error, stack) => ListView(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: const ReportDateFilter(),
            ),
            SizedBox(
              height: 400,
              child: GlassErrorState(
                title: 'Error loading agent performance',
                message: error.toString(),
                onRetry: () => controller.refresh(),
              ),
            ),
          ],
        ),
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

