import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import 'glass_button.dart';
import 'glass_card.dart';

/// A glassmorphism-styled dialog wrapper.
/// 
/// Provides consistent glass styling for all dialogs in the app.
/// Wraps AlertDialog with glass card styling and backdrop blur.
/// 
/// Example:
/// ```dart
/// showGlassDialog(
///   context: context,
///   builder: (context) => GlassDialog(
///     title: 'Confirm action',
///     content: Text('Are you sure?'),
///     actions: [
///       GlassButton.ghost(
///         onPressed: () => Navigator.of(context).pop(),
///         child: const Text('Cancel'),
///       ),
///       GlassButton.primary(
///         onPressed: () => Navigator.of(context).pop(true),
///         child: const Text('Confirm'),
///       ),
///     ],
///   ),
/// );
/// ```
class GlassDialog extends StatelessWidget {
  const GlassDialog({
    this.title,
    this.content,
    this.actions,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.actionsOverflowDirection,
    this.actionsAlignment,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.icon,
    this.iconPadding,
    this.iconColor,
    this.titleTextStyle,
    this.contentTextStyle,
    this.semanticLabel,
    this.clipBehavior = Clip.none,
    this.shape,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
    super.key,
  });

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  final Widget? title;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog with an [OverflowBar].
  final List<Widget>? actions;

  /// Padding around the title.
  final EdgeInsetsGeometry? titlePadding;

  /// Padding around the content.
  final EdgeInsetsGeometry? contentPadding;

  /// Padding around the set of actions at the bottom of the dialog.
  final EdgeInsetsGeometry? actionsPadding;

  /// The direction in which the actions overflow.
  final VerticalDirection? actionsOverflowDirection;

  /// The alignment of the actions.
  final MainAxisAlignment? actionsAlignment;

  /// The spacing between buttons when the actions overflow.
  final double? actionsOverflowButtonSpacing;

  /// The padding that surrounds each button in the actions.
  final EdgeInsetsGeometry? buttonPadding;

  /// The (optional) icon to display at the top of the dialog.
  final Widget? icon;

  /// The padding around the icon.
  final EdgeInsetsGeometry? iconPadding;

  /// The color of the icon.
  final Color? iconColor;

  /// The style for the title of this dialog.
  final TextStyle? titleTextStyle;

  /// The style for the content of this dialog.
  final TextStyle? contentTextStyle;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen changes when the dialog is opened.
  final String? semanticLabel;

  /// {@macro flutter.material.Material.clipBehavior}
  final Clip clipBehavior;

  /// The shape of this dialog's border.
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.color}
  final Color? backgroundColor;

  /// {@macro flutter.material.Material.elevation}
  final double? elevation;

  /// {@macro flutter.material.Material.shadowColor}
  final Color? shadowColor;

  /// {@macro flutter.material.Material.surfaceTintColor}
  final Color? surfaceTintColor;

  /// The padding that is inserted around the dialog.
  final EdgeInsets insetPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      titlePadding: titlePadding,
      contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(
        DesignTokens.spaceL,
        DesignTokens.spaceM,
        DesignTokens.spaceL,
        DesignTokens.spaceL,
      ),
      actionsPadding: actionsPadding ?? const EdgeInsets.all(DesignTokens.spaceM),
      actionsOverflowDirection: actionsOverflowDirection,
      actionsAlignment: actionsAlignment,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding,
      icon: icon,
      iconPadding: iconPadding,
      iconColor: iconColor,
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
      semanticLabel: semanticLabel,
      clipBehavior: clipBehavior,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
      ),
      backgroundColor: backgroundColor ?? DesignTokens.glassBase(brightness),
      elevation: elevation ?? 0,
      shadowColor: shadowColor ?? Colors.transparent,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      insetPadding: insetPadding,
    );
  }
}

/// Shows a glass-styled dialog.
/// 
/// Convenience function to show a GlassDialog with proper styling.
Future<T?> showGlassDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final theme = Theme.of(context);
  final brightness = theme.brightness;

  return showDialog<T>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: builder(context),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

