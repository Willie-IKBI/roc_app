import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/theme_preference_provider.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../domain/models/profile.dart';
import '../../../core/utils/validators.dart';
import '../../profile/controller/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    final profileAsync = ref.read(profileControllerProvider);
    profileAsync.whenData((profile) {
      _nameController.text = profile.fullName;
      _phoneController.text = profile.phone ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    ref.listen(profileControllerProvider, (previous, next) {
      next.whenData((profile) {
        _nameController.text = profile.fullName;
        _phoneController.text = profile.phone ?? '';
      });
    });

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('My profile'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            final theme = Theme.of(context);
            final outline =
                theme.colorScheme.outlineVariant.withValues(alpha: 0.28);
            // Use GlassInput for consistent styling

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                final horizontalPadding = isDesktop ? 48.0 : 24.0;
                final cardRadius = BorderRadius.circular(isDesktop ? 24 : 20);

                return ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: DesignTokens.spaceL,
                  ),
                  children: [
                    _ProfileSummaryCard(profile: profile),
                    if (!profile.isActive) ...[
                      const SizedBox(height: DesignTokens.spaceM),
                      const _InactiveProfileBanner(),
                    ],
                    const SizedBox(height: DesignTokens.spaceL),
                    Form(
                      key: _formKey,
                      child: GlassCard(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? DesignTokens.spaceXL : DesignTokens.spaceL,
                          vertical: isDesktop ? DesignTokens.spaceXL : DesignTokens.spaceL,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account details',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Name, email and role power your audit trail and notifications.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 28),
                              LayoutBuilder(
                                builder: (context, cardConstraints) {
                                  final useTwoColumns = cardConstraints.maxWidth >= 720;
                                  final columnWidth = useTwoColumns
                                      ? (cardConstraints.maxWidth - 24) / 2
                                      : cardConstraints.maxWidth;
                                  return Wrap(
                                    spacing: 24,
                                    runSpacing: 24,
                                    children: [
                                      SizedBox(
                                        width: columnWidth,
                                        child: TextFormField(
                                          key: const ValueKey('profile-email'),
                                          initialValue: profile.email,
                                          readOnly: true,
                                          decoration: GlassInput.decoration(
                                            context: context,
                                            label: 'Email',
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: columnWidth,
                                        child: TextFormField(
                                          controller: _nameController,
                                          enabled: profile.isActive,
                                          decoration: GlassInput.decoration(
                                            context: context,
                                            label: 'Full name',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: columnWidth,
                                        child: TextFormField(
                                          controller: _phoneController,
                                          enabled: profile.isActive,
                                          decoration: GlassInput.decoration(
                                            context: context,
                                            label: 'Mobile number',
                                            hint: 'e.g. 0821234567',
                                          ),
                                          keyboardType: TextInputType.phone,
                                          validator:
                                              Validators.validateOptionalSouthAfricanPhone,
                                        ),
                                      ),
                                      SizedBox(
                                        width: columnWidth,
                                        child: TextFormField(
                                          key: const ValueKey('profile-role'),
                                          initialValue: profile.role,
                                          readOnly: true,
                                          decoration: GlassInput.decoration(
                                            context: context,
                                            label: 'Role',
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: DesignTokens.spaceXL),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GlassButton.primary(
                                  onPressed: (!profile.isActive)
                                      ? null
                                      : () async {
                                          if (!_formKey.currentState!.validate()) {
                                            return;
                                          }
                                          final messenger =
                                              ScaffoldMessenger.of(context);
                                          try {
                                            await ref
                                                .read(profileControllerProvider.notifier)
                                                .updateProfile(
                                                  fullName: _nameController.text,
                                                  phone: _phoneController.text,
                                                );
                                            if (!mounted) return;
                                            messenger.showSnackBar(
                                              const SnackBar(
                                                content: Text('Profile updated'),
                                              ),
                                            );
                                          } catch (error) {
                                            if (!mounted) return;
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to update profile: $error',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.save_outlined),
                                      SizedBox(width: DesignTokens.spaceS),
                                      Text('Save changes'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: DesignTokens.spaceL),
                    const _AppearanceCard(),
                    const SizedBox(height: DesignTokens.spaceL),
                    _SupportCard(email: profile.email),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ProfileError(
            message: error.toString(),
            onRetry: () =>
                ref.read(profileControllerProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              'Unable to load profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
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

class _InactiveProfileBanner extends StatelessWidget {
  const _InactiveProfileBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.35),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile inactive',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can browse but not update details. Reach out to your administrator to reactivate your access.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final statusColor =
        profile.isActive ? theme.colorScheme.primary : theme.colorScheme.error;

    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceXL,
        vertical: DesignTokens.spaceL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.person_outline,
              color: accent.darken(),
              size: 32,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName.isEmpty ? 'Complete your profile' : profile.fullName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (profile.phone?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    profile.phone!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Chip(
                      icon: Icons.work_outline,
                      label: profile.role.replaceAll('_', ' '),
                      color: accent,
                    ),
                    _Chip(
                      icon: profile.isActive
                          ? Icons.verified_outlined
                          : Icons.pause_circle_outline,
                      label: profile.isActive ? 'Active profile' : 'Inactive profile',
                      color: statusColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color.darken()),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color.darken(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceCard extends ConsumerWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themePreference = ref.watch(themePreferenceProvider);
    
    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appearanceSettings,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.appearanceDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceL),
          themePreference.when(
            data: (currentMode) {
              final isDark = currentMode == ThemeMode.dark;
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: DesignTokens.spaceM),
                    Text(
                      isDark ? AppStrings.themeDark : AppStrings.themeLight,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
                value: isDark,
                onChanged: (value) {
                  final newMode = value ? ThemeMode.dark : ThemeMode.light;
                  ref.read(themePreferenceProvider.notifier).setThemeMode(newMode);
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(DesignTokens.spaceL),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Text(
              'Error loading theme preference: $error',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Need a hand?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'If you get locked out or notice incorrect data, ping the ROC support squad.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          GlassButton.primary(
            onPressed: () => GoRouter.of(context).push('/claims'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.list_alt_outlined),
                SizedBox(width: DesignTokens.spaceS),
                Text('Back to queue'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.email_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support desk',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        'info@ikbi.co.za',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _Shade on Color {
  Color darken([double amount = .15]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

