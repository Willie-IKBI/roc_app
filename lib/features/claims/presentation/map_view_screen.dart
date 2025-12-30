import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glass_empty_state.dart';
import '../../../core/widgets/glass_error_state.dart';
import '../../../core/widgets/glass_dialog.dart';
import '../../../core/widgets/glass_button.dart';
import '../../../core/widgets/glass_input.dart';
import '../../../domain/value_objects/claim_enums.dart';
import '../../claims/controller/map_view_controller.dart';
import '../../claims/controller/technician_controller.dart';
import 'widgets/interactive_claims_map_widget.dart';

class MapViewScreen extends ConsumerStatefulWidget {
  const MapViewScreen({super.key});

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  ClaimStatus? _statusFilter;
  String? _technicianFilter;
  bool _useInteractiveMap = true; // Toggle for interactive vs static map

  Color _statusColor(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.newClaim:
        return const Color(0xFFFF0000); // Red
      case ClaimStatus.inContact:
        return const Color(0xFFFF9800); // Orange
      case ClaimStatus.scheduled:
        return const Color(0xFFFFEB3B); // Yellow
      case ClaimStatus.workInProgress:
        return const Color(0xFF2196F3); // Blue
      case ClaimStatus.awaitingClient:
        return const Color(0xFF9C27B0); // Purple
      case ClaimStatus.onHold:
        return const Color(0xFF9E9E9E); // Gray
      case ClaimStatus.closed:
      case ClaimStatus.cancelled:
        return const Color(0xFF4CAF50); // Green
    }
  }

  IconData _statusIcon(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.newClaim:
        return Icons.add_circle_outline;
      case ClaimStatus.inContact:
        return Icons.phone_outlined;
      case ClaimStatus.scheduled:
        return Icons.schedule_outlined;
      case ClaimStatus.workInProgress:
        return Icons.build_outlined;
      case ClaimStatus.awaitingClient:
        return Icons.person_outline;
      case ClaimStatus.onHold:
        return Icons.pause_circle_outline;
      case ClaimStatus.closed:
        return Icons.check_circle_outline;
      case ClaimStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _buildMapUrl(List<ClaimMapMarker> markers) {
    if (markers.isEmpty || Env.googleMapsApiKey.isEmpty) {
      return '';
    }

    // Calculate center of South Africa (approximate)
    final centerLat = -29.0;
    final centerLng = 24.0;

    // Build markers parameter
    final markersParam = markers.map((marker) {
      final colorHex = _statusColor(marker.status).value.toRadixString(16).substring(2, 8);
      return 'color:0x$colorHex|label:${marker.claimNumber.substring(0, 1).toUpperCase()}|${marker.latitude},${marker.longitude}';
    }).join('&markers=');

    final uri = Uri.https('maps.googleapis.com', '/maps/api/staticmap', {
      'center': '$centerLat,$centerLng',
      'zoom': '6', // Zoom level to show all of South Africa
      'size': '1200x800',
      'scale': '2',
      'maptype': 'roadmap',
      'markers': markersParam,
      'key': Env.googleMapsApiKey,
    });

    return uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final markersAsync = ref.watch(
      claimMapMarkersProvider(
        statusFilter: _statusFilter,
        technicianId: _technicianFilter,
      ),
    );
    final techniciansAsync = ref.watch(techniciansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('South Africa Map View'),
        actions: [
          GlassButton.ghost(
            onPressed: () => _showFiltersDialog(context),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spaceS,
              vertical: DesignTokens.spaceXS,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list, size: 20),
                SizedBox(width: DesignTokens.spaceXS),
                Text('Filters'),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spaceS),
        ],
      ),
      body: markersAsync.when(
        data: (markers) {
          if (markers.isEmpty) {
            return const GlassEmptyState(
              title: 'No claims to display',
              description: 'No open claims with valid addresses found.',
              icon: Icons.map_outlined,
            );
          }

          final mapUrl = _buildMapUrl(markers);

          return Column(
            children: [
              // Filters bar
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: (_statusFilter != null || _technicianFilter != null)
                    ? GlassCard(
                        key: ValueKey('${_statusFilter}_${_technicianFilter}'),
                        margin: const EdgeInsets.all(DesignTokens.spaceM),
                        padding: const EdgeInsets.all(DesignTokens.spaceM),
                        child: Wrap(
                          spacing: DesignTokens.spaceM,
                          runSpacing: DesignTokens.spaceS,
                          children: [
                            if (_statusFilter != null)
                              GlassCard(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignTokens.spaceS,
                                  vertical: DesignTokens.spaceXS,
                                ),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _statusIcon(_statusFilter!),
                                      size: 16,
                                      color: _statusColor(_statusFilter!),
                                    ),
                                    const SizedBox(width: DesignTokens.spaceXS),
                                    Text(
                                      _statusFilter!.label,
                                      style: theme.textTheme.labelMedium,
                                    ),
                                    const SizedBox(width: DesignTokens.spaceXS),
                                    InkWell(
                                      onTap: () {
                                        setState(() => _statusFilter = null);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_technicianFilter != null)
                              techniciansAsync.when(
                                data: (technicians) {
                                  final tech = technicians.firstWhere(
                                    (t) => t.id == _technicianFilter,
                                    orElse: () => technicians.first,
                                  );
                                  return GlassCard(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DesignTokens.spaceS,
                                      vertical: DesignTokens.spaceXS,
                                    ),
                                    borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 16,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: DesignTokens.spaceXS),
                                        Text(
                                          tech.fullName,
                                          style: theme.textTheme.labelMedium,
                                        ),
                                        const SizedBox(width: DesignTokens.spaceXS),
                                        InkWell(
                                          onTap: () {
                                            setState(() => _technicianFilter = null);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Map
              Expanded(
                child: Stack(
                  children: [
                    // Interactive or static map
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(DesignTokens.spaceM),
                        child: _useInteractiveMap && Env.googleMapsApiKey.isNotEmpty
                            ? GlassCard(
                                padding: EdgeInsets.zero,
                                child: InteractiveClaimsMapWidget(
                                  markers: markers,
                                  onMarkerClick: (claimId) {
                                    context.push('/claims/$claimId');
                                  },
                                  height: double.infinity,
                                  initialZoom: 6,
                                  initialCenterLat: -29.0,
                                  initialCenterLng: 24.0,
                                ),
                              )
                            : mapUrl.isNotEmpty
                                ? GlassCard(
                                    padding: EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                                      child: Image.network(
                                        mapUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: progress.expectedTotalBytes != null
                                                  ? progress.cumulativeBytesLoaded /
                                                      progress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return GlassErrorState(
                                            title: 'Error loading map',
                                            message: 'Unable to load map image. Check Google Maps API key configuration.',
                                            icon: Icons.map_outlined,
                                            onRetry: () {
                                              ref.invalidate(
                                                claimMapMarkersProvider(
                                                  statusFilter: _statusFilter,
                                                  technicianId: _technicianFilter,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : GlassCard(
                                    child: const Center(
                                      child: Text('Map unavailable'),
                                    ),
                                  ),
                      ),
                    ),
                    // Legend
                    Positioned(
                      top: DesignTokens.spaceL,
                      right: DesignTokens.spaceL,
                      child: GlassCard(
                        padding: const EdgeInsets.all(DesignTokens.spaceM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: DesignTokens.spaceXS),
                                Text(
                                  'Status Colors',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: DesignTokens.spaceM),
                            ...ClaimStatus.values
                                .where((s) =>
                                    s != ClaimStatus.closed &&
                                    s != ClaimStatus.cancelled)
                                .map((status) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: DesignTokens.spaceS,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: _statusColor(status),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.3),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: DesignTokens.spaceS),
                                          Text(
                                            status.label,
                                            style: theme.textTheme.labelMedium,
                                          ),
                                        ],
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Claims list
              SizedBox(
                height: 250,
                child: GlassCard(
                  margin: const EdgeInsets.all(DesignTokens.spaceM),
                  padding: const EdgeInsets.all(DesignTokens.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_outlined,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: DesignTokens.spaceS),
                          Text(
                            'Claims (${markers.length})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spaceM),
                      Expanded(
                        child: markers.isEmpty
                            ? Center(
                                child: Text(
                                  'No claims match current filters',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: markers.length,
                                separatorBuilder: (context, index) => const SizedBox(height: DesignTokens.spaceXS),
                                itemBuilder: (context, index) {
                                  final marker = markers[index];
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => context.push('/claims/${marker.claimId}'),
                                      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                                      child: GlassCard(
                                        padding: const EdgeInsets.all(DesignTokens.spaceM),
                                        margin: EdgeInsets.zero,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: _statusColor(marker.status),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white.withValues(alpha: 0.3),
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: DesignTokens.spaceM),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    marker.claimNumber,
                                                    style: theme.textTheme.titleSmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: DesignTokens.spaceXS),
                                                  Text(
                                                    [
                                                      marker.clientName,
                                                      marker.address,
                                                      marker.technicianName,
                                                    ]
                                                        .where((s) => s != null && s.isNotEmpty)
                                                        .join(' • '),
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      color: theme.colorScheme.onSurfaceVariant,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: DesignTokens.spaceS),
                                            Chip(
                                              label: Text(
                                                marker.status.label,
                                                style: theme.textTheme.labelSmall,
                                              ),
                                              padding: EdgeInsets.zero,
                                              visualDensity: VisualDensity.compact,
                                              backgroundColor: _statusColor(marker.status).withValues(alpha: 0.2),
                                              side: BorderSide(
                                                color: _statusColor(marker.status).withValues(alpha: 0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => GlassErrorState(
          title: 'Error loading map data',
          message: error.toString(),
          onRetry: () {
            ref.invalidate(
              claimMapMarkersProvider(
                statusFilter: _statusFilter,
                technicianId: _technicianFilter,
              ),
            );
          },
          icon: Icons.map_outlined,
        ),
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showGlassDialog(
      context: context,
      builder: (context) => GlassDialog(
        title: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: DesignTokens.spaceS),
            const Text('Filter Map'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<ClaimStatus?>(
              value: _statusFilter,
              decoration: GlassInput.decoration(
                context: context,
                label: 'Status',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All statuses'),
                ),
                ...ClaimStatus.values
                    .where((s) =>
                        s != ClaimStatus.closed && s != ClaimStatus.cancelled)
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Row(
                            children: [
                              Icon(
                                _statusIcon(status),
                                size: 18,
                                color: _statusColor(status),
                              ),
                              const SizedBox(width: DesignTokens.spaceS),
                              Text(status.label),
                            ],
                          ),
                        )),
              ],
              onChanged: (value) {
                setState(() => _statusFilter = value);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: DesignTokens.spaceM),
            Consumer(
              builder: (context, ref, _) {
                final techniciansAsync = ref.watch(techniciansProvider);
                return techniciansAsync.when(
                  data: (technicians) => DropdownButtonFormField<String?>(
                    value: _technicianFilter,
                    decoration: GlassInput.decoration(
                      context: context,
                      label: 'Technician',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All technicians'),
                      ),
                      ...technicians.map((tech) => DropdownMenuItem(
                            value: tech.id,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 18,
                                ),
                                const SizedBox(width: DesignTokens.spaceS),
                                Text(tech.fullName),
                              ],
                            ),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() => _technicianFilter = value);
                      Navigator.pop(context);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Error loading technicians'),
                );
              },
            ),
          ],
        ),
        actions: [
          GlassButton.ghost(
            onPressed: () {
              setState(() {
                _statusFilter = null;
                _technicianFilter = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear filters'),
          ),
          GlassButton.primary(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

