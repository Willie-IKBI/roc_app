import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/current_user_provider.dart';
import '../../../data/clients/supabase_client.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.role, required this.child, super.key});

  final String role;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final state = GoRouterState.of(context);
    final location = state.uri.path;
    final navItems = _navItemsForRole(role);
    final bottomItems = navItems.where((item) => !item.adminOnly).toList();
    final drawerItems = navItems.where((item) => item.adminOnly).toList();
    final matchIndex = navItems.indexWhere((item) => item.matches(location));
    final selectedIndex = matchIndex == -1 ? 0 : matchIndex;
    final selectedItem = navItems[selectedIndex];

    Future<void> signOut() async {
      final client = ref.read(supabaseClientProvider);
      final container = ref.container;
      final messenger = ScaffoldMessenger.of(context);
      try {
        await client.auth.signOut();
        container.invalidate(currentUserProvider);
        if (!context.mounted) return;
        router.go('/login');
      } catch (error) {
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to sign out: $error')),
        );
      }
    }

    void goTo(String route) {
      if (location == route) {
        return;
      }
      router.go(route);
    }

    final canCapture = role == 'agent' || role == 'admin';

    const backgroundColor = Color(0xFFF5F6F8);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 1024;
        final showDrawer = drawerItems.isNotEmpty;
        final body = SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
        );

        final captureButton = canCapture
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Capture claim'),
                  onPressed: () => goTo('/claims/new'),
                ),
              )
            : const SizedBox.shrink();

        final profileMenu = PopupMenuButton<_ShellMenuAction>(
          tooltip: 'Account',
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (action) {
            switch (action) {
              case _ShellMenuAction.profile:
                goTo('/profile');
                break;
              case _ShellMenuAction.signOut:
                unawaited(signOut());
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _ShellMenuAction.profile,
              child: Text('Profile'),
            ),
            const PopupMenuItem(
              value: _ShellMenuAction.signOut,
              child: Text('Sign out'),
            ),
          ],
        );

        if (useRail) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(selectedItem.label),
              actions: [
                if (canCapture) captureButton,
                profileMenu,
                const SizedBox(width: 8),
              ],
            ),
            body: Row(
              children: [
                _ConsoleNav(
                  items: navItems,
                  selectedIndex: selectedIndex,
                  onSelected: (index) => goTo(navItems[index].route),
                ),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(selectedItem.label),
            actions: [
              if (canCapture) captureButton,
              profileMenu,
              const SizedBox(width: 8),
            ],
          ),
          drawer: showDrawer
              ? NavigationDrawer(
                  onDestinationSelected: (index) {
                    final item = drawerItems[index];
                    Navigator.of(context).pop();
                    goTo(item.route);
                  },
                  selectedIndex: drawerItems.indexWhere(
                    (item) => item.matches(location),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Admin',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (final item in drawerItems)
                      NavigationDrawerDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                        selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      ),
                  ],
                )
              : null,
          body: body,
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            selectedIndex: bottomItems
                .indexWhere((item) => item.matches(location))
                .clamp(0, bottomItems.isEmpty ? 0 : bottomItems.length - 1),
            onDestinationSelected: (index) => goTo(bottomItems[index].route),
            destinations: [
              for (final item in bottomItems)
                NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon ?? item.icon),
                  label: item.label,
                ),
            ],
          ),
        );
      },
    );
  }

  static List<_NavItem> _navItemsForRole(String role) {
    final baseItems = <_NavItem>[
      const _NavItem(
        label: 'Dashboard',
        route: '/dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        matchPrefixes: ['/dashboard'],
      ),
      const _NavItem(
        label: 'Claims',
        route: '/claims',
        icon: Icons.assignment_outlined,
        selectedIcon: Icons.assignment,
        matchPrefixes: ['/claims'],
      ),
      const _NavItem(
        label: 'Reports',
        route: '/reports',
        icon: Icons.insights_outlined,
        selectedIcon: Icons.insights,
        matchPrefixes: ['/reports'],
      ),
      const _NavItem(
        label: 'Profile',
        route: '/profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        matchPrefixes: ['/profile'],
      ),
    ];

    if (role == 'admin') {
      return [
        ...baseItems,
        const _NavItem(
          label: 'Users',
          route: '/admin/users',
          icon: Icons.group_outlined,
          selectedIcon: Icons.group,
          matchPrefixes: ['/admin/users'],
          adminOnly: true,
        ),
        const _NavItem(
          label: 'Insurers',
          route: '/admin/insurers',
          icon: Icons.domain_outlined,
          selectedIcon: Icons.domain,
          matchPrefixes: ['/admin/insurers'],
          adminOnly: true,
        ),
        const _NavItem(
          label: 'Brands',
          route: '/admin/brands',
          icon: Icons.sell_outlined,
          selectedIcon: Icons.sell,
          matchPrefixes: ['/admin/brands'],
          adminOnly: true,
        ),
        const _NavItem(
          label: 'Providers',
          route: '/admin/service-providers',
          icon: Icons.storefront_outlined,
          selectedIcon: Icons.storefront,
          matchPrefixes: ['/admin/service-providers'],
          adminOnly: true,
        ),
        const _NavItem(
          label: 'Settings',
          route: '/admin/settings',
          icon: Icons.tune_outlined,
          selectedIcon: Icons.tune,
          matchPrefixes: ['/admin/settings'],
          adminOnly: true,
        ),
      ];
    }

    return baseItems;
  }
}

enum _ShellMenuAction { profile, signOut }

class _NavItem {
  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
    this.selectedIcon,
    this.matchPrefixes = const [],
    this.adminOnly = false,
  });

  final String label;
  final String route;
  final IconData icon;
  final IconData? selectedIcon;
  final List<String> matchPrefixes;
  final bool adminOnly;

  bool matches(String location) {
    if (location == route) {
      return true;
    }
    return matchPrefixes.any((prefix) => location.startsWith(prefix));
  }
}

class _ConsoleNav extends StatelessWidget {
  const _ConsoleNav({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = [
      for (var i = 0; i < items.length; i++)
        _NavEntry(index: i, item: items[i]),
    ];
    final coreEntries = entries
        .where((entry) => !entry.item.adminOnly)
        .toList(growable: false);
    final adminEntries = entries
        .where((entry) => entry.item.adminOnly)
        .toList(growable: false);

    return Container(
      width: 92,
      decoration: const BoxDecoration(
        color: Color(0xFF111317),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(1, 0),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.45),
              ),
            ),
            child: const Icon(
              Icons.shield_moon_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ROC',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ConsoleSection(
                    title: 'CORE',
                    entries: coreEntries,
                    selectedIndex: selectedIndex,
                    onSelected: onSelected,
                  ),
                  if (adminEntries.isNotEmpty) ...[
                    Divider(
                      height: 32,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    _ConsoleSection(
                      title: 'ADMIN',
                      entries: adminEntries,
                      selectedIndex: selectedIndex,
                      onSelected: onSelected,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ConsoleSection extends StatelessWidget {
  const _ConsoleSection({
    required this.title,
    required this.entries,
    required this.selectedIndex,
    required this.onSelected,
  });

  final String title;
  final List<_NavEntry> entries;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.46),
              letterSpacing: 1.1,
            ),
          ),
        ),
        for (final entry in entries)
          _ConsoleDestination(
            entry: entry,
            isSelected: selectedIndex == entry.index,
            onTap: () => onSelected(entry.index),
          ),
      ],
    );
  }
}

class _ConsoleDestination extends StatelessWidget {
  const _ConsoleDestination({
    required this.entry,
    required this.isSelected,
    required this.onTap,
  });

  final _NavEntry entry;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color iconColor = isSelected
        ? Colors.white
        : Colors.white.withValues(alpha: 0.65);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.redAccent.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? Colors.redAccent.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.14),
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected
                    ? (entry.item.selectedIcon ?? entry.item.icon)
                    : entry.item.icon,
                color: iconColor,
              ),
              const SizedBox(height: 6),
              Text(
                entry.item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: iconColor,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavEntry {
  _NavEntry({required this.index, required this.item});

  final int index;
  final _NavItem item;
}
