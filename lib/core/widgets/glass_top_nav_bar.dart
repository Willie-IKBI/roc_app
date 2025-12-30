import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A top horizontal navigation bar with glassmorphism styling.
/// 
/// Features horizontal tabs, search bar, notification bell, and profile icon.
/// Matches the reference design with selected tabs showing white text on dark
/// background with red dot indicator, and unselected tabs showing light gray text.
/// 
/// Example:
/// ```dart
/// GlassTopNavBar(
///   tabs: [
///     GlassTopNavTab(label: 'Dashboard', route: '/dashboard'),
///     GlassTopNavTab(label: 'Claims', route: '/claims'),
///   ],
///   selectedRoute: '/dashboard',
///   onTabSelected: (route) => navigate(route),
///   onSearchChanged: (query) => search(query),
///   hasNotifications: true,
///   onNotificationTap: () => showNotifications(),
///   onProfileTap: () => showProfileMenu(),
/// )
/// ```
class GlassTopNavBar extends StatelessWidget {
  const GlassTopNavBar({
    required this.tabs,
    required this.selectedRoute,
    required this.onTabSelected,
    this.onSearchChanged,
    this.searchPlaceholder = 'Search claims...',
    this.hasNotifications = false,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileIcon,
    this.profileInitials,
    super.key,
  });

  /// Navigation tabs to display.
  final List<GlassTopNavTab> tabs;

  /// Currently selected route.
  final String selectedRoute;

  /// Callback when a tab is selected.
  final ValueChanged<String> onTabSelected;

  /// Callback when search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Search bar placeholder text.
  final String searchPlaceholder;

  /// Whether there are unread notifications.
  final bool hasNotifications;

  /// Callback when notification bell is tapped.
  final VoidCallback? onNotificationTap;

  /// Callback when profile icon is tapped.
  final VoidCallback? onProfileTap;

  /// Custom profile icon. If null, uses default person icon.
  final IconData? profileIcon;

  /// Profile initials to display. If provided, shows initials instead of icon.
  final String? profileInitials;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceL,
          vertical: DesignTokens.spaceM,
        ),
        decoration: BoxDecoration(
          color: DesignTokens.glassBase(brightness).withValues(alpha: 0.6),
          border: Border(
            bottom: BorderSide(
              color: DesignTokens.borderSubtle(brightness),
              width: 1,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.blurMedium,
            sigmaY: DesignTokens.blurMedium,
          ),
          child: Row(
            children: [
              // Navigation tabs
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final tab in tabs)
                        _NavTab(
                          tab: tab,
                          isSelected: _isTabSelected(tab, selectedRoute),
                          onTap: () => onTabSelected(tab.route),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spaceL),
              // Search bar
              if (onSearchChanged != null)
                _SearchBar(
                  placeholder: searchPlaceholder,
                  onChanged: onSearchChanged!,
                ),
              if (onSearchChanged != null)
                const SizedBox(width: DesignTokens.spaceM),
              // Notification bell
              if (onNotificationTap != null)
                _NotificationBell(
                  hasNotifications: hasNotifications,
                  onTap: onNotificationTap!,
                ),
              if (onNotificationTap != null)
                const SizedBox(width: DesignTokens.spaceM),
              // Profile icon
              if (onProfileTap != null)
                _ProfileIcon(
                  icon: profileIcon,
                  initials: profileInitials,
                  onTap: onProfileTap!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isTabSelected(GlassTopNavTab tab, String currentRoute) {
    if (currentRoute == tab.route) return true;
    return tab.matchPrefixes.any((prefix) => currentRoute.startsWith(prefix));
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final GlassTopNavTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.spaceS),
      child: Semantics(
        label: tab.semanticLabel ?? tab.label,
        button: true,
        selected: isSelected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceM,
                vertical: DesignTokens.spaceS,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? DesignTokens.glassActive(brightness)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                border: isSelected
                    ? Border.all(
                        color: DesignTokens.primaryRed.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Red dot indicator for selected tab
                  if (isSelected) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: DesignTokens.primaryRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                  ],
                  Text(
                    tab.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? DesignTokens.textPrimary(brightness)
                          : DesignTokens.textSecondary(brightness),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.placeholder,
    required this.onChanged,
  });

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Container(
      width: 280,
      height: 40,
      decoration: BoxDecoration(
        color: DesignTokens.glassBase(brightness),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(
          color: DesignTokens.borderSubtle(brightness),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.blurSmall,
            sigmaY: DesignTokens.blurSmall,
          ),
          child: TextField(
            onChanged: onChanged,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: DesignTokens.textPrimary(brightness),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: DesignTokens.textTertiary(brightness),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: DesignTokens.textSecondary(brightness),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceM,
                vertical: DesignTokens.spaceS,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({
    required this.hasNotifications,
    required this.onTap,
  });

  final bool hasNotifications;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Semantics(
      label: 'Notifications${hasNotifications ? ' (unread)' : ''}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: DesignTokens.glassBase(brightness),
              shape: BoxShape.circle,
              border: Border.all(
                color: DesignTokens.borderSubtle(brightness),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: DesignTokens.blurSmall,
                  sigmaY: DesignTokens.blurSmall,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: DesignTokens.textPrimary(brightness),
                    ),
                    if (hasNotifications)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: DesignTokens.primaryRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({
    this.icon,
    this.initials,
    required this.onTap,
  });

  final IconData? icon;
  final String? initials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Semantics(
      label: 'Profile menu',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: DesignTokens.glassBase(brightness),
              shape: BoxShape.circle,
              border: Border.all(
                color: DesignTokens.borderSubtle(brightness),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: DesignTokens.blurSmall,
                  sigmaY: DesignTokens.blurSmall,
                ),
                child: (initials?.isNotEmpty ?? false)
                    ? Center(
                        child: Text(
                          initials!.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: DesignTokens.textPrimary(brightness),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Icon(
                        icon ?? Icons.person_outline,
                        size: 20,
                        color: DesignTokens.textPrimary(brightness),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A navigation tab for GlassTopNavBar.
class GlassTopNavTab {
  const GlassTopNavTab({
    required this.label,
    required this.route,
    this.matchPrefixes = const [],
    this.semanticLabel,
  });

  /// Tab label text.
  final String label;

  /// Route to navigate to when tab is selected.
  final String route;

  /// Route prefixes that should match this tab (for nested routes).
  final List<String> matchPrefixes;

  /// Semantic label for accessibility.
  final String? semanticLabel;
}

