import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../domain/models/user_account.dart';
import '../../../domain/value_objects/role_type.dart';
import '../controller/admin_users_controller.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showInactive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: usersAsync.when(
          data: (users) => _UsersContent(
            users: users,
            searchController: _searchController,
            showInactive: _showInactive,
            onToggleInactive: (value) => setState(() => _showInactive = value),
            onSearchChanged: () => setState(() {}),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => GlassErrorState(
            title: 'Unable to load users',
            message: error.toString(),
            onRetry: () =>
                ref.read(adminUsersControllerProvider.notifier).refresh(),
          ),
        ),
      ),
      floatingActionButton: GlassButton.primary(
        onPressed: () => _inviteUser(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add_alt_1_outlined),
            SizedBox(width: DesignTokens.spaceS),
            Text('Invite user'),
          ],
        ),
      ),
    );
  }

  Future<void> _inviteUser(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showGlassDialog<_InvitePayload>(
      context: context,
      builder: (context) => const _InviteDialog(),
    );
    if (result == null) {
      return;
    }
    final notifier = ref.read(adminUsersControllerProvider.notifier);
    try {
      await notifier.invite(email: result.email, role: result.role);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Invite sent to ${result.email}'),
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to send invite: $error')),
      );
    }
  }
}

class _UsersContent extends ConsumerWidget {
  const _UsersContent({
    required this.users,
    required this.searchController,
    required this.showInactive,
    required this.onToggleInactive,
    required this.onSearchChanged,
  });

  final List<UserAccount> users;
  final TextEditingController searchController;
  final bool showInactive;
  final ValueChanged<bool> onToggleInactive;
  final VoidCallback onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = _filterUsers();
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(adminUsersControllerProvider.notifier).refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final horizontalPadding = isDesktop ? 48.0 : 24.0;
          final surfaceColor = theme.colorScheme.surface;
          final cardRadius = BorderRadius.circular(isDesktop ? 24 : 20);

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 28,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (_incompleteCount(filtered: users) > 0) ...[
                _AutoProvisionBanner(
                  incompleteCount: _incompleteCount(filtered: users),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Users',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Invite team members, assign roles, and keep your roster current.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: GlassInput.text(
                      context: context,
                      controller: searchController,
                      label: 'Search users',
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (_) => onSearchChanged(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilterChip(
                    label: const Text('Show inactive'),
                    selected: showInactive,
                    onSelected: onToggleInactive,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              GlassCard(
                borderRadius: cardRadius,
                child: Column(
                  children: [
                    _TableHeader(theme: theme),
                    Divider(
                      height: 1,
                      color:
                          theme.colorScheme.outline.withValues(alpha: 0.1),
                    ),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No users match your filters',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Adjust search or visibility to see more users.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      for (final user in filtered) ...[
                        _UserRow(user: user),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.2),
                        ),
                      ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<UserAccount> _filterUsers() {
    final query = searchController.text.trim().toLowerCase();
    return users.where((user) {
      if (!showInactive && !user.isActive) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
  }

  int _incompleteCount({required List<UserAccount> filtered}) {
    return filtered
        .where((user) =>
            user.fullName.trim().isEmpty ||
            (user.phone == null || user.phone!.trim().isEmpty))
        .length;
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final style = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Name', style: style),
          ),
          Expanded(
            flex: 3,
            child: Text('Email', style: style),
          ),
          Expanded(
            flex: 2,
            child: Text('Role', style: style),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Status', style: style),
            ),
          ),
          SizedBox(
            width: 132,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('Actions', style: style),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserRow extends ConsumerWidget {
  const _UserRow({required this.user});

  final UserAccount user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> handleRoleChange(RoleType role) async {
      final notifier = ref.read(adminUsersControllerProvider.notifier);
      try {
        await notifier.changeRole(userId: user.id, role: role);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user.fullName} now has ${role.label} role')),
        );
      } on DomainError catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to change role: $error')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to change role: $error')),
        );
      }
    }

    Future<void> handleStatusChange(bool isActive) async {
      final notifier = ref.read(adminUsersControllerProvider.notifier);
      try {
        await notifier.toggleActive(userId: user.id, isActive: isActive);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isActive
                  ? '${user.fullName} reactivated'
                  : '${user.fullName} deactivated',
            ),
          ),
        );
      } on DomainError catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update status: $error')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update status: $error')),
        );
      }
    }

    Future<void> resendInvite() async {
      final notifier = ref.read(adminUsersControllerProvider.notifier);
      try {
        await notifier.invite(email: user.email, role: user.role);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invite resent to ${user.email}')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to resend invite: $error')),
        );
      }
    }

    Future<void> editDetails() async {
      final payload = await showGlassDialog<_UserDetailsPayload>(
        context: context,
        builder: (context) => _UserDetailsDialog(user: user),
      );
      if (payload == null) return;

      final notifier = ref.read(adminUsersControllerProvider.notifier);
      try {
        await notifier.updateDetails(
          userId: user.id,
          fullName: payload.fullName,
          phone: payload.phone,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated ${payload.fullName}')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update user: $error')),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName.isEmpty ? 'Unnamed user' : user.fullName,
                  style: theme.textTheme.bodyLarge,
                ),
                if (user.fullName.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Awaiting profile completion',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                if (user.phone != null && user.phone!.isNotEmpty)
                  Text(
                    user.phone!,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              user.email,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<RoleType>(
              initialValue: user.role,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Role',
              ).copyWith(isDense: true),
              items: RoleType.values
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.label),
                    ),
                  )
                  .toList(),
              onChanged: (role) {
                if (role == null || role == user.role) return;
                handleRoleChange(role);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: _UserStatusToggle(
                isActive: user.isActive,
                onChanged: handleStatusChange,
              ),
            ),
          ),
          SizedBox(
            width: 132,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Resend invite',
                  icon: const Icon(Icons.mail_outline),
                  onPressed: resendInvite,
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Edit details',
                  icon: const Icon(Icons.edit_note_outlined),
                  onPressed: editDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserStatusToggle extends StatelessWidget {
  const _UserStatusToggle({
    required this.isActive,
    required this.onChanged,
  });

  final bool isActive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = isActive
        ? theme.colorScheme.primary.withValues(alpha: 0.12)
        : theme.colorScheme.surfaceContainerHigh;
    final borderColor = isActive
        ? theme.colorScheme.primary.withValues(alpha: 0.35)
        : theme.colorScheme.outlineVariant.withValues(alpha: 0.4);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.pause_circle_outline,
                size: 18,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(width: 6),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(
          value: isActive,
          onChanged: onChanged,
        ),
      ],
    );
  }
}


class _AutoProvisionBanner extends StatelessWidget {
  const _AutoProvisionBanner({required this.incompleteCount});

  final int incompleteCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceM),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profiles auto-provisioned',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'New invites automatically create a profile skeleton. '
                    '$incompleteCount user${incompleteCount == 1 ? '' : 's'} still need name/contact details.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailsDialog extends StatefulWidget {
  const _UserDetailsDialog({required this.user});

  final UserAccount user;

  @override
  State<_UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<_UserDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: const Text('Edit user details'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassInput.textForm(
                context: context,
                controller: _nameController,
                label: 'Full name *',
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return 'Enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              GlassInput.textForm(
                context: context,
                controller: _phoneController,
                label: 'Mobile number',
                hint: 'e.g. 0821234567',
                keyboardType: TextInputType.phone,
              ),
            ],
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
              _UserDetailsPayload(
                fullName: _nameController.text.trim(),
                phone: _phoneController.text.trim().isEmpty
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

class _UserDetailsPayload {
  _UserDetailsPayload({
    required this.fullName,
    this.phone,
  });

  final String fullName;
  final String? phone;
}

class _InviteDialog extends StatefulWidget {
  const _InviteDialog();

  @override
  State<_InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<_InviteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  RoleType _role = RoleType.claimAgent;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: const Text('Invite user'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send a magic link invite. The user will complete their profile on first sign-in.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            GlassInput.textForm(
              context: context,
              controller: _emailController,
              label: 'Work email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Email is required';
                }
                if (!trimmed.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RoleType>(
              decoration: GlassInput.decoration(
                context: context,
                label: 'Role',
              ),
              initialValue: _role,
              items: RoleType.values
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _role = value);
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
              _InvitePayload(
                email: _emailController.text.trim(),
                role: _role,
              ),
            );
          },
          child: const Text('Send invite'),
        ),
      ],
    );
  }
}

class _InvitePayload {
  _InvitePayload({required this.email, required this.role});

  final String email;
  final RoleType role;
}

