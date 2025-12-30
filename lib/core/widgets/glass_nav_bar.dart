import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A floating glassmorphism navigation bar with pill-shaped tabs.
/// 
/// Creates a detached navigation bar with backdrop blur and rounded corners.
/// Tabs are pill-shaped with active state highlighting.
/// 
/// Example:
/// ```dart
/// GlassNavBar(
///   items: [
///     GlassNavItem(icon: Icons.home, label: 'Home'),
///     GlassNavItem(icon: Icons.list, label: 'Claims'),
///   ],
///   selectedIndex: 0,
///   onTap: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.margin,
    super.key,
  });

  /// Navigation items to display.
  final List<GlassNavItem> items;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int> onTap;

  /// Margin around the navigation bar.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceM,
            vertical: DesignTokens.spaceS,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        border: Border.all(
          color: DesignTokens.borderSubtle(brightness),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: DesignTokens.blurLarge,
            sigmaY: DesignTokens.blurLarge,
          ),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spaceXS),
            decoration: BoxDecoration(
              color: DesignTokens.glassBase(brightness),
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                items.length,
                (index) => _NavBarItem(
                  item: items[index],
                  isSelected: index == selectedIndex,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final GlassNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Expanded(
      child: Semantics(
        label: item.semanticLabel ?? item.label,
        button: true,
        selected: isSelected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
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
                borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isSelected
                        ? DesignTokens.textPrimary(brightness)
                        : DesignTokens.textSecondary(brightness),
                    semanticLabel: item.semanticLabel ?? item.label,
                  ),
                  if (item.label.isNotEmpty) ...[
                    const SizedBox(width: DesignTokens.spaceS),
                    Text(
                      item.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? DesignTokens.textPrimary(brightness)
                            : DesignTokens.textSecondary(brightness),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A navigation item for GlassNavBar.
class GlassNavItem {
  const GlassNavItem({
    required this.icon,
    this.label = '',
    this.semanticLabel,
  });

  final IconData icon;
  final String label;
  final String? semanticLabel;
}

