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

class DamageCauseReportWidget extends ConsumerStatefulWidget {
  const DamageCauseReportWidget({super.key});

  @override
  ConsumerState<DamageCauseReportWidget> createState() => _DamageCauseReportWidgetState();
}

class _DamageCauseReportWidgetState extends ConsumerState<DamageCauseReportWidget> {
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
        final asyncState = ref.read(damageCauseReportControllerProvider);
        if (!asyncState.hasValue) return;
        final state = asyncState.value!;
        if (!state.hasMore || state.isLoadingMore) return;
        ref.read(damageCauseReportControllerProvider.notifier).loadMore();
      });
    }
  }

  int _calculateItemCount(PaginatedReportState<DamageCauseReport>? state) {
    if (state == null) return 3; // Date filter + Title + Loading
    int count = 2; // Date filter + Title
    if (state.isLoading && state.items.isEmpty) return count + 1; // Loading
    if (state.error != null && state.items.isEmpty) return count + 1; // Error
    if (state.items.isEmpty) return count + 1; // Empty
    count += 1; // Damage cause card container
    if (state.hasMore) count += 1; // Load more button/indicator
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(damageCauseReportControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(damageCauseReportControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => controller.refresh(),
      child: asyncState.when(
        data: (state) {
          // Sort by count descending
          final sorted = state.items.isEmpty
              ? <DamageCauseReport>[]
              : <DamageCauseReport>[...state.items]..sort((a, b) => b.count.compareTo(a.count));

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
                  'Damage Cause Analysis',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
              ],
            );
          }
          
          // Index 2: Loading/Error/Empty states
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
                  title: 'Error loading damage cause report',
                  message: state.error.toString(),
                  onRetry: () => controller.refresh(),
                ),
              );
            }
            if (state.items.isEmpty) {
              return const SizedBox(
                height: 400,
                child: GlassEmptyState(
                  title: 'No damage cause data',
                  description: 'No claims found for the selected date range.\nTry selecting a different date range.',
                  icon: Icons.build_outlined,
                ),
              );
            }
            // If we have items, show the damage cause card
            return GlassCard(
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
            );
          }
          
          // Index 3: Load more (only if hasMore is true)
          if (index == 3 && state.hasMore) {
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
                title: 'Error loading damage cause report',
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

