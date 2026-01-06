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

class InsurerPerformanceReportWidget extends ConsumerStatefulWidget {
  const InsurerPerformanceReportWidget({super.key});

  @override
  ConsumerState<InsurerPerformanceReportWidget> createState() => _InsurerPerformanceReportWidgetState();
}

class _InsurerPerformanceReportWidgetState extends ConsumerState<InsurerPerformanceReportWidget> {
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
        final asyncState = ref.read(insurerPerformanceReportControllerProvider);
        if (!asyncState.hasValue) return;
        final state = asyncState.value!;
        if (!state.hasMore || state.isLoadingMore) return;
        ref.read(insurerPerformanceReportControllerProvider.notifier).loadMore();
      });
    }
  }

  int _calculateItemCount(PaginatedReportState<InsurerPerformanceReport>? state) {
    if (state == null) return 3; // Date filter + Title + Loading
    int count = 2; // Date filter + Title
    if (state.isLoading && state.items.isEmpty) return count + 1; // Loading
    if (state.error != null && state.items.isEmpty) return count + 1; // Error
    if (state.items.isEmpty) return count + 1; // Empty
    
    // Filter out insurers with 0 claims
    final filtered = state.items.where((r) => r.totalClaims > 0).toList();
    if (filtered.isEmpty) return count + 1; // Empty after filtering
    // When items exist, they start at index 2 (no skip slot needed)
    count += filtered.length; // Report items
    if (state.hasMore) count += 1; // Load more button/indicator
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(insurerPerformanceReportControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(insurerPerformanceReportControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => controller.refresh(),
      child: asyncState.when(
        data: (state) {
          // Filter out insurers with 0 claims and sort by total claims
          final filtered = state.items
              .where((r) => r.totalClaims > 0)
              .toList()
            ..sort((a, b) => b.totalClaims.compareTo(a.totalClaims));

          return ListView.builder(
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
                  'Insurer Performance',
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
                  title: 'Error loading insurer performance',
                  message: state.error.toString(),
                  onRetry: () => controller.refresh(),
                ),
              );
            }
            if (state.items.isEmpty || filtered.isEmpty) {
              return const SizedBox(
                height: 400,
                child: GlassEmptyState(
                  title: 'No insurer data',
                  description: 'No insurers with claims found for the selected date range.\nTry selecting a different date range.',
                  icon: Icons.business_outlined,
                ),
              );
            }
            // If we have items, this IS the first item (index 2 = item 0)
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: _InsurerCard(report: filtered[0]),
            );
          }
          
          // Index 3+: Remaining report items or Load more
          final itemIndex = index - 2;
          
          // Check if this is a report item
          if (itemIndex < filtered.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: _InsurerCard(report: filtered[itemIndex]),
            );
          }
          
          // If we have more items to load, show load more button/indicator
          if (state.hasMore && itemIndex == filtered.length) {
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
      );
        },
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
                title: 'Error loading insurer performance',
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
      return const SizedBox(height: 0);
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
      return const SizedBox(height: 0);
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

