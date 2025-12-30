import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';

import '../../../../core/config/env.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/utils/places_web_service.dart';
import '../../../../domain/value_objects/claim_enums.dart';
import '../../controller/map_view_controller.dart';

@JS('rocMapsAPI')
external RocMapsAPI get rocMapsAPI;

@JS()
@anonymous
class RocMapsAPI {
  external bool isReady();
  external dynamic createMapWithMultipleMarkers(
    dynamic container,
    dynamic options,
    dynamic markers, // Can be JSON string or array
    dynamic onMarkerClick,
  );
  external void updateMarkers(dynamic mapInstance, dynamic markers); // Can be JSON string or array
}

/// An interactive Google Map widget for displaying multiple claim markers.
/// 
/// Displays a Google Map with multiple markers representing claims.
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
  html.DivElement? _mapContainer;
  dynamic _mapInstance;
  late final String _mapId;
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    _mapId = 'roc-claims-map-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void didUpdateWidget(InteractiveClaimsMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb && _mapInstance != null && _isMapInitialized) {
      // Update markers if they changed
      if (widget.markers.length != oldWidget.markers.length ||
          widget.markers.any((m) => !oldWidget.markers.contains(m))) {
        _updateMarkers();
      }
    }
  }

  @override
  void dispose() {
    // Clean up callback reference
    try {
      js.context.deleteProperty('rocMapMarkerClick_$_mapId');
    } catch (_) {
      // Ignore cleanup errors
    }
    _mapContainer = null;
    _mapInstance = null;
    super.dispose();
  }

  void _updateMarkers() {
    if (!kIsWeb || _mapInstance == null || !rocMapsAPI.isReady()) return;

    try {
      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Updating ${widget.markers.length} markers');
      }

      // Filter out markers with invalid coordinates
      final validMarkers = widget.markers.where((marker) {
        final isValid = marker.latitude.isFinite && 
                        marker.longitude.isFinite &&
                        !marker.latitude.isNaN &&
                        !marker.longitude.isNaN;
        if (!isValid && kDebugMode) {
          print('[InteractiveClaimsMapWidget] Filtering invalid marker during update: ${marker.claimNumber}, lat=${marker.latitude}, lng=${marker.longitude}');
        }
        return isValid;
      }).toList();

      if (kDebugMode) {
        final invalidCount = widget.markers.length - validMarkers.length;
        print('[InteractiveClaimsMapWidget] Valid markers for update: ${validMarkers.length}, Invalid markers filtered: $invalidCount');
      }
      
      // Prepare markers data as plain Dart Maps (for JSON encoding)
      final markersData = validMarkers.map((marker) {
        return {
          'lat': marker.latitude,
          'lng': marker.longitude,
          'claimId': marker.claimId,
          'claimNumber': marker.claimNumber,
          'status': marker.status.value,
          'color': _statusColorHex(marker.status),
          'title': marker.claimNumber,
        };
      }).toList();

      // Convert to JSON string for reliable serialization
      final markersJson = jsonEncode(markersData);

      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Marker update data prepared: ${markersData.length} markers');
        print('[InteractiveClaimsMapWidget] JSON string length: ${markersJson.length} characters');
      }

      rocMapsAPI.updateMarkers(_mapInstance, markersJson);
    } catch (e) {
      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Error updating markers: $e');
      }
    }
  }

  String _statusColorHex(ClaimStatus status) {
    switch (status) {
      case ClaimStatus.newClaim:
        return '#FF0000'; // Red
      case ClaimStatus.inContact:
        return '#FF9800'; // Orange
      case ClaimStatus.scheduled:
        return '#FFEB3B'; // Yellow
      case ClaimStatus.workInProgress:
        return '#2196F3'; // Blue
      case ClaimStatus.awaitingClient:
        return '#9C27B0'; // Purple
      case ClaimStatus.onHold:
        return '#9E9E9E'; // Gray
      case ClaimStatus.closed:
      case ClaimStatus.cancelled:
        return '#4CAF50'; // Green
    }
  }

  void _initializeMap(double actualHeight) {
    if (!kIsWeb || Env.googleMapsApiKey.isEmpty || _mapContainer == null) return;

    // First, ensure the Google Maps script is loaded
    PlacesWebService.ensureLoaded(Env.googleMapsApiKey).then((_) {
      if (!mounted || _mapContainer == null) {
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Widget unmounted or container null after script load');
        }
        return;
      }

      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Google Maps script loaded, waiting for API to be ready...');
      }

      // Now wait for the API to be fully initialized
      _waitForGoogleMaps().then((_) {
        if (!mounted || _mapContainer == null) return;

        try {
          if (!rocMapsAPI.isReady()) {
            if (kDebugMode) {
              print('[InteractiveClaimsMapWidget] Google Maps API not ready after script load');
            }
            return;
          }

          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Google Maps API ready, initializing map...');
            print('[InteractiveClaimsMapWidget] Preparing ${widget.markers.length} markers');
          }

        // Filter out markers with invalid coordinates before creating markersData
        final validMarkers = widget.markers.where((marker) {
          final isValid = marker.latitude.isFinite && 
                          marker.longitude.isFinite &&
                          !marker.latitude.isNaN &&
                          !marker.longitude.isNaN;
          if (!isValid && kDebugMode) {
            print('[InteractiveClaimsMapWidget] Filtering invalid marker: ${marker.claimNumber}, lat=${marker.latitude}, lng=${marker.longitude}');
          }
          return isValid;
        }).toList();

        if (kDebugMode) {
          final invalidCount = widget.markers.length - validMarkers.length;
          print('[InteractiveClaimsMapWidget] Valid markers: ${validMarkers.length}, Invalid markers filtered: $invalidCount');
        }

        // Prepare markers data as plain Dart Maps (for JSON encoding)
        final markersData = validMarkers.map((marker) {
          if (kDebugMode && validMarkers.indexOf(marker) < 3) {
            print('[InteractiveClaimsMapWidget] Marker ${marker.claimNumber}: lat=${marker.latitude} (${marker.latitude.runtimeType}), lng=${marker.longitude} (${marker.longitude.runtimeType})');
          }
          
          return {
            'lat': marker.latitude,
            'lng': marker.longitude,
            'claimId': marker.claimId,
            'claimNumber': marker.claimNumber,
            'status': marker.status.value,
            'color': _statusColorHex(marker.status),
            'title': marker.claimNumber,
          };
        }).toList();
        
        // Convert to JSON string for reliable serialization
        final markersJson = jsonEncode(markersData);
        
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Marker data prepared: ${markersData.length} markers');
          print('[InteractiveClaimsMapWidget] JSON string length: ${markersJson.length} characters');
          if (markersData.isNotEmpty) {
            final firstMarker = markersData.first;
            print('[InteractiveClaimsMapWidget] Sample marker data: claimId=${firstMarker['claimId']}, lat=${firstMarker['lat']}, lng=${firstMarker['lng']}');
          }
        }

        // Prepare map options
        final mapOptions = js.JsObject.jsify({
          'center': {
            'lat': widget.initialCenterLat,
            'lng': widget.initialCenterLng,
          },
          'zoom': widget.initialZoom,
          'mapTypeId': 'roadmap',
          'disableDefaultUI': false,
          'zoomControl': true,
          'mapTypeControl': false,
          'scaleControl': true,
          'streetViewControl': false,
          'rotateControl': false,
          'fullscreenControl': true,
        });

        // Create marker click callback - we'll handle this in JavaScript
        // Store callback reference for JavaScript to call
        if (widget.onMarkerClick != null) {
          js.context['rocMapMarkerClick_$_mapId'] = (dynamic claimId) {
            if (claimId is String && widget.onMarkerClick != null) {
              widget.onMarkerClick?.call(claimId);
            }
          };
        }

        // Create map with markers (pass JSON string)
        _mapInstance = rocMapsAPI.createMapWithMultipleMarkers(
          _mapContainer,
          mapOptions,
          markersJson,
          widget.onMarkerClick != null ? 'rocMapMarkerClick_$_mapId' : null,
        );

          if (mounted) {
            setState(() {
              _isMapInitialized = true;
            });
          }

          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Map initialized successfully');
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Error initializing map: $e');
            print('[InteractiveClaimsMapWidget] Stack trace: $stackTrace');
          }
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Error waiting for Google Maps API: $error');
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Error loading Google Maps script: $error');
        print('[InteractiveClaimsMapWidget] Make sure GOOGLE_MAPS_API_KEY is set correctly');
      }
    });
  }

  Future<void> _waitForGoogleMaps() async {
    if (!kIsWeb) return;

    int attempts = 0;
    const maxAttempts = 50;
    const pollInterval = Duration(milliseconds: 100);

    if (kDebugMode) {
      print('[InteractiveClaimsMapWidget] Waiting for Google Maps API to be ready...');
    }

    while (attempts < maxAttempts) {
      await Future.delayed(pollInterval);
      try {
        if (rocMapsAPI.isReady()) {
          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Google Maps API ready after $attempts attempts');
          }
          return;
        }
      } catch (e) {
        // API not ready yet
        if (kDebugMode && attempts % 10 == 0) {
          print('[InteractiveClaimsMapWidget] Waiting for Google Maps API... attempt $attempts (error: $e)');
        }
      }
      attempts++;
    }

    if (kDebugMode) {
      print('[InteractiveClaimsMapWidget] Google Maps API not ready after $maxAttempts attempts');
      print('[InteractiveClaimsMapWidget] This may indicate:');
      print('[InteractiveClaimsMapWidget] 1. API key is invalid or missing');
      print('[InteractiveClaimsMapWidget] 2. Maps JavaScript API is not enabled in Google Cloud Console');
      print('[InteractiveClaimsMapWidget] 3. Network issues preventing script load');
    }
  }

  void _ensureMapContainer(double actualHeight) {
    if (!kIsWeb || !mounted) {
      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] _ensureMapContainer: Not web or not mounted');
      }
      return;
    }

    // Check if already registered
    try {
      // Check if container already exists
      final existingElement = html.document.getElementById(_mapId);
      _mapContainer = existingElement is html.DivElement ? existingElement : null;
      if (_mapContainer != null && _isMapInitialized) {
        // Container exists and map is initialized, just update if needed
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Container exists and map initialized');
        }
        return;
      }

      // Create the map div element with explicit pixel height
      _mapContainer = html.DivElement()
        ..id = _mapId
        ..style.width = '100%'
        ..style.height = '${actualHeight}px'
        ..style.borderRadius = '${DesignTokens.radiusLarge}px'
        ..style.overflow = 'hidden';

      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Created container element with ID: $_mapId, height: ${actualHeight}px');
      }

      // Register as platform view (only once)
      try {
        ui_web.platformViewRegistry.registerViewFactory(
          _mapId,
          (int viewId) {
            if (kDebugMode) {
              print('[InteractiveClaimsMapWidget] Platform view factory called for viewId: $viewId');
            }
            return _mapContainer!;
          },
        );
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Platform view registered successfully');
        }
      } catch (e) {
        // Already registered, that's fine
        if (kDebugMode) {
          print('[InteractiveClaimsMapWidget] Platform view already registered or error: $e');
        }
      }

      // Note: Element verification happens when HtmlElementView renders and calls the factory
      // The element won't be in the DOM until then, so we don't verify here

      // Initialize the map after a short delay to ensure registration and Google Maps is loaded
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _mapContainer != null && !_isMapInitialized) {
          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Delayed initialization starting');
          }
          _initializeMap(actualHeight);
        } else {
          if (kDebugMode) {
            print('[InteractiveClaimsMapWidget] Delayed initialization skipped - mounted: $mounted, container: ${_mapContainer != null}, initialized: $_isMapInitialized');
          }
        }
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[InteractiveClaimsMapWidget] Error creating map container: $e');
        print('[InteractiveClaimsMapWidget] Stack trace: $stackTrace');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || Env.googleMapsApiKey.isEmpty) {
      return SizedBox(
        height: widget.height == double.infinity ? null : widget.height,
        width: double.infinity,
        child: Container(
          color: Colors.grey[300],
          child: const Center(
            child: Text('Interactive map not available on this platform'),
          ),
        ),
      );
    }

    // Use LayoutBuilder to handle double.infinity height
    return LayoutBuilder(
      builder: (context, constraints) {
        final actualHeight = widget.height == double.infinity
            ? constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : 600.0 // Fallback height
            : widget.height;

        // Ensure map container is created and registered synchronously
        _ensureMapContainer(actualHeight);

        // Use SizedBox.expand() for infinite height, or explicit sizing for fixed height
        final container = widget.height == double.infinity
            ? SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                    border: Border.all(
                      color: DesignTokens.borderSubtle(Theme.of(context).brightness),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                    child: _mapContainer != null
                        ? HtmlElementView(viewType: _mapId)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              )
            : SizedBox(
                height: widget.height,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                    border: Border.all(
                      color: DesignTokens.borderSubtle(Theme.of(context).brightness),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                    child: _mapContainer != null
                        ? HtmlElementView(viewType: _mapId)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              );

        return container;
      },
    );
  }
}

