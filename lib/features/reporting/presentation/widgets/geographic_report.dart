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

class GeographicReportWidget extends ConsumerStatefulWidget {
  const GeographicReportWidget({super.key});

  @override
  ConsumerState<GeographicReportWidget> createState() => _GeographicReportWidgetState();
}

class _GeographicReportWidgetState extends ConsumerState<GeographicReportWidget> {
  String _groupBy = 'province';
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
        final asyncState = ref.read(geographicReportControllerProvider(_groupBy));
        if (!asyncState.hasValue) return;
        final state = asyncState.value!;
        if (!state.hasMore || state.isLoadingMore) return;
        ref.read(geographicReportControllerProvider(_groupBy).notifier).loadMore();
      });
    }
  }

  int _calculateItemCount(PaginatedReportState<GeographicReport>? state) {
    if (state == null) return 4; // Date filter + Title + GroupBy + Loading
    int count = 3; // Date filter + Title + GroupBy selector
    if (state.isLoading && state.items.isEmpty) return count + 1; // Loading
    if (state.error != null && state.items.isEmpty) return count + 1; // Error
    if (state.items.isEmpty) return count + 1; // Empty
    count += 1; // Geographic card container
    if (state.hasMore) count += 1; // Load more button/indicator
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(geographicReportControllerProvider(_groupBy));
    final theme = Theme.of(context);
    final controller = ref.read(geographicReportControllerProvider(_groupBy).notifier);

    return RefreshIndicator(
      onRefresh: () => controller.refresh(),
      child: asyncState.when(
        data: (state) {
          // Sort by count descending
          final sorted = state.items.isEmpty
              ? <GeographicReport>[]
              : <GeographicReport>[...state.items]..sort((a, b) => b.claimCount.compareTo(a.claimCount));

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
                  'Geographic Distribution',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
              ],
            );
          }
          
          // Index 2: GroupBy selector
          if (index == 2) {
            return GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'province', label: Text('Province')),
                  ButtonSegment(value: 'city', label: Text('City')),
                  ButtonSegment(value: 'suburb', label: Text('Suburb')),
                ],
                selected: {_groupBy},
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) {
                    setState(() => _groupBy = selection.first);
                  }
                },
              ),
            );
          }
          
          // Index 3: Loading/Error/Empty states
          if (index == 3) {
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
                  title: 'Error loading geographic report',
                  message: state.error.toString(),
                  onRetry: () => controller.refresh(),
                ),
              );
            }
            if (state.items.isEmpty) {
              return const SizedBox(
                height: 400,
                child: GlassEmptyState(
                  title: 'No geographic data',
                  description: 'No claims with address data found for the selected date range.\nTry selecting a different date range.',
                  icon: Icons.map_outlined,
                ),
              );
            }
            // If we have items, show the geographic card
            return GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claims by ${_groupBy[0].toUpperCase()}${_groupBy.substring(1)}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  ...sorted.map((report) => _GeographicRow(report: report)),
                ],
              ),
            );
          }
          
          // Index 4: Load more (only if hasMore is true)
          if (index == 4 && state.hasMore) {
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
            GlassCard(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              margin: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'province', label: Text('Province')),
                  ButtonSegment(value: 'city', label: Text('City')),
                  ButtonSegment(value: 'suburb', label: Text('Suburb')),
                ],
                selected: {_groupBy},
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) {
                    setState(() => _groupBy = selection.first);
                  }
                },
              ),
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
                title: 'Error loading geographic report',
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

class _GeographicRow extends StatelessWidget {
  const _GeographicRow({required this.report});

  final GeographicReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String locationName;
    if (report.suburb != null && report.suburb!.isNotEmpty) {
      locationName = report.suburb!;
      if (report.city != null) locationName += ', ${report.city}';
      if (report.province != null) locationName += ', ${report.province}';
    } else if (report.city != null && report.city!.isNotEmpty) {
      locationName = report.city!;
      if (report.province != null) locationName += ', ${report.province}';
    } else if (report.province != null && report.province!.isNotEmpty) {
      locationName = report.province!;
    } else {
      locationName = 'Unknown';
    }

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
                  locationName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${report.claimCount} (${(report.percentage * 100).toStringAsFixed(1)}%)',
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
        ],
      ),
    );
  }
}

