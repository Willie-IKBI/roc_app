import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../controller/sla_rules_controller.dart';

/// SLA Rules management screen with glassmorphism styling.
/// 
/// Allows admins to configure service level agreement rules,
/// including time to first contact and breach highlighting.
class SlaRulesScreen extends ConsumerStatefulWidget {
  const SlaRulesScreen({super.key});

  @override
  ConsumerState<SlaRulesScreen> createState() => _SlaRulesScreenState();
}

class _SlaRulesScreenState extends ConsumerState<SlaRulesScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _minutesController;
  bool _breachHighlight = true;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController();
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slaAsync = ref.watch(slaRulesControllerProvider);
    final theme = Theme.of(context);

    // Listen to SLA rule changes and update form
    ref.listen(slaRulesControllerProvider, (previous, next) {
      next.whenData((rule) {
        if (!mounted) return;
        setState(() {
          _minutesController.text = rule.timeToFirstContactMinutes.toString();
          _breachHighlight = rule.breachHighlight;
        });
      });
    });

    return Scaffold(
      body: SafeArea(
        child: slaAsync.when(
          data: (rule) {
            // Initialize form if empty
            if (_minutesController.text.isEmpty) {
              _minutesController.text = rule.timeToFirstContactMinutes.toString();
              _breachHighlight = rule.breachHighlight;
            }
            return _SlaRulesContent(
              formKey: _formKey,
              minutesController: _minutesController,
              breachHighlight: _breachHighlight,
              onBreachHighlightChanged: (value) =>
                  setState(() => _breachHighlight = value),
              isLoading: slaAsync.isLoading,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorState(
            message: getUserFriendlyErrorMessage(error, isDebugMode: kDebugMode),
            onRetry: () =>
                ref.read(slaRulesControllerProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _SlaRulesContent extends ConsumerWidget {
  const _SlaRulesContent({
    required this.formKey,
    required this.minutesController,
    required this.breachHighlight,
    required this.onBreachHighlightChanged,
    required this.isLoading,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController minutesController;
  final bool breachHighlight;
  final ValueChanged<bool> onBreachHighlightChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      children: [
        Text(
          'Service Level Agreement',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Text(
          'Configure SLA rules for claim response times',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceXL),
        GlassCard(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time to first contact',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  'Set the target time (in minutes) for first contact with the client after a claim is created.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceL),
                GlassInput.textForm(
                  context: context,
                  controller: minutesController,
                  label: 'Minutes *',
                  hint: 'e.g. 240 (4 hours)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Enter a target in minutes';
                    }
                    final parsed = int.tryParse(trimmed);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a positive number';
                    }
                    if (parsed > 1440) {
                      return 'Target must be less than 24 hours (1440 minutes)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: DesignTokens.spaceXL),
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                const SizedBox(height: DesignTokens.spaceL),
                Text(
                  'Visual indicators',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  'Enable visual highlighting for claims that breach the SLA target.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Highlight claims breaching SLA'),
                  subtitle: const Text(
                    'Claims exceeding the target time will be visually highlighted in the queue.',
                  ),
                  value: breachHighlight,
                  onChanged: onBreachHighlightChanged,
                ),
                const SizedBox(height: DesignTokens.spaceXL),
                Align(
                  alignment: Alignment.centerRight,
                  child: GlassButton.primary(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            final minutes =
                                int.parse(minutesController.text.trim());
                            final messenger =
                                ScaffoldMessenger.of(context);
                            try {
                              await ref
                                  .read(slaRulesControllerProvider.notifier)
                                  .save(
                                    timeToFirstContactMinutes: minutes,
                                    breachHighlight: breachHighlight,
                                  );
                              if (!context.mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('SLA settings updated'),
                                ),
                              );
                            } catch (error) {
                              if (!context.mounted) return;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update SLA: $error',
                                  ),
                                ),
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(DesignTokens.spaceXL),
        margin: const EdgeInsets.all(DesignTokens.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spaceM),
            Text(
              'Error loading SLA rules',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: DesignTokens.spaceS),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceL),
            GlassButton.primary(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
