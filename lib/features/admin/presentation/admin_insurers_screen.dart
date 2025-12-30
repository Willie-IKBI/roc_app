import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/models/insurer.dart';
import '../controller/insurers_controller.dart';

class AdminInsurersScreen extends ConsumerStatefulWidget {
  const AdminInsurersScreen({super.key});

  @override
  ConsumerState<AdminInsurersScreen> createState() =>
      _AdminInsurersScreenState();
}

class _AdminInsurersScreenState extends ConsumerState<AdminInsurersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insurersAsync = ref.watch(adminInsurersControllerProvider);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Insurers'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          OutlinedButton.icon(
            onPressed: () => GoRouter.of(context).push('/claims'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.4)),
            ),
            icon: const Icon(Icons.list_alt_outlined),
            label: const Text('Queue'),
          ),
          const SizedBox(width: 12),
          GlassButton.primary(
            onPressed: () => _showCreateDialog(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_business_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('Add insurer'),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(adminInsurersControllerProvider.notifier).refresh(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 1200 ? 48.0 : 24.0;
              final useTwoColumn = constraints.maxWidth >= 1100;

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 28,
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Commercial network',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Maintain your insurer roster so claims flow is mapped to the right carrier and support contact.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      _RosterHealthPill(insurersAsync: insurersAsync),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: useTwoColumn ? 36 : 24,
                      vertical: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlassInput.text(
                          context: context,
                          controller: _searchController,
                          label: 'Search insurers',
                          prefixIcon: const Icon(Icons.search),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: insurersAsync.when(
                            data: (insurers) => _InsurersTable(
                              insurers: _filter(insurers),
                              onEdit: _showEditDialog,
                              onDelete: _confirmDelete,
                            ),
                            loading: () => const Padding(
                              padding: EdgeInsets.all(48),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (error, _) => Padding(
                              padding: const EdgeInsets.all(36),
                              child: _InsurersError(
                                message: error.toString(),
                                onRetry: () => ref
                                    .read(adminInsurersControllerProvider.notifier)
                                    .refresh(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SupportCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Insurer> _filter(List<Insurer> insurers) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return insurers;
    }
    return insurers.where((insurer) {
      return insurer.name.toLowerCase().contains(query) ||
          (insurer.contactEmail?.toLowerCase().contains(query) ?? false) ||
          (insurer.contactPhone?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final notifier = ref.read(adminInsurersControllerProvider.notifier);
    final result = await showGlassDialog<_InsurerInput>(
      context: context,
      builder: (context) => const _InsurerDialog(title: 'Add insurer'),
    );
    if (result == null) return;

    try {
      await notifier.createInsurer(
        name: result.name,
        contactPhone: result.phone,
        contactEmail: result.email,
      );
      _showSnack('${result.name} created');
    } catch (error) {
      _showSnack('Failed to create insurer: $error');
    }
  }

  Future<void> _showEditDialog(BuildContext context, Insurer insurer) async {
    final notifier = ref.read(adminInsurersControllerProvider.notifier);
    final result = await showGlassDialog<_InsurerInput>(
      context: context,
      builder: (context) => _InsurerDialog(
        title: 'Edit insurer',
        initialName: insurer.name,
        initialPhone: insurer.contactPhone,
        initialEmail: insurer.contactEmail,
      ),
    );
    if (result == null) return;

    try {
      await notifier.updateInsurer(
        id: insurer.id,
        name: result.name,
        contactPhone: result.phone,
        contactEmail: result.email,
      );
      _showSnack('${result.name} updated');
    } catch (error) {
      _showSnack('Failed to update insurer: $error');
    }
  }

  Future<void> _confirmDelete(BuildContext context, Insurer insurer) async {
    final confirm = await showGlassDialog<bool>(
      context: context,
      builder: (context) => GlassDialog(
        title: const Text('Delete insurer'),
        content: Text(
          'Are you sure you want to remove ${insurer.name}? This cannot be undone.',
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

    final notifier = ref.read(adminInsurersControllerProvider.notifier);
    try {
      await notifier.deleteInsurer(insurer.id);
      _showSnack('${insurer.name} deleted');
    } catch (error) {
      _showSnack('Failed to delete insurer: $error');
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _InsurersTable extends StatelessWidget {
  const _InsurersTable({
    required this.insurers,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Insurer> insurers;
  final void Function(BuildContext context, Insurer insurer) onEdit;
  final void Function(BuildContext context, Insurer insurer) onDelete;

  @override
  Widget build(BuildContext context) {
    if (insurers.isEmpty) {
      return const _EmptyInsurers();
    }
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingTextStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
          ),
          dataRowColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.hovered)
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45)
                : theme.colorScheme.surface,
          ),
          dividerThickness: 0.4,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Contact email')),
              DataColumn(label: Text('Contact phone')),
              DataColumn(label: Text('Actions')),
            ],
            rows: [
              for (final insurer in insurers)
                DataRow(
                  cells: [
                    DataCell(Text(insurer.name)),
                    DataCell(Text(insurer.contactEmail ?? '—')),
                    DataCell(Text(insurer.contactPhone ?? '—')),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => onEdit(context, insurer),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => onDelete(context, insurer),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyInsurers extends StatelessWidget {
  const _EmptyInsurers();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.domain_disabled_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No insurers yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add trusted carriers so captured claims can be routed without delay.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GlassButton.primary(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_business_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('Capture first insurer'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsurersError extends StatelessWidget {
  const _InsurersError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Unable to load insurers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
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
      ),
    );
  }
}

class _InsurerInput {
  const _InsurerInput({
    required this.name,
    this.email,
    this.phone,
  });

  final String name;
  final String? email;
  final String? phone;
}

class _InsurerDialog extends StatefulWidget {
  const _InsurerDialog({
    required this.title,
    this.initialName,
    this.initialEmail,
    this.initialPhone,
  });

  final String title;
  final String? initialName;
  final String? initialEmail;
  final String? initialPhone;

  @override
  State<_InsurerDialog> createState() => _InsurerDialogState();
}

class _InsurerDialogState extends State<_InsurerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _phoneController = TextEditingController(text: widget.initialPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassInput.textForm(
              context: context,
              controller: _nameController,
              label: 'Name',
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassInput.textForm(
              context: context,
              controller: _emailController,
              label: 'Contact email',
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return null;
                }
                if (!trimmed.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassInput.textForm(
              context: context,
              controller: _phoneController,
              label: 'Contact phone',
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return null;
                }
                return Validators.validateSouthAfricanPhone(trimmed);
              },
            ),
          ],
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
              _InsurerInput(
                name: _nameController.text.trim(),
                email: _emailController.text.trim().isEmpty
                    ? null
                    : _emailController.text.trim(),
                phone: _phoneController.text.replaceAll(' ', '').isEmpty
                    ? null
                    : _phoneController.text.trim(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _RosterHealthPill extends StatelessWidget {
  const _RosterHealthPill({required this.insurersAsync});

  final AsyncValue<List<Insurer>> insurersAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: insurersAsync.when(
        data: (insurers) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              '${insurers.length} insurers connected',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        loading: () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Loading network…',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        error: (error, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_outlined, color: theme.colorScheme.error),
            const SizedBox(width: 10),
            Text(
              'Check insurers',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.18),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Insurer onboarding tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Need help setting up SLAs or bulk-importing carriers? Reach out to the ROC enablement crew.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GlassButton.primary(
                onPressed: () => launchUrl(
                  Uri.parse('mailto:info@ikbi.co.za?subject=Insurer onboarding help'),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.email_outlined),
                    SizedBox(width: DesignTokens.spaceS),
                    Text('Email support'),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://cal.com/repair-on-call/insurer-onboarding'),
                ),
                icon: const Icon(Icons.schedule_outlined),
                label: const Text('Book a session'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

