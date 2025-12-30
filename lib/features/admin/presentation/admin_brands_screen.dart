import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../core/errors/domain_error.dart';
import '../../../domain/models/brand.dart';
import '../controller/brands_controller.dart';

class AdminBrandsScreen extends ConsumerStatefulWidget {
  const AdminBrandsScreen({super.key});

  @override
  ConsumerState<AdminBrandsScreen> createState() => _AdminBrandsScreenState();
}

class _AdminBrandsScreenState extends ConsumerState<AdminBrandsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandsAsync = ref.watch(brandsControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: brandsAsync.when(
          data: (brands) => _BrandsContent(
            brands: brands,
            searchController: _searchController,
            onSearchChanged: () => setState(() {}),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _BrandsError(
            message: error.toString(),
            onRetry: () =>
                ref.read(brandsControllerProvider.notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: GlassButton.primary(
        onPressed: () => _showEditor(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.label_outline),
            SizedBox(width: DesignTokens.spaceS),
            Text('Add brand'),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditor(BuildContext context, {Brand? brand}) async {
    final result = await showGlassDialog<String>(
      context: context,
      builder: (context) => _BrandDialog(brand: brand),
    );
    if (result == null) return;

    final notifier = ref.read(brandsControllerProvider.notifier);

    try {
      if (brand == null) {
        await notifier.create(result);
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Added $result')));
      } else {
        await notifier.updateBrand(id: brand.id, name: result);
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Updated $result')));
      }
    } on DomainError catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save brand: ${error.message}')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to save brand: $error')));
    }
  }
}

class _BrandsContent extends ConsumerWidget {
  const _BrandsContent({
    required this.brands,
    required this.searchController,
    required this.onSearchChanged,
  });

  final List<Brand> brands;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filtered = _filterBrands();

    return RefreshIndicator(
      onRefresh: () => ref.read(brandsControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Brands',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: GlassInput.text(
                  context: context,
                  controller: searchController,
                  label: 'Search brands',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (_) => onSearchChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              children: [
                const _BrandsTableHeader(),
                const Divider(height: 1),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_outlined,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No brands match your filters',
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
                  for (final brand in filtered) ...[
                    _BrandRow(brand: brand),
                    const Divider(height: 1),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Brand> _filterBrands() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return brands;
    return brands
        .where((brand) => brand.name.toLowerCase().contains(query))
        .toList(growable: false);
  }
}

class _BrandsTableHeader extends StatelessWidget {
  const _BrandsTableHeader();

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
          Expanded(child: Text('Name', style: style)),
          const SizedBox(width: 96, child: Text('Actions')),
        ],
      ),
    );
  }
}

class _BrandRow extends ConsumerWidget {
  const _BrandRow({required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> edit() async {
      final state = context.findAncestorStateOfType<_AdminBrandsScreenState>();
      await state?._showEditor(context, brand: brand);
    }

    Future<void> remove() async {
      final confirm = await showGlassDialog<bool>(
        context: context,
        builder: (context) => GlassDialog(
          title: const Text('Remove brand'),
          content: Text('Remove ${brand.name}?'),
          actions: [
            GlassButton.ghost(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            GlassButton.primary(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      final notifier = ref.read(brandsControllerProvider.notifier);
      try {
        await notifier.deleteBrand(brand.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Removed ${brand.name}')));
      } on DomainError catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to remove brand: ${error.message}')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to remove brand: $error')),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(brand.name, style: theme.textTheme.bodyLarge)),
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

class _BrandDialog extends StatefulWidget {
  const _BrandDialog({this.brand});

  final Brand? brand;

  @override
  State<_BrandDialog> createState() => _BrandDialogState();
}

class _BrandDialogState extends State<_BrandDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.brand?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.brand != null;
    return GlassDialog(
      title: Text(isEditing ? 'Edit brand' : 'Add brand'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: GlassInput.textForm(
            context: context,
            controller: _nameController,
            label: 'Brand name *',
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return 'Enter a brand name';
              }
              return null;
            },
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
            Navigator.of(context).pop(_nameController.text.trim());
          },
          child: Text(isEditing ? 'Save changes' : 'Create brand'),
        ),
      ],
    );
  }
}

class _BrandsError extends StatelessWidget {
  const _BrandsError({required this.message, required this.onRetry});

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
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text('Unable to load brands', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(message, textAlign: TextAlign.center),
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
      ),
    );
  }
}
