import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/claim_map_marker.dart';

/// An interactive Google Map widget for displaying multiple claim markers (non-web stub).
/// 
/// Displays a placeholder on non-web platforms.
/// Supports zoom, pan, and clickable markers that navigate to claim details.
class InteractiveClaimsMapWidget extends StatefulWidget {
  const InteractiveClaimsMapWidget({
    required this.markers,
    this.onMarkerClick,
    this.height = 600,
    this.initialZoom = 6,
    this.initialCenterLat = -29.0,
    this.initialCenterLng = 24.0,
    super.key,
  });

  /// List of claim markers to display on the map
  final List<ClaimMapMarker> markers;

  /// Callback when a marker is clicked
  final void Function(String claimId)? onMarkerClick;

  /// Height of the map widget
  final double height;

  /// Initial zoom level
  final int initialZoom;

  /// Initial center latitude (default: South Africa)
  final double initialCenterLat;

  /// Initial center longitude (default: South Africa)
  final double initialCenterLng;

  @override
  State<InteractiveClaimsMapWidget> createState() => _InteractiveClaimsMapWidgetState();
}

class _InteractiveClaimsMapWidgetState extends State<InteractiveClaimsMapWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height == double.infinity ? null : widget.height,
      width: double.infinity,
      child: Container(
        color: DesignTokens.glassBase(Theme.of(context).brightness),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                size: 48,
                color: DesignTokens.textSecondary(Theme.of(context).brightness),
              ),
              const SizedBox(height: 16),
              Text(
                'Interactive map not available on this platform',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textSecondary(Theme.of(context).brightness),
                ),
              ),
              if (widget.markers.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${widget.markers.length} marker${widget.markers.length == 1 ? '' : 's'} would be displayed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DesignTokens.textSecondary(Theme.of(context).brightness),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

