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

final geographicReportProvider = FutureProvider.family<List<GeographicReport>, String?>((ref, groupBy) async {
  // Get date range from reporting window
  final window = ref.watch(reportingWindowControllerProvider);
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  final startDate = today.subtract(Duration(days: window.days - 1));
  final endDate = today.add(const Duration(days: 1));

  // Use repository provider (no direct Supabase calls)
  final repository = ref.watch(reportingRepositoryProvider);
  final result = await repository.fetchGeographicReportPage(
    startDate: startDate,
    endDate: endDate,
    groupBy: groupBy,
    limit: 100, // First page only for now
  );
  if (result.isErr) {
    throw result.error;
  }
  return result.data.items; // Return items from paginated result
});

class GeographicReportWidget extends ConsumerStatefulWidget {
  const GeographicReportWidget({super.key});

  @override
  ConsumerState<GeographicReportWidget> createState() => _GeographicReportWidgetState();
}

class _GeographicReportWidgetState extends ConsumerState<GeographicReportWidget> {
  String _groupBy = 'province';

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(geographicReportProvider(_groupBy));
    final theme = Theme.of(context);

    return reportAsync.when(
      data: (reports) {
        if (reports.isEmpty) {
          return const GlassEmptyState(
            title: 'No geographic data',
            description: 'No claims with address data found.',
            icon: Icons.map_outlined,
          );
        }

        // Sort by count descending
        final sorted = [...reports]..sort((a, b) => b.claimCount.compareTo(a.claimCount));

        return RefreshIndicator(
          onRefresh: () => ref.refresh(geographicReportProvider(_groupBy).future),
          child: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            children: [
              Text(
                'Geographic Distribution',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
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
              GlassCard(
                padding: const EdgeInsets.all(DesignTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Claims by ${_groupBy[0].toUpperCase()}${_groupBy.substring(1)}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: DesignTokens.spaceM),
                    ...sorted.take(20).map((report) => _GeographicRow(report: report)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => GlassErrorState(
        title: 'Error loading geographic report',
        message: error.toString(),
        onRetry: () => ref.refresh(geographicReportProvider(_groupBy)),
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

