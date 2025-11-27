import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/domain_error.dart';
import '../../../domain/models/service_provider.dart';
import '../controller/service_providers_controller.dart';

class AdminServiceProvidersScreen extends ConsumerStatefulWidget {
  const AdminServiceProvidersScreen({super.key});

  @override
  ConsumerState<AdminServiceProvidersScreen> createState() =>
      _AdminServiceProvidersScreenState();
}

class _AdminServiceProvidersScreenState
    extends ConsumerState<AdminServiceProvidersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providersAsync = ref.watch(serviceProvidersControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: providersAsync.when(
          data: (providers) => _ServiceProviderContent(
            providers: providers,
            searchController: _searchController,
            onSearchChanged: () => setState(() {}),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ServiceProviderError(
            message: error.toString(),
            onRetry: () =>
                ref.read(serviceProvidersControllerProvider.notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditor(context),
        icon: const Icon(Icons.add_business_outlined),
        label: const Text('Add provider'),
      ),
    );
  }

  Future<void> _showEditor(BuildContext context,
      {ServiceProvider? provider}) async {
    final result = await showDialog<_ServiceProviderPayload>(
      context: context,
      builder: (context) => _ServiceProviderDialog(provider: provider),
    );
    if (result == null) return;

    final notifier = ref.read(serviceProvidersControllerProvider.notifier);

    try {
      if (provider == null) {
        await notifier.create(
          companyName: result.companyName,
          contactName: result.contactName,
          contactPhone: result.contactPhone,
          contactEmail: result.contactEmail,
          referenceNumber: result.referenceNumberFormat,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${result.companyName}')),
        );
      } else {
        await notifier.updateProvider(
          id: provider.id,
          companyName: result.companyName,
          contactName: result.contactName,
          contactPhone: result.contactPhone,
          contactEmail: result.contactEmail,
          referenceNumber: result.referenceNumberFormat,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated ${result.companyName}')),
        );
      }
    } on DomainError catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save provider: ${error.message}')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save provider: $error')),
      );
    }
  }
}

class _ServiceProviderContent extends ConsumerWidget {
  const _ServiceProviderContent({
    required this.providers,
    required this.searchController,
    required this.onSearchChanged,
  });

  final List<ServiceProvider> providers;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filtered = _filterProviders();

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(serviceProvidersControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Service providers',
                  style:
                      theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search providers',
                  ),
                  onChanged: (_) => onSearchChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                const _TableHeader(),
                const Divider(height: 1),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No providers match your filters',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try a different search term.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                else
                  for (final provider in filtered) ...[
                    _ProviderRow(provider: provider),
                    const Divider(height: 1),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ServiceProvider> _filterProviders() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return providers;
    return providers.where((provider) {
      return provider.companyName.toLowerCase().contains(query) ||
          (provider.contactName?.toLowerCase().contains(query) ?? false) ||
          (provider.contactEmail?.toLowerCase().contains(query) ?? false);
    }).toList();
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Company', style: style)),
          Expanded(flex: 2, child: Text('Contact', style: style)),
          Expanded(flex: 2, child: Text('Phone', style: style)),
          Expanded(flex: 3, child: Text('Email', style: style)),
          Expanded(flex: 2, child: Text('Reference format', style: style)),
          const SizedBox(width: 96, child: Text('Actions')),
        ],
      ),
    );
  }
}

class _ProviderRow extends ConsumerWidget {
  const _ProviderRow({required this.provider});

  final ServiceProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> edit() async {
      final state =
          context.findAncestorStateOfType<_AdminServiceProvidersScreenState>();
      await state?._showEditor(context, provider: provider);
    }

    Future<void> remove() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove provider'),
          content: Text(
              'Remove ${provider.companyName}? Claims will need to reference another provider.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      final notifier = ref.read(serviceProvidersControllerProvider.notifier);
      try {
        await notifier.remove(provider.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed ${provider.companyName}')),
        );
      } on DomainError catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to remove provider: $error')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to remove provider: $error')),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              provider.companyName,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(provider.contactName ?? '—'),
          ),
          Expanded(
            flex: 2,
            child: Text(provider.contactPhone ?? '—'),
          ),
          Expanded(
            flex: 3,
            child: Text(provider.contactEmail ?? '—'),
          ),
          Expanded(
            flex: 2,
            child: Text(provider.referenceNumberFormat ?? '—'),
          ),
          SizedBox(
            width: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: edit,
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: remove,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceProviderDialog extends StatefulWidget {
  const _ServiceProviderDialog({this.provider});

  final ServiceProvider? provider;

  @override
  State<_ServiceProviderDialog> createState() =>
      _ServiceProviderDialogState();
}

class _ServiceProviderDialogState extends State<_ServiceProviderDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _contactNameController;
  late final TextEditingController _contactPhoneController;
  late final TextEditingController _contactEmailController;
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    final provider = widget.provider;
    _companyController = TextEditingController(text: provider?.companyName);
    _contactNameController =
        TextEditingController(text: provider?.contactName ?? '');
    _contactPhoneController =
        TextEditingController(text: provider?.contactPhone ?? '');
    _contactEmailController =
        TextEditingController(text: provider?.contactEmail ?? '');
    _referenceController =
        TextEditingController(text: provider?.referenceNumberFormat ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.provider != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit provider' : 'Add provider'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company name *',
                  ),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Enter a company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactNameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact name',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Contact phone',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Contact email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference number format',
                    helperText: 'Optional - shown to agents on capture screen',
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
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              _ServiceProviderPayload(
                companyName: _companyController.text.trim(),
                contactName: _contactNameController.text.trim().isEmpty
                    ? null
                    : _contactNameController.text.trim(),
                contactPhone: _contactPhoneController.text.trim().isEmpty
                    ? null
                    : _contactPhoneController.text.trim(),
                contactEmail: _contactEmailController.text.trim().isEmpty
                    ? null
                    : _contactEmailController.text.trim(),
                referenceNumberFormat: _referenceController.text.trim().isEmpty
                    ? null
                    : _referenceController.text.trim(),
              ),
            );
          },
          child: Text(isEditing ? 'Save changes' : 'Create provider'),
        ),
      ],
    );
  }
}

class _ServiceProviderPayload {
  _ServiceProviderPayload({
    required this.companyName,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.referenceNumberFormat,
  });

  final String companyName;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? referenceNumberFormat;
}

class _ServiceProviderError extends StatelessWidget {
  const _ServiceProviderError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Unable to load providers',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}


