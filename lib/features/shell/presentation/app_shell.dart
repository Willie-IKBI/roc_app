import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/logging/logger.dart';
import '../../../core/providers/current_user_provider.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/theme_preference_provider.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_top_nav_bar.dart';
import '../../../data/clients/supabase_client.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.role, required this.child, super.key});

  final String role;
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final state = GoRouterState.of(context);
    final location = state.uri.path;
    final navItems = _navItemsForRole(widget.role);
    final bottomItems = navItems.where((item) => !item.adminOnly).toList();
    final drawerItems = navItems.where((item) => item.adminOnly).toList();

    Future<void> signOut() async {
      final client = ref.read(supabaseClientProvider);
      final container = ref.container;
      final messenger = ScaffoldMessenger.of(context);
      try {
        // Clear session expiration flag before signing out (manual logout)
        ref.read(sessionExpirationReasonProvider.notifier).setExpired(false);
        await client.auth.signOut();
        container.invalidate(currentUserProvider);
        if (!context.mounted) return;
        router.go('/login');
      } catch (error) {
        if (!context.mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('${AppStrings.signOutFailed}: $error')),
        );
      }
    }

    void goTo(String route) {
      if (location == route) {
        return;
      }
      router.go(route);
    }

    final canCapture = widget.role == 'agent' || widget.role == 'admin';
    final theme = Theme.of(context);
    final backgroundColor = DesignTokens.canvas(theme.brightness);
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    // Convert nav items to top nav tabs (only non-admin items for main nav)
    final topNavTabs = bottomItems.map((item) => GlassTopNavTab(
          label: item.label,
          route: item.route,
          matchPrefixes: item.matchPrefixes,
        )).toList();

    // Get user initials for profile icon
    String? profileInitials;
    if (currentUser != null && currentUser.fullName.isNotEmpty) {
      final names = currentUser.fullName.trim().split(' ');
      if (names.length >= 2) {
        profileInitials = '${names[0][0]}${names[names.length - 1][0]}';
      } else if (names.isNotEmpty) {
        profileInitials = names[0][0];
      }
    }

    void handleSearch(String query) {
      // TODO: Implement search functionality
      // For now, navigate to claims with search query
      if (query.isNotEmpty) {
        router.go('/claims?search=$query');
      }
    }

    void handleNotificationTap() {
      // TODO: Implement notification panel
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications coming soon')),
      );
    }

    void handleProfileTap() {
      // Show profile menu using PopupMenuButton approach
      final themePreference = ref.watch(themePreferenceProvider);
      final currentTheme = themePreference.when(
        data: (mode) => mode,
        loading: () => ThemeMode.dark,
        error: (_, __) => ThemeMode.dark,
      );
      final isDark = currentTheme == ThemeMode.dark;

      showMenu<_ShellMenuAction>(
        context: context,
        position: RelativeRect.fromLTRB(
          MediaQuery.of(context).size.width - 200,
          80,
          20,
          MediaQuery.of(context).size.height - 200,
        ),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.95),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        items: [
          PopupMenuItem(
            value: _ShellMenuAction.profile,
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.profile,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ShellMenuAction.theme,
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.themeToggle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ShellMenuAction.signOut,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.signOut,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).then((action) {
        if (action != null) {
          switch (action) {
            case _ShellMenuAction.profile:
              goTo('/profile');
              break;
            case _ShellMenuAction.theme:
              unawaited(ref.read(themePreferenceProvider.notifier).toggle());
              break;
            case _ShellMenuAction.signOut:
              unawaited(signOut());
              break;
          }
        }
      });
    }

    final body = SafeArea(
      top: false,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Top navigation bar
          GlassTopNavBar(
            tabs: topNavTabs,
            selectedRoute: location,
            onTabSelected: goTo,
            onSearchChanged: handleSearch,
            hasNotifications: false, // TODO: Implement notification tracking
            onNotificationTap: handleNotificationTap,
            onProfileTap: handleProfileTap,
            profileInitials: profileInitials,
          ),
          // Capture button (if applicable)
          if (canCapture)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceL,
                vertical: DesignTokens.spaceM,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GlassButton.primary(
                  onPressed: () => goTo('/claims/new'),
                  semanticLabel: AppStrings.captureClaim,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        semanticLabel: AppStrings.captureClaim,
                      ),
                      const SizedBox(width: DesignTokens.spaceS),
                      const Text(AppStrings.captureClaim),
                    ],
                  ),
                ),
              ),
            ),
          // Admin drawer button (if applicable)
          if (drawerItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceL,
                vertical: DesignTokens.spaceS,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GlassButton.outlined(
                  onPressed: () {
                    AppLogger.debug(
                      'Admin button clicked. Drawer items: ${drawerItems.length}',
                      name: 'AppShell',
                    );
                    try {
                      final scaffoldState = _scaffoldKey.currentState;
                      if (scaffoldState != null) {
                        scaffoldState.openEndDrawer();
                        AppLogger.debug(
                          'Admin drawer opened successfully',
                          name: 'AppShell',
                        );
                      } else {
                        AppLogger.warn(
                          'Scaffold state is null, trying context fallback',
                          name: 'AppShell',
                        );
                        // Fallback: try using context if GlobalKey fails
                        Scaffold.of(context).openEndDrawer();
                      }
                    } catch (e, stackTrace) {
                      AppLogger.error(
                        'Failed to open admin drawer',
                        name: 'AppShell',
                        error: e,
                        stackTrace: stackTrace,
                      );
                    }
                  },
                  semanticLabel: 'Open admin menu',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_outlined,
                        semanticLabel: 'Admin',
                      ),
                      const SizedBox(width: DesignTokens.spaceS),
                      const Text('Admin'),
                    ],
                  ),
                ),
              ),
            ),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              child: body,
            ),
          ),
        ],
      ),
      endDrawer: drawerItems.isNotEmpty
          ? NavigationDrawer(
              onDestinationSelected: (index) {
                if (index < 0 || index >= drawerItems.length) {
                  AppLogger.warn(
                    'Invalid drawer index: $index (drawerItems.length: ${drawerItems.length})',
                    name: 'AppShell',
                  );
                  return;
                }
                final item = drawerItems[index];
                AppLogger.debug(
                  'Admin drawer item selected: ${item.label} -> ${item.route}',
                  name: 'AppShell',
                );
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
                    icon: Icon(item.icon, semanticLabel: item.label),
                    label: Text(item.label),
                    selectedIcon: Icon(
                      item.selectedIcon ?? item.icon,
                      semanticLabel: item.label,
                    ),
                  ),
              ],
            )
          : null,
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
        label: 'Map',
        route: '/claims/map',
        icon: Icons.map_outlined,
        selectedIcon: Icons.map,
        matchPrefixes: ['/claims/map'],
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

enum _ShellMenuAction { profile, theme, signOut }

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
      decoration: BoxDecoration(
        color: theme.colorScheme.inverseSurface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: const Offset(1, 0),
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
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              Icons.shield_moon_outlined,
              color: theme.colorScheme.onInverseSurface,
              size: 30,
              semanticLabel: 'Repair on Call logo',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ROC',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onInverseSurface,
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
                      color: theme.colorScheme.onInverseSurface.withValues(alpha: 0.08),
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
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.46),
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
        ? theme.colorScheme.onInverseSurface
        : theme.colorScheme.onInverseSurface.withValues(alpha: 0.65);
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
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.6)
                    : theme.colorScheme.onInverseSurface.withValues(alpha: 0.14),
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
                semanticLabel: entry.item.label,
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
