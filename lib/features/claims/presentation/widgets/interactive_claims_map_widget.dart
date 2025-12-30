import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';

import '../../../../core/config/env.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_error_state.dart';
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
  bool _isLoading = true;
  String? _errorMessage;
  DateTime? _initializationStartTime;

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
      AppLogger.debug(
        'Updating ${widget.markers.length} markers',
        name: 'InteractiveClaimsMapWidget',
      );

      // Filter out markers with invalid coordinates
      final validMarkers = widget.markers.where((marker) {
        final isValid = marker.latitude.isFinite && 
                        marker.longitude.isFinite &&
                        !marker.latitude.isNaN &&
                        !marker.longitude.isNaN;
        if (!isValid) {
          AppLogger.debug(
            'Filtering invalid marker during update: ${marker.claimNumber}, lat=${marker.latitude}, lng=${marker.longitude}',
            name: 'InteractiveClaimsMapWidget',
          );
        }
        return isValid;
      }).toList();

      final invalidCount = widget.markers.length - validMarkers.length;
      AppLogger.debug(
        'Valid markers for update: ${validMarkers.length}, Invalid markers filtered: $invalidCount',
        name: 'InteractiveClaimsMapWidget',
      );
      
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
          'technicianId': marker.technicianId,
          'technicianName': marker.technicianName,
          'hasTechnician': marker.hasTechnician,
        };
      }).toList();

      // Convert to JSON string for reliable serialization
      final markersJson = jsonEncode(markersData);

      AppLogger.debug(
        'Marker update data prepared: ${markersData.length} markers, JSON string length: ${markersJson.length} characters',
        name: 'InteractiveClaimsMapWidget',
      );

      rocMapsAPI.updateMarkers(_mapInstance, markersJson);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating markers: $e',
        name: 'InteractiveClaimsMapWidget',
        error: e,
        stackTrace: stackTrace,
      );
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
    // Verify environment variables first
    if (!Env.verifyEnvVars()) {
      AppLogger.error(
        'Environment variables missing in map widget',
        name: 'InteractiveClaimsMapWidget',
      );
    }
    
    if (!kIsWeb || Env.googleMapsApiKey.isEmpty || _mapContainer == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = Env.googleMapsApiKey.isEmpty 
              ? 'Google Maps API key is not configured'
              : 'Map container not available';
        });
      }
      AppLogger.error(
        'Map initialization failed: ${Env.googleMapsApiKey.isEmpty ? "API key missing" : "Container null"}',
        name: 'InteractiveClaimsMapWidget',
      );
      return;
    }

    _initializationStartTime = DateTime.now();
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    // First, ensure the Google Maps script is loaded
    PlacesWebService.ensureLoaded(Env.googleMapsApiKey).then((_) {
      if (!mounted || _mapContainer == null) {
        AppLogger.debug(
          'Widget unmounted or container null after script load',
          name: 'InteractiveClaimsMapWidget',
        );
        return;
      }

      AppLogger.debug(
        'Google Maps script loaded, waiting for API to be ready...',
        name: 'InteractiveClaimsMapWidget',
      );

      // Now wait for the API to be fully initialized
      _waitForGoogleMaps().then((_) {
        if (!mounted || _mapContainer == null) return;

        try {
          if (!rocMapsAPI.isReady()) {
            AppLogger.debug(
              'Google Maps API not ready after script load',
              name: 'InteractiveClaimsMapWidget',
            );
            if (mounted) {
              setState(() {
                _isLoading = false;
                _errorMessage = 'Google Maps API not ready. Please try refreshing the page.';
              });
            }
            return;
          }

          AppLogger.debug(
            'Google Maps API ready, initializing map... Preparing ${widget.markers.length} markers',
            name: 'InteractiveClaimsMapWidget',
          );

        // Filter out markers with invalid coordinates before creating markersData
        final validMarkers = widget.markers.where((marker) {
          final isValid = marker.latitude.isFinite && 
                          marker.longitude.isFinite &&
                          !marker.latitude.isNaN &&
                          !marker.longitude.isNaN;
          if (!isValid) {
            AppLogger.debug(
              'Filtering invalid marker: ${marker.claimNumber}, lat=${marker.latitude}, lng=${marker.longitude}',
              name: 'InteractiveClaimsMapWidget',
            );
          }
          return isValid;
        }).toList();

        final invalidCount = widget.markers.length - validMarkers.length;
        AppLogger.debug(
          'Valid markers: ${validMarkers.length}, Invalid markers filtered: $invalidCount',
          name: 'InteractiveClaimsMapWidget',
        );

        // Prepare markers data as plain Dart Maps (for JSON encoding)
        final markersData = validMarkers.map((marker) {
          if (validMarkers.indexOf(marker) < 3) {
            AppLogger.debug(
              'Marker ${marker.claimNumber}: lat=${marker.latitude} (${marker.latitude.runtimeType}), lng=${marker.longitude} (${marker.longitude.runtimeType})',
              name: 'InteractiveClaimsMapWidget',
            );
          }
          
          return {
            'lat': marker.latitude,
            'lng': marker.longitude,
            'claimId': marker.claimId,
            'claimNumber': marker.claimNumber,
            'status': marker.status.value,
            'color': _statusColorHex(marker.status),
            'title': marker.claimNumber,
            'technicianId': marker.technicianId,
            'technicianName': marker.technicianName,
            'hasTechnician': marker.hasTechnician,
          };
        }).toList();
        
        // Convert to JSON string for reliable serialization
        final markersJson = jsonEncode(markersData);
        
        AppLogger.debug(
          'Marker data prepared: ${markersData.length} markers, JSON string length: ${markersJson.length} characters',
          name: 'InteractiveClaimsMapWidget',
        );
        if (markersData.isNotEmpty) {
          final firstMarker = markersData.first;
          AppLogger.debug(
            'Sample marker data: claimId=${firstMarker['claimId']}, lat=${firstMarker['lat']}, lng=${firstMarker['lng']}',
            name: 'InteractiveClaimsMapWidget',
          );
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
        String? callbackName;
        if (widget.onMarkerClick != null) {
          try {
            callbackName = 'rocMapMarkerClick_$_mapId';
            js.context[callbackName] = js.allowInterop((dynamic claimId) {
              try {
                if (claimId is String && widget.onMarkerClick != null) {
                  widget.onMarkerClick?.call(claimId);
                } else {
                  AppLogger.debug(
                    'Marker click callback received invalid claimId: $claimId (type: ${claimId.runtimeType})',
                    name: 'InteractiveClaimsMapWidget',
                  );
                }
              } catch (e, stackTrace) {
                AppLogger.error(
                  'Error in marker click callback: $e',
                  name: 'InteractiveClaimsMapWidget',
                  error: e,
                  stackTrace: stackTrace,
                );
              }
            });
            AppLogger.debug(
              'Marker click callback registered: $callbackName',
              name: 'InteractiveClaimsMapWidget',
            );
          } catch (e, stackTrace) {
            AppLogger.error(
              'Error creating marker click callback: $e',
              name: 'InteractiveClaimsMapWidget',
              error: e,
              stackTrace: stackTrace,
            );
            callbackName = null;
          }
        }

        // Validate inputs before calling JavaScript function
        if (_mapContainer == null) {
          throw StateError('Map container is null');
        }
        if (markersJson.isEmpty) {
          AppLogger.debug(
            'No markers to display on map',
            name: 'InteractiveClaimsMapWidget',
          );
        }

        // Create map with markers (pass JSON string)
        try {
          _mapInstance = rocMapsAPI.createMapWithMultipleMarkers(
            _mapContainer,
            mapOptions,
            markersJson,
            callbackName,
          );
          
          if (_mapInstance == null) {
            throw StateError('Map instance is null after creation');
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error calling createMapWithMultipleMarkers: $e',
            name: 'InteractiveClaimsMapWidget',
            error: e,
            stackTrace: stackTrace,
          );
          rethrow;
        }

          if (mounted) {
            setState(() {
              _isMapInitialized = true;
              _isLoading = false;
              _errorMessage = null;
            });
          }

          AppLogger.debug(
            'Map initialized successfully',
            name: 'InteractiveClaimsMapWidget',
          );
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error initializing map: $e',
            name: 'InteractiveClaimsMapWidget',
            error: e,
            stackTrace: stackTrace,
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to initialize map: ${e.toString()}';
            });
          }
        }
      }).catchError((error, stackTrace) {
        AppLogger.error(
          'Error waiting for Google Maps API: $error',
          name: 'InteractiveClaimsMapWidget',
          error: error,
          stackTrace: stackTrace,
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Google Maps API not available. Please check your API key configuration.';
          });
        }
      });
    }).catchError((error) {
      AppLogger.debug(
        'Error loading Google Maps script: $error. Make sure GOOGLE_MAPS_API_KEY is set correctly',
        name: 'InteractiveClaimsMapWidget',
        error: error,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          final errorStr = error.toString().toLowerCase();
          if (errorStr.contains('api key') || errorStr.contains('invalid key')) {
            _errorMessage = 'Invalid Google Maps API key. Please check your configuration.';
          } else {
            _errorMessage = 'Failed to load Google Maps: ${error.toString()}';
          }
        });
      }
    });

    // Add timeout to prevent infinite loading
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading && !_isMapInitialized) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Map initialization timed out. Please check your internet connection and API key.';
        });
      }
    });
  }

  Future<void> _waitForGoogleMaps() async {
    if (!kIsWeb) return;

    int attempts = 0;
    const maxAttempts = 50;
    const pollInterval = Duration(milliseconds: 100);

    AppLogger.debug(
      'Waiting for Google Maps API to be ready...',
      name: 'InteractiveClaimsMapWidget',
    );

    while (attempts < maxAttempts) {
      await Future.delayed(pollInterval);
      try {
        if (rocMapsAPI.isReady()) {
          AppLogger.debug(
            'Google Maps API ready after $attempts attempts',
            name: 'InteractiveClaimsMapWidget',
          );
          return;
        }
      } catch (e) {
        // API not ready yet
        if (attempts % 10 == 0) {
          AppLogger.debug(
            'Waiting for Google Maps API... attempt $attempts',
            name: 'InteractiveClaimsMapWidget',
            error: e,
          );
        }
      }
      attempts++;
    }

    AppLogger.debug(
      'Google Maps API not ready after $maxAttempts attempts. This may indicate: 1. API key is invalid or missing, 2. Maps JavaScript API is not enabled in Google Cloud Console, 3. Network issues preventing script load',
      name: 'InteractiveClaimsMapWidget',
    );
  }

  void _ensureMapContainer(double actualHeight) {
    if (!kIsWeb || !mounted) {
      AppLogger.debug(
        '_ensureMapContainer: Not web or not mounted',
        name: 'InteractiveClaimsMapWidget',
      );
      return;
    }

    // Check if already registered
    try {
      // Check if container already exists
      final existingElement = html.document.getElementById(_mapId);
      _mapContainer = existingElement is html.DivElement ? existingElement : null;
      if (_mapContainer != null && _isMapInitialized) {
        // Container exists and map is initialized, just update if needed
        AppLogger.debug(
          'Container exists and map initialized',
          name: 'InteractiveClaimsMapWidget',
        );
        return;
      }

      // Create the map div element with explicit pixel height
      _mapContainer = html.DivElement()
        ..id = _mapId
        ..style.width = '100%'
        ..style.height = '${actualHeight}px'
        ..style.borderRadius = '${DesignTokens.radiusLarge}px'
        ..style.overflow = 'hidden';

      AppLogger.debug(
        'Created container element with ID: $_mapId, height: ${actualHeight}px',
        name: 'InteractiveClaimsMapWidget',
      );

      // Register as platform view (only once)
      try {
        ui_web.platformViewRegistry.registerViewFactory(
          _mapId,
          (int viewId) {
            AppLogger.debug(
              'Platform view factory called for viewId: $viewId',
              name: 'InteractiveClaimsMapWidget',
            );
            return _mapContainer!;
          },
        );
        AppLogger.debug(
          'Platform view registered successfully',
          name: 'InteractiveClaimsMapWidget',
        );
      } catch (e) {
        // Already registered, that's fine
        AppLogger.debug(
          'Platform view already registered or error: $e',
          name: 'InteractiveClaimsMapWidget',
          error: e,
        );
      }

      // Note: Element verification happens when HtmlElementView renders and calls the factory
      // The element won't be in the DOM until then, so we don't verify here

      // Initialize the map after a short delay to ensure registration and Google Maps is loaded
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _mapContainer != null && !_isMapInitialized) {
          AppLogger.debug(
            'Delayed initialization starting',
            name: 'InteractiveClaimsMapWidget',
          );
          _initializeMap(actualHeight);
        } else {
          AppLogger.debug(
            'Delayed initialization skipped - mounted: $mounted, container: ${_mapContainer != null}, initialized: $_isMapInitialized',
            name: 'InteractiveClaimsMapWidget',
          );
        }
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating map container: $e',
        name: 'InteractiveClaimsMapWidget',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || Env.googleMapsApiKey.isEmpty) {
      return SizedBox(
        height: widget.height == double.infinity ? null : widget.height,
        width: double.infinity,
        child: Container(
          color: DesignTokens.glassBase(Theme.of(context).brightness),
          child: Center(
            child: Text(
              'Interactive map not available on this platform',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: DesignTokens.textSecondary(Theme.of(context).brightness),
              ),
            ),
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

        // Show error state if initialization failed
        if (_errorMessage != null && !_isLoading) {
          return SizedBox(
            height: actualHeight,
            width: double.infinity,
            child: GlassErrorState(
              title: 'Map Error',
              message: _errorMessage!,
              icon: Icons.map_outlined,
              onRetry: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                  _isMapInitialized = false;
                });
                _initializeMap(actualHeight);
              },
            ),
          );
        }

        // Show loading state while initializing
        if (_isLoading || !_isMapInitialized || _mapContainer == null) {
          return SizedBox(
            height: actualHeight,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
                border: Border.all(
                  color: DesignTokens.borderSubtle(Theme.of(context).brightness),
                  width: 1,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

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
                    child: HtmlElementView(viewType: _mapId),
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
                    child: HtmlElementView(viewType: _mapId),
                  ),
                ),
              );

        return container;
      },
    );
  }
}

