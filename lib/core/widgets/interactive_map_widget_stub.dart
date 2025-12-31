import 'package:flutter/material.dart';

/// An interactive Google Map widget (non-web stub).
/// 
/// Displays a placeholder on non-web platforms.
/// Supports clicking on the map to set coordinates and displaying markers.
class InteractiveMapWidget extends StatefulWidget {
  const InteractiveMapWidget({
    this.latitude,
    this.longitude,
    this.onCoordinateSelected,
    this.height = 300,
    this.zoom = 16,
    super.key,
  });

  /// The latitude to center the map on
  final double? latitude;

  /// The longitude to center the map on
  final double? longitude;

  /// Callback when user clicks on the map or marker is dragged
  final void Function(double lat, double lng)? onCoordinateSelected;

  /// Height of the map widget
  final double height;

  /// Initial zoom level
  final int zoom;

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Map not available on this platform',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

