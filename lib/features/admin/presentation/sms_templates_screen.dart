import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../domain/models/sms_template.dart';
import '../controller/sms_templates_controller.dart';

/// SMS Templates management screen with glassmorphism styling.
/// 
/// Allows admins to create, edit, and manage SMS templates for follow-ups.
class SmsTemplatesScreen extends ConsumerWidget {
  const SmsTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(smsTemplatesControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: templatesAsync.when(
          data: (templates) => _TemplatesContent(templates: templates),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorState(
            message: getUserFriendlyErrorMessage(error, isDebugMode: kDebugMode),
            onRetry: () =>
                ref.read(smsTemplatesControllerProvider.notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: GlassButton.primary(
        onPressed: () => _createTemplate(context, ref),
        semanticLabel: 'Create new SMS template',
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            SizedBox(width: DesignTokens.spaceS),
            Text('Create template'),
          ],
        ),
      ),
    );
  }

  Future<void> _createTemplate(BuildContext context, WidgetRef ref) async {
    final result = await showGlassDialog<_SmsTemplatePayload>(
      context: context,
      builder: (context) => const _SmsTemplateDialog(),
    );
    if (result == null) return;

    final notifier = ref.read(smsTemplatesControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await notifier.create(
        name: result.name,
        description: result.description,
        body: result.body,
        isActive: result.isActive,
        defaultForFollowUp: result.defaultForFollowUp,
      );
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Template ${result.name} created')),
      );
    } catch (error) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Unable to create template: $error')),
      );
    }
  }
}

class _TemplatesContent extends ConsumerWidget {
  const _TemplatesContent({required this.templates});

  final List<SmsTemplate> templates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      children: [
        Text(
          'SMS Templates',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Text(
          'Manage templates for automated follow-up messages',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceXL),
        if (templates.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(DesignTokens.spaceXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sms_outlined,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: DesignTokens.spaceM),
                Text(
                  'No templates yet',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  'Create templates to speed up standard follow-ups.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...templates.map((template) => Padding(
                padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                child: _SmsTemplateCard(template: template),
              )),
      ],
    );
  }
}

class _SmsTemplateCard extends ConsumerWidget {
  const _SmsTemplateCard({required this.template});

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
      final result = await showGlassDialog<_SmsTemplatePayload>(
        context: context,
        builder: (context) => _SmsTemplateDialog(template: template),
      );
      if (result == null) return;
      try {
        await controller.updateTemplate(
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
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update template: $error')),
        );
      }
    }

    Future<void> remove() async {
      final confirm = await showGlassDialog<bool>(
        context: context,
        builder: (context) => GlassDialog(
          title: const Text('Delete template'),
          content: Text(
            'Delete ${template.name}? This cannot be undone.',
          ),
          actions: [
            GlassButton.ghost(
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

    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            template.name,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        if (template.defaultForFollowUp)
                          GlassButton.ghost(
                            onPressed: null,
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spaceS,
                              vertical: DesignTokens.spaceXS,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: DesignTokens.primaryRed,
                                ),
                                const SizedBox(width: DesignTokens.spaceXS),
                                Text(
                                  'Default',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: DesignTokens.primaryRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (template.description != null &&
                        template.description!.isNotEmpty) ...[
                      const SizedBox(height: DesignTokens.spaceXS),
                      Text(
                        template.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Semantics(
                label: 'Toggle template active status',
                child: Switch(
                  value: template.isActive,
                  onChanged: toggleActive,
                ),
              ),
              const SizedBox(width: DesignTokens.spaceS),
              GlassButton.ghost(
                onPressed: template.defaultForFollowUp ? null : setDefault,
                semanticLabel: 'Set as default follow-up template',
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: Icon(
                  template.defaultForFollowUp
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
              GlassButton.ghost(
                onPressed: edit,
                semanticLabel: 'Edit template',
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: const Icon(Icons.edit_outlined),
              ),
              GlassButton.ghost(
                onPressed: remove,
                semanticLabel: 'Delete template',
                padding: const EdgeInsets.all(DesignTokens.spaceS),
                child: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spaceM),
          GlassCard(
            padding: const EdgeInsets.all(DesignTokens.spaceM),
            blurSigma: DesignTokens.blurSmall,
            child: Text(
              template.body,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
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
    return GlassDialog(
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
                const SizedBox(height: DesignTokens.spaceM),
                GlassInput.textForm(
                  context: context,
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Optional - internal reference only',
                ),
                const SizedBox(height: DesignTokens.spaceM),
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
                const SizedBox(height: DesignTokens.spaceM),
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
        GlassButton.ghost(
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
              'Error loading templates',
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
