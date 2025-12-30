import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../widgets/glass_card.dart';

/// A horizontal pipeline flow visualization showing sequential stages.
/// 
/// Displays stages connected by arrows with progress bars and activity indicators.
/// Matches the reference design with dark glass cards, icons, labels, counts,
/// progress bars, and red activity indicators.
/// 
/// Example:
/// ```dart
/// PipelineFlow(
///   stages: [
///     PipelineStage(
///       label: 'NEW CLAIMS',
///       count: 10,
///       icon: Icons.add_circle_outline,
///       activityCount: 2,
///       activityLabel: 'this hour',
///       progress: 0.6,
///     ),
///   ],
///   onStageTap: (index) => navigateToStage(index),
/// )
/// ```
class PipelineFlow extends StatelessWidget {
  const PipelineFlow({
    required this.stages,
    this.onStageTap,
    super.key,
  });

  /// Pipeline stages to display in sequence.
  final List<PipelineStage> stages;

  /// Callback when a stage is tapped.
  final ValueChanged<int>? onStageTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < stages.length; i++) ...[
            _PipelineStageCard(
              stage: stages[i],
              onTap: onStageTap != null ? () => onStageTap!(i) : null,
            ),
            if (i < stages.length - 1) _ArrowConnector(brightness: brightness),
          ],
        ],
      ),
    );
  }
}

class _PipelineStageCard extends StatelessWidget {
  const _PipelineStageCard({
    required this.stage,
    this.onTap,
  });

  final PipelineStage stage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Semantics(
      label: '${stage.label}: ${stage.count} claims',
      button: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
          child: GlassCard(
            padding: const EdgeInsets.all(DesignTokens.spaceL),
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon and label row
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: DesignTokens.primaryRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                        ),
                        child: Icon(
                          stage.icon,
                          color: DesignTokens.textPrimary(brightness),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spaceM),
                      Expanded(
                        child: Text(
                          stage.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: DesignTokens.textSecondary(brightness),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  // Count
                  Text(
                    '${stage.count}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: DesignTokens.textPrimary(brightness),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Activity indicator
                  if (stage.activityCount != null && stage.activityCount! > 0) ...[
                    const SizedBox(height: DesignTokens.spaceXS),
                    Text(
                      '+${stage.activityCount} ${stage.activityLabel ?? 'recent'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: DesignTokens.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: DesignTokens.spaceL),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      value: stage.progress,
                      backgroundColor: DesignTokens.borderSubtle(brightness),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        DesignTokens.textSecondary(brightness).withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowConnector extends StatelessWidget {
  const _ArrowConnector({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceS),
      child: Icon(
        Icons.arrow_forward,
        size: 24,
        color: DesignTokens.textTertiary(brightness),
      ),
    );
  }
}

/// A pipeline stage with all its data.
class PipelineStage {
  const PipelineStage({
    required this.label,
    required this.count,
    required this.icon,
    this.activityCount,
    this.activityLabel,
    this.progress = 0.0,
  });

  /// Stage label (e.g., "NEW CLAIMS").
  final String label;

  /// Number of items in this stage.
  final int count;

  /// Icon for this stage.
  final IconData icon;

  /// Number of recent items added (for activity indicator).
  final int? activityCount;

  /// Label for activity indicator (e.g., "this hour", "today").
  final String? activityLabel;

  /// Progress value (0.0 to 1.0) for the progress bar.
  final double progress;
}

