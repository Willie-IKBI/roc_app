import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../logging/logger.dart';

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
  external JSAny? getMapClass();
  external JSAny? getLatLngClass();
  external JSAny? getGeocoderClass();
  external JSAny? getMapTypeId();
  external JSAny? getMapTypeIdRoadmap();
  external JSAny? getMapsObject();
  external JSObject createLatLng(double lat, double lng);
  external JSAny? createMap(JSAny? container, JSAny? options);
  external JSObject createMarker(JSAny? options);
  external JSAny? createMapWithClickListener(JSAny? container, JSAny? options, JSAny? onClickCallback);
}

/// An interactive Google Map widget for web.
/// 
/// Displays a Google Map that users can interact with to select coordinates.
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
  html.DivElement? _mapContainer;
  dynamic _mapInstance; // Can be JSObject or dynamic depending on how map is created
  late final String _mapId;
  final GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _mapId = 'roc-map-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void didUpdateWidget(InteractiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb && _mapInstance != null) {
      if (widget.latitude != oldWidget.latitude ||
          widget.longitude != oldWidget.longitude) {
        _updateMapCenter();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateMapCenter() {
    if (!kIsWeb || _mapInstance == null) return;
    if (widget.latitude != null && widget.longitude != null) {
      try {
        // Try to use as JSObject first, fallback to dynamic
        if (_mapInstance is JSObject) {
          final centerArgs = JSArray.from(JSObject());
          centerArgs[0] = widget.latitude!.toJS as JSObject;
          centerArgs[1] = widget.longitude!.toJS as JSObject;
          (_mapInstance as JSObject).callMethod('setCenter'.toJS, centerArgs);
          final markerArgs = JSArray.from(JSObject());
          markerArgs[0] = widget.latitude!.toJS as JSObject;
          markerArgs[1] = widget.longitude!.toJS as JSObject;
          markerArgs[2] = false.toJS as JSObject;
          (_mapInstance as JSObject).callMethod('setMarker'.toJS, markerArgs);
        } else {
          // For dynamic type, we need to use JavaScript helper functions
          // The map instance from createMapWithClickListener should be accessible
          if (kDebugMode) {
            print('_updateMapCenter: Map instance is not JSObject, skipping update');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error updating map center: $e');
        }
      }
    }
  }

  void _initializeMap() {
    if (!kIsWeb) return;

    // Wait for Google Maps API to be available
    _waitForGoogleMaps().then((_) {
      if (!mounted) return;

      try {
        // Verify Google Maps is actually available using JavaScript helper
        bool googleMapsAvailable = false;
        try {
          if (rocMapsAPI.isReady()) {
            googleMapsAvailable = true;
          }
        } catch (e) {
          // Google Maps not available or helper function error
          if (kDebugMode) {
            print('Error checking Maps API availability: $e');
          }
        }
        
        if (!googleMapsAvailable) {
          AppLogger.debug(
            'Google Maps API not available after wait, skipping map initialization. Please ensure Maps JavaScript API is enabled and API key is correct. rocMapsAPI helper may not be available',
            name: 'InteractiveMapWidget',
          );
          return;
        }

        // Find the container element by ID
        final existingElement = html.document.getElementById(_mapId);
        _mapContainer = existingElement is html.DivElement ? existingElement : null;
        if (_mapContainer == null) {
          if (kDebugMode) {
            print('Map container not found: $_mapId');
          }
          return;
        }

        // Create map options
        final center = widget.latitude != null && widget.longitude != null
            ? _dartToJS(<String, dynamic>{
                'lat': widget.latitude,
                'lng': widget.longitude,
              })
            : _dartToJS(<String, dynamic>{
                'lat': -25.7, // Default to South Africa
                'lng': 28.2,
              });

        final marker = widget.latitude != null && widget.longitude != null
            ? _dartToJS(<String, dynamic>{
                'lat': widget.latitude,
                'lng': widget.longitude,
                'draggable': false,
                'title': 'Selected location',
              })
            : null;

        final onClickCallback = widget.onCoordinateSelected != null
            ? ((JSNumber lat, JSNumber lng) {
                widget.onCoordinateSelected?.call(lat.toDartDouble, lng.toDartDouble);
              }).toJS
            : null;

        final options = _dartToJS(<String, dynamic>{
          'center': center,
          'zoom': widget.zoom,
          'marker': marker,
          'onClick': onClickCallback,
        });

        // Get rocMap from window (safely)
        JSObject? rocMap;
        try {
          final window = globalContext['window'] as JSObject?;
          if (window != null) {
            rocMap = window.getProperty('rocMap'.toJS) as JSObject?;
          }
        } catch (_) {
          // rocMap not available
        }
        
        if (rocMap != null) {
          // Create the map
          final arrayConstructor = globalContext['Array'] as JSObject;
          final createArgs = arrayConstructor.callMethod('from'.toJS, [[_mapId.toJS, options].toJS].toJS) as JSArray;
          _mapInstance = rocMap.callMethod('create'.toJS, createArgs) as JSObject?;
        } else {
          if (kDebugMode) {
            print('rocMap not available, creating map directly');
          }
          // Fallback: create map directly using Google Maps API
          _createMapDirectly();
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing map: $e');
        }
      }
    });
  }

  void _createMapDirectly() {
    if (!kIsWeb || _mapContainer == null) {
      if (kDebugMode) {
        print('_createMapDirectly: Not web or container is null');
      }
      return;
    }

    try {
      // Verify map container is properly registered
      if (kDebugMode) {
        print('_createMapDirectly: Container ID: $_mapId, Element: ${_mapContainer?.id}');
      }

      // Use JavaScript helper to get Maps API classes
      try {
        if (!rocMapsAPI.isReady()) {
          if (kDebugMode) {
            print('Maps API not ready according to rocMapsAPI helper');
          }
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print('rocMapsAPI helper not available: $e');
        }
        return;
      }
      
      // Create LatLng using helper function
      final center = widget.latitude != null && widget.longitude != null
          ? rocMapsAPI.createLatLng(widget.latitude!, widget.longitude!)
          : rocMapsAPI.createLatLng(-25.7, 28.2);

      if (kDebugMode) {
        print('_createMapDirectly: Created center LatLng');
      }

      // Get MapTypeId via helper
      dynamic mapTypeId;
      try {
        mapTypeId = rocMapsAPI.getMapTypeIdRoadmap();
        if (mapTypeId == null) {
          if (kDebugMode) {
            print('Google Maps MapTypeId.ROADMAP not available');
          }
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting MapTypeId: $e');
        }
        return;
      }

      final mapOptions = _dartToJS(<String, dynamic>{
        'center': center,
        'zoom': widget.zoom,
        'mapTypeId': mapTypeId,
      });

      if (kDebugMode) {
        print('_createMapDirectly: Creating map with options');
      }

      // Use createMapWithClickListener to handle click events in JavaScript
      JSFunction? onClickCallback;
      if (widget.onCoordinateSelected != null) {
        onClickCallback = ((JSNumber lat, JSNumber lng) {
          widget.onCoordinateSelected?.call(lat.toDartDouble, lng.toDartDouble);
        }).toJS;
      }

      final mapResult = rocMapsAPI.createMapWithClickListener(
        _mapContainer as JSAny?,
        mapOptions,
        onClickCallback,
      );

      if (mapResult == null) {
        if (kDebugMode) {
          print('createMapWithClickListener returned null');
        }
        return;
      }

      // Cast to JSObject safely
      final map = mapResult as JSObject?;
      if (map == null) {
        if (kDebugMode) {
          print('Failed to cast map result to JSObject, type: ${mapResult.runtimeType}');
          // Try to use it as dynamic anyway
          _mapInstance = mapResult as dynamic;
          if (_mapInstance != null) {
            print('Using map as dynamic type');
          }
        } else {
          return;
        }
      } else {
        _mapInstance = map;
      }

      if (kDebugMode) {
        print('_createMapDirectly: Map created successfully');
      }

      // Add marker if coordinates provided
      if (widget.latitude != null && widget.longitude != null) {
        try {
          final markerOptions = _dartToJS(<String, dynamic>{
            'position': center,
            'map': map ?? _mapInstance,
            'title': 'Selected location',
          });
          rocMapsAPI.createMarker(markerOptions);
          if (kDebugMode) {
            print('_createMapDirectly: Marker created');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error creating marker: $e');
          }
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error creating map directly: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  Future<void> _waitForGoogleMaps() async {
    if (!kIsWeb) return;

    int attempts = 0;
    const maxAttempts = 50;
    const pollInterval = 100;

    while (attempts < maxAttempts) {
      try {
        // Use JavaScript helper function to check Maps API availability
        if (rocMapsAPI.isReady()) {
          // Google Maps API is fully loaded
          if (kDebugMode && attempts > 0) {
            print('Google Maps API fully loaded after $attempts attempts (via rocMapsAPI helper)');
          }
          return;
        }
      } catch (e) {
        // rocMapsAPI not available yet or error, continue waiting
        if (kDebugMode && attempts == 0) {
          print('Waiting for Google Maps API to load...');
        }
      }
      await Future.delayed(Duration(milliseconds: pollInterval));
      attempts++;
    }

    if (kDebugMode) {
      print('Google Maps API not loaded after $maxAttempts attempts');
      print('Please check:');
      print('1. API key is correct and has Maps JavaScript API enabled');
      print('2. Network connectivity');
      print('3. Browser console for script loading errors');
      print('4. rocMapsAPI helper function is available');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      // For non-web platforms, show a placeholder
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Map not available on this platform',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Ensure map container is created and registered
    _ensureMapContainer();

    return Container(
      key: _containerKey,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: _mapContainer != null
          ? HtmlElementView(viewType: _mapId)
          : Center(
              child: Text(
                'Loading map...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }

  void _ensureMapContainer() {
    if (!kIsWeb || !mounted) {
      if (kDebugMode) {
        print('_ensureMapContainer: Not web or not mounted');
      }
      return;
    }

    // Check if already registered
    try {
      // Check if container already exists
      final existingElement = html.document.getElementById(_mapId);
      _mapContainer = existingElement is html.DivElement ? existingElement : null;
      if (_mapContainer != null && _mapInstance != null) {
        // Container exists and map is initialized, just update if needed
        if (kDebugMode) {
          print('_ensureMapContainer: Container exists and map initialized, updating center');
        }
        _updateMapCenter();
        return;
      }

      // Create the map div element
      _mapContainer = html.DivElement()
        ..id = _mapId
        ..style.width = '100%'
        ..style.height = '${widget.height}px'
        ..style.borderRadius = '8px'
        ..style.overflow = 'hidden';

      if (kDebugMode) {
        print('_ensureMapContainer: Created container element with ID: $_mapId');
      }

      // Register as platform view (only once)
      try {
        ui_web.platformViewRegistry.registerViewFactory(
          _mapId,
          (int viewId) {
            if (kDebugMode) {
              print('_ensureMapContainer: Platform view factory called for viewId: $viewId');
            }
            return _mapContainer!;
          },
        );
        if (kDebugMode) {
          print('_ensureMapContainer: Platform view registered successfully');
        }
      } catch (e) {
        // Already registered, that's fine
        if (kDebugMode) {
          print('Platform view already registered or error: $e');
        }
      }

      // Verify container is accessible
      final verifyElement = html.document.getElementById(_mapId);
      if (kDebugMode) {
        print('_ensureMapContainer: Verification - element found: ${verifyElement != null}, element ID: ${verifyElement?.id}');
      }

      // Initialize the map after a short delay to ensure registration and Google Maps is loaded
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _mapContainer != null) {
          if (kDebugMode) {
            print('_ensureMapContainer: Delayed initialization starting');
          }
          _initializeMap();
        } else {
          if (kDebugMode) {
            print('_ensureMapContainer: Delayed initialization skipped - mounted: $mounted, container: ${_mapContainer != null}');
          }
        }
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error creating map container: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }
}

