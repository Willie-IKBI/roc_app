import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../admin/controller/queue_settings_controller.dart';
import '../../admin/controller/sla_rules_controller.dart';
import '../../admin/controller/sms_templates_controller.dart';
import '../../../domain/models/sms_template.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final slaAsync = ref.watch(slaRulesControllerProvider);
    final queueAsync = ref.watch(queueSettingsControllerProvider);
    final smsAsync = ref.watch(smsTemplatesControllerProvider);
    final senderAsync = ref.watch(smsSenderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          children: [
            Text(
              'Service level agreement',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: DesignTokens.spaceM),
            _SlaRuleCard(state: slaAsync),
            const SizedBox(height: DesignTokens.spaceXL),
            Text(
              'Queue retry configuration',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: DesignTokens.spaceM),
            _QueueSettingsCard(state: queueAsync),
            const SizedBox(height: DesignTokens.spaceXL),
            Text(
              'SMS sender',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: DesignTokens.spaceM),
            _SmsSenderCard(state: senderAsync),
            const SizedBox(height: DesignTokens.spaceXL),
            Text(
              'SMS templates',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _SmsTemplatesSection(state: smsAsync),
          ],
        ),
      ),
    );
  }
}

class _SlaRuleCard extends ConsumerStatefulWidget {
  const _SlaRuleCard({required this.state});

  final AsyncValue<dynamic> state;

  @override
  ConsumerState<_SlaRuleCard> createState() => _SlaRuleCardState();
}

class _SlaRuleCardState extends ConsumerState<_SlaRuleCard> {
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
    ref.listen(slaRulesControllerProvider, (previous, next) {
      next.whenData((rule) {
        if (!mounted) return;
        setState(() {
          _minutesController.text = rule.timeToFirstContactMinutes.toString();
          _breachHighlight = rule.breachHighlight;
        });
      });
    });

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: widget.state.when(
          data: (rule) {
            if (_minutesController.text.isEmpty) {
              _minutesController.text =
                  rule.timeToFirstContactMinutes.toString();
              _breachHighlight = rule.breachHighlight;
            }
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time to first contact (minutes)',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  GlassInput.textForm(
                    context: context,
                    controller: _minutesController,
                    hint: 'e.g. 240',
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
                        return 'Target must be less than 24 hours';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Highlight claims breaching SLA'),
                    value: _breachHighlight,
                    onChanged: (value) => setState(() {
                      _breachHighlight = value;
                    }),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlassButton.primary(
                      onPressed: widget.state.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              final minutes =
                                  int.parse(_minutesController.text.trim());
                              final messenger =
                                  ScaffoldMessenger.of(context);
                              try {
                                await ref
                                    .read(
                                      slaRulesControllerProvider.notifier,
                                    )
                                    .save(
                                      timeToFirstContactMinutes: minutes,
                                      breachHighlight: _breachHighlight,
                                    );
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('SLA settings updated'),
                                  ),
                                );
                              } catch (error) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update SLA: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: widget.state.isLoading
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SettingsError(
            message: error.toString(),
            onRetry: () => ref
                .read(slaRulesControllerProvider.notifier)
                .refresh(),
          ),
        ),
    );
  }
}

class _QueueSettingsCard extends ConsumerStatefulWidget {
  const _QueueSettingsCard({required this.state});

  final AsyncValue<dynamic> state;

  @override
  ConsumerState<_QueueSettingsCard> createState() =>
      _QueueSettingsCardState();
}

class _QueueSettingsCardState extends ConsumerState<_QueueSettingsCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _retryLimitController;
  late final TextEditingController _retryIntervalController;

  @override
  void initState() {
    super.initState();
    _retryLimitController = TextEditingController();
    _retryIntervalController = TextEditingController();
  }

  @override
  void dispose() {
    _retryLimitController.dispose();
    _retryIntervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(queueSettingsControllerProvider, (previous, next) {
      next.whenData((settings) {
        if (!mounted) return;
        setState(() {
          _retryLimitController.text = settings.retryLimit.toString();
          _retryIntervalController.text =
              settings.retryIntervalMinutes.toString();
        });
      });
    });

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: widget.state.when(
          data: (settings) {
            if (_retryLimitController.text.isEmpty) {
              _retryLimitController.text = settings.retryLimit.toString();
              _retryIntervalController.text =
                  settings.retryIntervalMinutes.toString();
            }
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassInput.textForm(
                    context: context,
                    controller: _retryLimitController,
                    label: 'Retry limit',
                    hint: 'Number of contact attempts before escalation',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) {
                        return 'Enter a value';
                      }
                      final parsed = int.tryParse(trimmed);
                      if (parsed == null || parsed < 1 || parsed > 10) {
                        return 'Enter a value between 1 and 10';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GlassInput.textForm(
                    context: context,
                    controller: _retryIntervalController,
                    label: 'Retry interval (minutes)',
                    hint: 'Minimum time between contact attempts for callbacks',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) {
                        return 'Enter a value';
                      }
                      final parsed = int.tryParse(trimmed);
                      if (parsed == null || parsed < 15 || parsed > 1440) {
                        return 'Enter between 15 and 1440 minutes';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlassButton.primary(
                      onPressed: widget.state.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              final retryLimit =
                                  int.parse(_retryLimitController.text.trim());
                              final retryInterval = int.parse(
                                _retryIntervalController.text.trim(),
                              );
                              final messenger =
                                  ScaffoldMessenger.of(context);
                              try {
                                await ref
                                    .read(
                                      queueSettingsControllerProvider
                                          .notifier,
                                    )
                                    .save(
                                      retryLimit: retryLimit,
                                      retryIntervalMinutes: retryInterval,
                                    );
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Queue settings updated'),
                                  ),
                                );
                              } catch (error) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update queue settings: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: widget.state.isLoading
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SettingsError(
            message: error.toString(),
            onRetry: () => ref
                .read(queueSettingsControllerProvider.notifier)
                .refresh(),
          ),
        ),
    );
  }
}

class _SettingsError extends StatelessWidget {
  const _SettingsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        GlassButton.primary(
          onPressed: onRetry,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh),
              SizedBox(width: DesignTokens.spaceS),
              Text('Retry'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmsSenderCard extends ConsumerStatefulWidget {
  const _SmsSenderCard({required this.state});

  final AsyncValue<dynamic> state;

  @override
  ConsumerState<_SmsSenderCard> createState() => _SmsSenderCardState();
}

class _SmsSenderCardState extends ConsumerState<_SmsSenderCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(smsSenderControllerProvider, (previous, next) {
      next.whenData((settings) {
        if (!mounted) return;
        _nameController.text = settings.senderName ?? '';
        _numberController.text = settings.senderNumber ?? '';
      });
    });

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: widget.state.when(
          data: (settings) {
            if (_nameController.text.isEmpty &&
                _numberController.text.isEmpty) {
              _nameController.text = settings.senderName ?? '';
              _numberController.text = settings.senderNumber ?? '';
            }
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sender name',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  GlassInput.textForm(
                    context: context,
                    controller: _nameController,
                    hint: 'Repair on Call',
                    maxLength: 11,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sender number',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  GlassInput.textForm(
                    context: context,
                    controller: _numberController,
                    hint: '+27821234567',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Configure the name or number that appears to recipients. '
                    'Some networks require registration before alphanumeric sender IDs are allowed.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlassButton.primary(
                      onPressed: widget.state.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              final messenger =
                                  ScaffoldMessenger.of(context);
                              try {
                                await ref
                                    .read(smsSenderControllerProvider.notifier)
                                    .saveSender(
                                      senderName: _nameController.text.trim().isEmpty
                                          ? null
                                          : _nameController.text.trim(),
                                      senderNumber: _numberController.text.trim().isEmpty
                                          ? null
                                          : _numberController.text.trim(),
                                    );
                                if (!context.mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Sender settings saved'),
                                  ),
                                );
                              } catch (error) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to save sender settings: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: widget.state.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save sender'),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SettingsError(
            message: error.toString(),
            onRetry: () =>
                ref.read(smsSenderControllerProvider.notifier).refresh(),
          ),
        ),
    );
  }
}

class _SmsTemplatesSection extends ConsumerWidget {
  const _SmsTemplatesSection({required this.state});

  final AsyncValue<dynamic> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: state.when(
          data: (templates) => _SmsTemplatesContent(templates: templates),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SettingsError(
            message: error.toString(),
            onRetry: () =>
                ref.read(smsTemplatesControllerProvider.notifier).refresh(),
          ),
        ),
    );
  }
}

class _SmsTemplatesContent extends ConsumerWidget {
  const _SmsTemplatesContent({required this.templates});

  final List<SmsTemplate> templates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GlassButton.primary(
            onPressed: () => _editTemplate(context, ref),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sms_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('Create template'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (templates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Icon(
                  Icons.sms_outlined,
                  size: 48,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No templates yet',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add templates to speed up standard follow-ups.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              for (final template in templates) ...[
                _SmsTemplateTile(template: template),
                const Divider(height: 24),
              ],
            ],
          ),
      ],
    );
  }

  Future<void> _editTemplate(BuildContext context, WidgetRef ref,
      {SmsTemplate? template}) async {
    final result = await showDialog<_SmsTemplatePayload>(
      context: context,
      builder: (context) => _SmsTemplateDialog(template: template),
    );
    if (result == null) return;

    final notifier = ref.read(smsTemplatesControllerProvider.notifier);
    try {
      if (template == null) {
        await notifier.create(
          name: result.name,
          description: result.description,
          body: result.body,
          isActive: result.isActive,
          defaultForFollowUp: result.defaultForFollowUp,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template ${result.name} created')),
        );
      } else {
        await notifier.updateTemplate(
          id: template.id,
          name: result.name,
          description: result.description,
          body: result.body,
          isActive: result.isActive,
          defaultForFollowUp: result.defaultForFollowUp,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template ${result.name} updated')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save template: $error')),
      );
    }
  }
}

class _SmsTemplateTile extends ConsumerWidget {
  const _SmsTemplateTile({required this.template});

  final SmsTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(smsTemplatesControllerProvider.notifier);

    Future<void> setDefault() async {
      try {
        await controller.setDefault(template);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${template.name} set as default follow-up'),
          ),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update default: $error')),
        );
      }
    }

    Future<void> toggleActive(bool value) async {
      try {
        await controller.updateTemplate(
          id: template.id,
          name: template.name,
          description: template.description,
          body: template.body,
          isActive: value,
          defaultForFollowUp: template.defaultForFollowUp,
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update template: $error')),
        );
      }
    }

    Future<void> edit() async {
      final payload = await showDialog<_SmsTemplatePayload>(
        context: context,
        builder: (context) => _SmsTemplateDialog(template: template),
      );
      if (payload == null) return;
      try {
        await controller.updateTemplate(
          id: template.id,
          name: payload.name,
          description: payload.description,
          body: payload.body,
          isActive: payload.isActive,
          defaultForFollowUp: payload.defaultForFollowUp,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template ${payload.name} updated')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update template: $error')),
        );
      }
    }

    Future<void> remove() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete template'),
          content: Text(
            'Delete ${template.name}? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            GlassButton.primary(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      try {
        await controller.delete(template.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template ${template.name} deleted')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to delete template: $error')),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (template.description != null &&
                      template.description!.isNotEmpty)
                    Text(
                      template.description!,
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Switch(
              value: template.isActive,
              onChanged: toggleActive,
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: template.defaultForFollowUp ? null : setDefault,
              icon: Icon(
                template.defaultForFollowUp
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              label: Text(
                template.defaultForFollowUp
                    ? 'Default follow-up'
                    : 'Set as default',
              ),
            ),
            IconButton(
              tooltip: 'Edit template',
              icon: const Icon(Icons.edit_outlined),
              onPressed: edit,
            ),
            IconButton(
              tooltip: 'Delete template',
              icon: const Icon(Icons.delete_outline),
              onPressed: remove,
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(12),
          child: Text(
            template.body,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _SmsTemplateDialog extends StatefulWidget {
  const _SmsTemplateDialog({this.template});

  final SmsTemplate? template;

  @override
  State<_SmsTemplateDialog> createState() => _SmsTemplateDialogState();
}

class _SmsTemplateDialogState extends State<_SmsTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _bodyController;
  bool _isActive = true;
  bool _defaultForFollowUp = false;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    _nameController = TextEditingController(text: template?.name ?? '');
    _descriptionController =
        TextEditingController(text: template?.description ?? '');
    _bodyController = TextEditingController(text: template?.body ?? '');
    _isActive = template?.isActive ?? true;
    _defaultForFollowUp = template?.defaultForFollowUp ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.template != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit SMS template' : 'Create SMS template'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassInput.textForm(
                  context: context,
                  controller: _nameController,
                  label: 'Template name *',
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Enter a template name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                GlassInput.textForm(
                  context: context,
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Optional - internal reference only',
                ),
                const SizedBox(height: 12),
                GlassInput.textForm(
                  context: context,
                  controller: _bodyController,
                  label: 'Message body *',
                  hint: 'Use placeholders like {claim_number}, {client_name}',
                  maxLines: 6,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Enter a message body';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _isActive,
                  title: const Text('Active'),
                  onChanged: (value) => setState(() => _isActive = value),
                ),
                CheckboxListTile(
                  value: _defaultForFollowUp,
                  onChanged: (value) =>
                      setState(() => _defaultForFollowUp = value ?? false),
                  title: const Text('Default follow-up template'),
                  subtitle: const Text(
                    'New follow-ups will use this template by default.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        GlassButton.primary(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              _SmsTemplatePayload(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                body: _bodyController.text.trim(),
                isActive: _isActive,
                defaultForFollowUp: _defaultForFollowUp,
              ),
            );
          },
          child: Text(isEditing ? 'Save changes' : 'Create template'),
        ),
      ],
    );
  }
}

class _SmsTemplatePayload {
  _SmsTemplatePayload({
    required this.name,
    this.description,
    required this.body,
    required this.isActive,
    required this.defaultForFollowUp,
  });

  final String name;
  final String? description;
  final String body;
  final bool isActive;
  final bool defaultForFollowUp;
}

