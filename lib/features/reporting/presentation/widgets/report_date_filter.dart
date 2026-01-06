import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../controller/reporting_controller.dart';
import '../../domain/reporting_state.dart';
import 'date_range_picker_dialog.dart' show CustomDateRangePickerDialog;

class ReportDateFilter extends ConsumerWidget {
  const ReportDateFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customDateRange = ref.watch(customDateRangeControllerProvider);
    final selectedWindow = ref.watch(reportingWindowControllerProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<ReportingWindow>(
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
          selected: customDateRange == null
              ? <ReportingWindow>{selectedWindow}
              : <ReportingWindow>{},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              // Clear custom date range when selecting a preset
              ref.read(customDateRangeControllerProvider.notifier).clear();
              ref.read(reportingWindowControllerProvider.notifier)
                  .setWindow(selection.first);
            }
          },
        ),
        if (customDateRange != null) ...[
          const SizedBox(height: DesignTokens.spaceM),
          InkWell(
            onTap: () async {
              final result = await showDialog<({DateTime startDate, DateTime endDate})>(
                context: context,
                builder: (context) => CustomDateRangePickerDialog(
                  initialStartDate: customDateRange.startDate,
                  initialEndDate: customDateRange.endDate,
                ),
              );
              if (result != null) {
                ref.read(customDateRangeControllerProvider.notifier).setDateRange(
                  result.startDate,
                  result.endDate,
                );
              }
            },
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: Container(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Range',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dateFormat.format(customDateRange.startDate)} - ${dateFormat.format(customDateRange.endDate)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.edit_calendar,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: DesignTokens.spaceM),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await showDialog<({DateTime startDate, DateTime endDate})>(
                context: context,
                builder: (context) => const CustomDateRangePickerDialog(),
              );
              if (result != null) {
                ref.read(customDateRangeControllerProvider.notifier).setDateRange(
                  result.startDate,
                  result.endDate,
                );
              }
            },
            icon: const Icon(Icons.date_range),
            label: const Text('Custom Range'),
          ),
        ],
      ],
    );
  }
}

