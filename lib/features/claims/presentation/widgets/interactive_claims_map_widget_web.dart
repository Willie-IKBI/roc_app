import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/env.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_error_state.dart';
import '../../../../core/utils/places_web_service.dart';
import '../../../../domain/models/claim_map_marker.dart';
import '../../../../domain/value_objects/claim_enums.dart';

/// Helper to convert Dart types to JSAny (minimal implementation for Maps/Lists)
JSAny? _dartToJS(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.toJS;
  if (value is num) return value.toJS;
  if (value is bool) return value.toJS;
  if (value is List) {
    // Create JS array manually - JSArray.from expects a single JSObject (array-like)
    // So we create an empty array and populate it
    final jsArray = JSArray.from(JSObject());
    for (var i = 0; i < value.length; i++) {
      final jsVal = _dartToJS(value[i]);
      if (jsVal != null) {
        jsArray[i] = jsVal as JSObject;
      }
    }
    return jsArray;
  }
  if (value is Map) {
    final jsObj = JSObject();
    value.forEach((key, val) {
      final jsVal = _dartToJS(val);
      if (jsVal != null) {
        jsObj.setProperty(key.toString().toJS, jsVal);
      }
    });
    return jsObj;
  }
  return value.toJS;
}

@JS('rocMapsAPI')
external RocMapsAPI get rocMapsAPI;

@JS()
extension type RocMapsAPI._(JSObject _) implements JSObject {
  external bool isReady();
  external JSAny? createMapWithMultipleMarkers(
    JSAny? container,
    JSAny? options,
    JSAny? markers, // Can be JSON string or array
    JSAny? onMarkerClick,
  );
  external void updateMarkers(JSAny? mapInstance, JSAny? markers); // Can be JSON string or array
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
      (globalContext as JSObject).setProperty('rocMapMarkerClick_$_mapId'.toJS, null);
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

      rocMapsAPI.updateMarkers(_mapInstance, markersJson.toJS);
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
    // Verify environment variables first with detailed validation
    try {
      if (!Env.verifyEnvVars()) {
        final missingVars = <String>[];
        if (Env.supabaseUrl.isEmpty) missingVars.add('SUPABASE_URL');
        if (Env.supabaseAnonKey.isEmpty) missingVars.add('SUPABASE_ANON_KEY');
        if (Env.googleMapsApiKey.isEmpty) missingVars.add('GOOGLE_MAPS_API_KEY');
        
        AppLogger.error(
          'Environment variables missing in map widget: ${missingVars.join(", ")}',
          name: 'InteractiveClaimsMapWidget',
        );
        
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Configuration error: Missing environment variables (${missingVars.join(", ")}). Please check your build configuration.';
          });
        }
        return;
      }
      
      // Validate API key format
      if (Env.googleMapsApiKey.length < 20) {
        AppLogger.error(
          'Google Maps API key appears invalid (too short: ${Env.googleMapsApiKey.length} chars)',
          name: 'InteractiveClaimsMapWidget',
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid Google Maps API key format. Please check your configuration.';
          });
        }
        return;
      }
      
      if (!Env.googleMapsApiKey.startsWith('AIza') && !Env.googleMapsApiKey.startsWith('GOCSPX')) {
        AppLogger.warn(
          'Google Maps API key format may be invalid (does not start with AIza or GOCSPX)',
          name: 'InteractiveClaimsMapWidget',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error validating environment variables: $e',
        name: 'InteractiveClaimsMapWidget',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Configuration error: Failed to validate environment variables.';
        });
      }
      return;
    }
    
    if (!kIsWeb) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Interactive map is only available on web platform';
        });
      }
      AppLogger.error(
        'Map initialization failed: Not running on web platform',
        name: 'InteractiveClaimsMapWidget',
      );
      return;
    }
    
    if (Env.googleMapsApiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Google Maps API key is not configured. Please set GOOGLE_MAPS_API_KEY environment variable.';
        });
      }
      AppLogger.error(
        'Map initialization failed: API key missing',
        name: 'InteractiveClaimsMapWidget',
      );
      return;
    }
    
    if (_mapContainer == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Map container not available. Please try refreshing the page.';
        });
      }
      AppLogger.error(
        'Map initialization failed: Container null',
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
      if (!mounted) {
        AppLogger.debug(
          'Widget unmounted after script load',
          name: 'InteractiveClaimsMapWidget',
        );
        return;
      }
      
      if (_mapContainer == null) {
        AppLogger.error(
          'Map container became null after script load',
          name: 'InteractiveClaimsMapWidget',
        );
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Map container not available. Please try refreshing the page.';
          });
        }
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
        final mapOptions = _dartToJS(<String, dynamic>{
          'center': <String, dynamic>{
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
            final callback = ((JSString claimId) {
              try {
                final claimIdStr = claimId.toDart;
                if (widget.onMarkerClick != null) {
                  widget.onMarkerClick?.call(claimIdStr);
                } else {
                  AppLogger.debug(
                    'Marker click callback received invalid claimId: $claimIdStr',
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
            }).toJS;
            (globalContext as JSObject).setProperty(callbackName.toJS, callback);
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
          throw StateError('Map container is null - cannot initialize map');
        }
        
        // Validate rocMapsAPI is available
        try {
          if (!rocMapsAPI.isReady()) {
            throw StateError('Google Maps API is not ready - rocMapsAPI.isReady() returned false');
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error checking rocMapsAPI.isReady(): $e',
            name: 'InteractiveClaimsMapWidget',
            error: e,
            stackTrace: stackTrace,
          );
          throw StateError('Failed to verify Google Maps API availability: $e');
        }
        
        if (markersJson.isEmpty) {
          AppLogger.debug(
            'No markers to display on map (empty markers list)',
            name: 'InteractiveClaimsMapWidget',
          );
        }

        // Validate mapOptions was created successfully
        if (mapOptions == null) {
          throw StateError('Failed to create map options - jsify returned null');
        }

        // Create map with markers (pass JSON string)
        try {
          AppLogger.debug(
            'Calling rocMapsAPI.createMapWithMultipleMarkers with ${markersData.length} markers',
            name: 'InteractiveClaimsMapWidget',
          );
          
          // Wrap the call in additional error handling
          dynamic mapResult;
          try {
            mapResult = rocMapsAPI.createMapWithMultipleMarkers(
              _mapContainer as JSAny?,
              mapOptions,
              markersJson.toJS,
              callbackName?.toJS,
            );
          } catch (jsError, jsStackTrace) {
            AppLogger.error(
              'JavaScript error in createMapWithMultipleMarkers: $jsError',
              name: 'InteractiveClaimsMapWidget',
              error: jsError,
              stackTrace: jsStackTrace,
            );
            throw StateError('JavaScript error during map creation: ${jsError.toString()}');
          }
          
          if (mapResult == null) {
            AppLogger.error(
              'createMapWithMultipleMarkers returned null',
              name: 'InteractiveClaimsMapWidget',
            );
            throw StateError('Map instance is null after creation - JavaScript function returned null');
          }
          
          _mapInstance = mapResult;
          AppLogger.debug(
            'Map instance created successfully',
            name: 'InteractiveClaimsMapWidget',
          );
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error calling createMapWithMultipleMarkers: $e',
            name: 'InteractiveClaimsMapWidget',
            error: e,
            stackTrace: stackTrace,
          );
          // Provide more specific error message
          final errorStr = e.toString().toLowerCase();
          String userMessage = 'Failed to initialize map: ${e.toString()}';
          if (errorStr.contains('api key') || errorStr.contains('invalid key')) {
            userMessage = 'Invalid Google Maps API key. Please check your API key configuration and ensure it has the required permissions.';
          } else if (errorStr.contains('not available') || errorStr.contains('not ready')) {
            userMessage = 'Google Maps API is not available. Please check your internet connection and API key configuration.';
          } else if (errorStr.contains('quota') || errorStr.contains('limit')) {
            userMessage = 'Google Maps API quota exceeded. Please check your Google Cloud Console billing and quota settings.';
          }
          throw StateError(userMessage);
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
            final errorStr = error.toString().toLowerCase();
            if (errorStr.contains('timeout')) {
              _errorMessage = 'Google Maps API initialization timed out. Please check your internet connection and try refreshing the page.';
            } else if (errorStr.contains('not ready') || errorStr.contains('not available')) {
              _errorMessage = 'Google Maps API is not available. Please check your API key configuration and ensure all required APIs are enabled in Google Cloud Console.';
            } else {
              _errorMessage = 'Failed to initialize Google Maps API: ${error.toString()}. Please check your API key configuration.';
            }
          });
        }
      });
    }).catchError((error, stackTrace) {
      AppLogger.error(
        'Error loading Google Maps script: $error',
        name: 'InteractiveClaimsMapWidget',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          final errorStr = error.toString().toLowerCase();
          if (errorStr.contains('api key') || errorStr.contains('invalid key')) {
            _errorMessage = 'Invalid Google Maps API key. Please verify:\n1. API key is correct in env/prod.json\n2. Maps JavaScript API is enabled\n3. Places API is enabled\n4. API key restrictions allow your domain';
          } else if (errorStr.contains('quota') || errorStr.contains('limit')) {
            _errorMessage = 'Google Maps API quota exceeded. Please check your Google Cloud Console billing and quota settings.';
          } else if (errorStr.contains('billing')) {
            _errorMessage = 'Google Maps API billing issue. Please ensure billing is enabled for your Google Cloud project.';
          } else if (errorStr.contains('network') || errorStr.contains('timeout')) {
            _errorMessage = 'Network error loading Google Maps. Please check your internet connection and try again.';
          } else {
            _errorMessage = 'Failed to load Google Maps: ${error.toString()}. Please check your API key configuration and browser console for details.';
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
    if (!kIsWeb) {
      throw StateError('Google Maps API is only available on web platform');
    }

    int attempts = 0;
    const maxAttempts = 50; // 5 seconds total (50 * 100ms)
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
      } catch (e, stackTrace) {
        // API not ready yet or error checking
        if (attempts % 10 == 0) {
          AppLogger.debug(
            'Waiting for Google Maps API... attempt $attempts (error: $e)',
            name: 'InteractiveClaimsMapWidget',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
      attempts++;
    }

    // Timeout reached - throw error with helpful message
    AppLogger.error(
      'Google Maps API not ready after $maxAttempts attempts (${maxAttempts * 100}ms). This may indicate: 1. API key is invalid or missing, 2. Maps JavaScript API is not enabled in Google Cloud Console, 3. Network issues preventing script load, 4. API key restrictions blocking the domain',
      name: 'InteractiveClaimsMapWidget',
    );
    
    throw TimeoutException(
      'Google Maps API did not become ready within ${maxAttempts * 100}ms. Please check: 1. API key is correct, 2. Maps JavaScript API is enabled, 3. Network connectivity, 4. API key restrictions allow your domain',
      const Duration(milliseconds: maxAttempts * 100),
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

