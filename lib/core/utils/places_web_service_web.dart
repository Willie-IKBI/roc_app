import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../logging/logger.dart';

@JS('rocPlaces')
external RocPlaces get rocPlaces;

@JS()
extension type RocPlaces._(JSObject _) implements JSObject {
  external void ensureLoaded(String apiKey, JSFunction onSuccess, JSFunction onError);
  external void autocomplete(String query, JSFunction onSuccess, JSFunction onError);
  external void reverseGeocode(double lat, double lng, JSFunction onSuccess, JSFunction onError);
  external void placeDetails(String placeId, JSFunction onSuccess, JSFunction onError);
}

/// Helper to convert JSAny? to Dart types (minimal implementation for Places/Maps use cases)
dynamic _jsToDart(JSAny? value) {
  if (value == null) return null;
  if (value is JSString) return value.toDart;
  if (value is JSNumber) return value.toDartDouble;
  if (value is JSBoolean) return value.toDart;
  if (value is JSArray) {
    final list = <dynamic>[];
    final length = value.length;
    for (var i = 0; i < length; i++) {
      list.add(_jsToDart(value[i]));
    }
    return list;
  }
  if (value is JSObject) {
    final map = <String, dynamic>{};
    final objectConstructor = globalContext['Object'] as JSObject;
    final keys = objectConstructor.callMethod('keys'.toJS, [value].toJS) as JSArray;
    final keysLength = keys.length;
    for (var i = 0; i < keysLength; i++) {
      final key = keys[i] as JSString;
      final keyStr = key.toDart;
      final propValue = value.getProperty(keyStr.toJS);
      map[keyStr] = _jsToDart(propValue);
    }
    return map;
  }
  return value;
}

class PlacesWebService {
  PlacesWebService._();

  static Completer<void>? _loader;

  static Future<void> ensureLoaded(String apiKey) {
    if (!kIsWeb) {
      AppLogger.debug(
        'ensureLoaded skipped: not running on web',
        name: 'PlacesWebService',
      );
      return Future.value();
    }
    
    if (apiKey.isEmpty) {
      final error = StateError(
        'Google Maps API key is empty. Autocomplete will not work. '
        'Set GOOGLE_MAPS_API_KEY environment variable.',
      );
      AppLogger.warn(
        error.message,
        name: 'PlacesWebService',
        error: error,
      );
      return Future.error(error);
    }
    
    // Validate API key format
    if (apiKey.length < 20) {
      AppLogger.warn(
        'Google Maps API key appears to be invalid (too short: ${apiKey.length} chars). '
        'Expected format: AIza... (typically 39 characters)',
        name: 'PlacesWebService',
      );
    }
    
    // Validate API key starts with expected prefix
    if (!apiKey.startsWith('AIza') && !apiKey.startsWith('GOCSPX')) {
      AppLogger.warn(
        'Google Maps API key format may be invalid. Expected to start with "AIza" or "GOCSPX".',
        name: 'PlacesWebService',
      );
    }
    
    _loader ??= Completer<void>();
    if (!_loader!.isCompleted) {
      AppLogger.debug(
        'Loading Google Maps Places API...',
        name: 'PlacesWebService',
      );
      
      // Use callback-based approach to avoid promise conversion issues with minified code
      // Create callbacks using toJS to ensure they can be called from JavaScript
      final onSuccess = (() {
        AppLogger.debug(
          'Google Maps Places API loaded successfully',
          name: 'PlacesWebService',
        );
        if (!_loader!.isCompleted) {
          _loader!.complete();
        }
      }).toJS;
      
      final onError = ((JSString errorMessage) {
        final errorStr = errorMessage.toDart;
        final errorStrLower = errorStr.toLowerCase();
        String userMessage = 'Failed to load Google Maps Places API';
        
        if (errorStrLower.contains('api key') || errorStrLower.contains('invalid key')) {
          userMessage = '''
Failed to load Google Maps Places API: Invalid API key.

Please check:
1. Verify GOOGLE_MAPS_API_KEY is set correctly
2. Check Google Cloud Console for API key restrictions
3. Ensure the API key has not been deleted or restricted
''';
        } else if (errorStrLower.contains('not available') || errorStrLower.contains('not loaded')) {
          userMessage = '''
Failed to load Google Maps Places API: API not available.

Please check Google Cloud Console:
1. Enable "Places API (New)"
2. Enable "Places API" (legacy fallback)
3. Enable "Maps JavaScript API"
4. Check API key restrictions allow your domain
''';
        } else {
          userMessage = 'Failed to load Google Maps Places API: $errorStr';
        }
        
        final error = StateError(userMessage);
        AppLogger.error(
          userMessage,
          name: 'PlacesWebService',
          error: error,
        );
        
        if (!_loader!.isCompleted) {
          _loader!.completeError(error);
        }
      });
      
      // Add timeout to prevent hanging
      Future.delayed(const Duration(seconds: 15), () {
        if (!_loader!.isCompleted) {
          final timeoutError = TimeoutException(
            'Google Maps Places API loading timed out after 15 seconds. '
            'Please check your internet connection and API key configuration.',
            const Duration(seconds: 15),
          );
          AppLogger.error(
            'Google Maps Places API loading timed out',
            name: 'PlacesWebService',
            error: timeoutError,
          );
          _loader!.completeError(timeoutError);
        }
      });
      
      // Call JavaScript function with callbacks
      try {
        rocPlaces.ensureLoaded(apiKey, onSuccess as JSFunction, onError as JSFunction);
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error calling rocPlaces.ensureLoaded: $e',
          name: 'PlacesWebService',
          error: e,
          stackTrace: stackTrace,
        );
        if (!_loader!.isCompleted) {
          _loader!.completeError(StateError('Failed to initialize Google Maps API loader: $e'));
        }
      }
    }
    return _loader!.future;
  }
  
  // Helper to convert JS promise to Dart Future
  static Future<T> _promiseToFuture<T>(Object promise) {
    if (!kIsWeb) {
      return Future.value(null as T);
    }
    
    try {
      final completer = Completer<T>();
      final jsPromise = promise as dynamic;
      
      // Validate that promise is not null or undefined
      if (jsPromise == null) {
        final error = StateError(
          'Invalid promise object: received null or undefined. ensurePlacesReady may not have returned a Promise.',
        );
        AppLogger.error(
          error.message,
          name: 'PlacesWebService',
          error: error,
        );
        return Future.error(error);
      }
      
      // Validate that promise has a .then method
      // Try to access .then property - if it doesn't exist or throws, it's not a valid Promise
      bool isValidPromise = false;
      String? validationError;
      try {
        // Try to access the .then property directly
        final thenProperty = (jsPromise as dynamic).then;
        // Check if .then exists
        if (thenProperty == null) {
          validationError = 'Promise object does not have .then property';
        } else {
          // Verify it's callable by checking if it's a function
          // Use a simple check - if .then exists, assume it's valid
          // The JavaScript wrapper should ensure it's always a Promise
          isValidPromise = true;
        }
      } catch (e) {
        validationError = 'Error accessing promise .then property: $e';
        AppLogger.debug(
          validationError!,
          name: 'PlacesWebService',
        );
        isValidPromise = false;
      }
      
      if (!isValidPromise) {
        final error = StateError(
          'Invalid promise object: expected JavaScript Promise with .then() method, but received invalid object. '
          '${validationError ?? "Promise validation failed"}. '
          'This usually means rocPlaces.ensureLoaded() did not return a valid Promise. '
          'Possible causes: 1. JavaScript error in ensurePlacesReady, 2. Function returned undefined/null, 3. API key configuration issue. '
          'Check browser console for JavaScript errors from [rocPlaces].',
        );
        AppLogger.error(
          error.message,
          name: 'PlacesWebService',
          error: error,
        );
        return Future.error(error);
      }
      
      // Use toJS to create callbacks that can be called from JavaScript
      final onResolve = ((JSAny? value) {
        try {
          AppLogger.debug(
            'JavaScript Promise resolved',
            name: 'PlacesWebService',
          );
          if (!completer.isCompleted) {
            completer.complete(_jsToDart(value) as T);
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error in promise resolve handler: $e',
            name: 'PlacesWebService',
            error: e,
            stackTrace: stackTrace,
          );
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      });
      
      final onReject = ((JSAny? error) {
        try {
          // Extract error message from various error types
          String errorMessage = 'Unknown error';
          final errorDart = _jsToDart(error);
          if (errorDart is String) {
            errorMessage = errorDart;
          } else if (errorDart is Map) {
            errorMessage = errorDart['message']?.toString() ?? errorDart.toString();
          } else {
            errorMessage = errorDart?.toString() ?? 'Unknown error';
          }
          
          AppLogger.warn(
            'JavaScript Promise rejected: $errorMessage',
            name: 'PlacesWebService',
            error: error,
          );
          if (!completer.isCompleted) {
            completer.completeError(StateError(errorMessage));
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Error in promise reject handler: $e',
            name: 'PlacesWebService',
            error: e,
            stackTrace: stackTrace,
          );
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      });
      
      // Call .then() with positional arguments (JavaScript Promise API)
      // Note: JavaScript Promise.then() takes two positional arguments, not named parameters
      AppLogger.debug(
        'Attaching promise handlers',
        name: 'PlacesWebService',
      );
      
      try {
        final thenMethod = (jsPromise as JSObject).getProperty('then'.toJS) as JSFunction?;
        if (thenMethod != null) {
          final args = [onResolve as JSAny, onReject as JSAny].toJS as JSArray;
          thenMethod.callAsFunction(args);
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error attaching promise handlers: $e',
          name: 'PlacesWebService',
          error: e,
          stackTrace: stackTrace,
        );
        if (!completer.isCompleted) {
          completer.completeError(StateError('Failed to attach promise handlers: $e'));
        }
      }
      
      // Add timeout to prevent hanging promises
      Future.delayed(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          AppLogger.warn(
            'Promise timeout after 30 seconds',
            name: 'PlacesWebService',
          );
          completer.completeError(TimeoutException(
            'Promise operation timed out after 30 seconds',
            const Duration(seconds: 30),
          ));
        }
      });
      
      return completer.future;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating promise future: $e',
        name: 'PlacesWebService',
        error: e,
        stackTrace: stackTrace,
      );
      return Future.error(StateError('Failed to convert promise to future: $e'));
    }
  }

  static Future<List<Map<String, dynamic>>> autocomplete(String query) async {
    if (!kIsWeb || query.trim().isEmpty) {
      AppLogger.debug(
        'Autocomplete skipped: not web or empty query',
        name: 'PlacesWebService',
      );
      return const [];
    }
    AppLogger.debug(
      'Starting autocomplete for query: $query',
      name: 'PlacesWebService',
    );
    await ensureLoaded(Env.googleMapsApiKey);
    
    // Use callback-based approach to avoid promise conversion issues with minified code
    final completer = Completer<List<Map<String, dynamic>>>();
    
    // Helper function to process results
    void processResult(JSAny result) {
      try {
        AppLogger.debug(
          'Autocomplete result received, processing results',
          name: 'PlacesWebService',
        );
        AppLogger.debug(
          'Result: $result',
          name: 'PlacesWebService',
        );
        
        // Convert JSAny to Dart
        final dartResult = _jsToDart(result);
        AppLogger.debug(
          'Result type: ${dartResult.runtimeType}, is List: ${dartResult is List}, is Iterable: ${dartResult is Iterable}',
          name: 'PlacesWebService',
        );
        
        // Handle different possible result types
        List<dynamic> dartified;
        if (dartResult == null) {
          AppLogger.warn(
            'Autocomplete returned null result',
            name: 'PlacesWebService',
          );
          if (!completer.isCompleted) {
            completer.complete(const []);
          }
          return;
        } else if (dartResult is List) {
          dartified = dartResult;
          AppLogger.debug(
            'Result is already a Dart List',
            name: 'PlacesWebService',
          );
        } else if (dartResult is Iterable) {
          dartified = dartResult.toList();
          AppLogger.debug(
            'Result is Iterable, converted to List',
            name: 'PlacesWebService',
          );
        } else {
          // Try to cast as List (might be a JavaScript array)
          try {
            dartified = (dartResult as List<dynamic>);
            AppLogger.debug(
              'Result cast to List<dynamic>',
              name: 'PlacesWebService',
            );
          } catch (e) {
            AppLogger.error(
              'Failed to convert result to List: $e',
              name: 'PlacesWebService',
              error: e,
            );
            if (!completer.isCompleted) {
              completer.complete(const []);
            }
            return;
          }
        }
        
        AppLogger.debug(
          'Dartified list length: ${dartified.length}',
          name: 'PlacesWebService',
        );
        
        if (dartified.isEmpty) {
          AppLogger.warn(
            'Autocomplete returned empty list',
            name: 'PlacesWebService',
          );
          if (!completer.isCompleted) {
            completer.complete(const []);
          }
          return;
        }
        
        // Manually convert JavaScript objects to Dart Maps
        // JavaScript objects from package:js/js.dart are LegacyJavaScriptObject instances
        // and cannot be converted using Map.from() - we need to access properties directly
        final mapped = <Map<String, dynamic>>[];
        for (var i = 0; i < dartified.length; i++) {
          final item = dartified[i];
          AppLogger.debug(
            'Processing item $i: $item (type: ${item.runtimeType})',
            name: 'PlacesWebService',
          );
          
          try {
            final jsObj = item is JSObject ? item : (item as JSObject);
            
            // Access properties using JS interop
            dynamic description;
            dynamic placeId;
            
            try {
              final descProp = jsObj.getProperty('description'.toJS);
              final placeIdProp = jsObj.getProperty('place_id'.toJS);
              description = descProp != null ? _jsToDart(descProp) : null;
              placeId = placeIdProp != null ? _jsToDart(placeIdProp) : null;
            } catch (e) {
              AppLogger.debug(
                'Property access failed for item $i: $e',
                name: 'PlacesWebService',
              );
            }
            
            // Convert to strings
            final descriptionStr = description?.toString() ?? '';
            final placeIdStr = placeId?.toString() ?? '';
            
            AppLogger.debug(
              'Item $i extracted - description: "$descriptionStr", place_id: "$placeIdStr"',
              name: 'PlacesWebService',
            );
            
            if (descriptionStr.isEmpty || placeIdStr.isEmpty) {
              AppLogger.warn(
                'Item $i missing required fields - skipping',
                name: 'PlacesWebService',
              );
              continue;
            }
            
            mapped.add(<String, dynamic>{
              'description': descriptionStr,
              'place_id': placeIdStr,
            });
          } catch (error) {
            AppLogger.error(
              'Failed to convert item $i: $error',
              name: 'PlacesWebService',
              error: error,
            );
            // Continue processing other items
          }
        }
        
        AppLogger.debug(
          'Autocomplete returned ${mapped.length} suggestions after conversion (from ${dartified.length} items)',
          name: 'PlacesWebService',
        );
        if (!completer.isCompleted) {
          completer.complete(mapped);
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error processing autocomplete result: $e',
          name: 'PlacesWebService',
          error: e,
          stackTrace: stackTrace,
        );
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    }
    
    // Create callbacks using toJS
    final onSuccess = ((JSAny result) {
      processResult(result);
    }).toJS;
    
    final onError = ((JSString errorMessage) {
      final errorStr = errorMessage.toDart;
      final errorStrLower = errorStr.toLowerCase();
      
      // Provide helpful error messages for common Google Console issues
      String userFriendlyMessage = 'Failed to get autocomplete suggestions';
      if (errorStrLower.contains('api key') || errorStrLower.contains('invalid key')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: API key issue.

Please check your Google Cloud Console:
1. Verify the API key is correct in your environment variables
2. Ensure "Places API (New)" is enabled
3. Ensure "Places API" (legacy) is enabled as fallback
4. Ensure "Maps JavaScript API" is enabled
5. Check API key restrictions (HTTP referrer, IP) allow your domain
6. Verify billing is enabled for your Google Cloud project
''';
      } else if (errorStrLower.contains('quota') || errorStrLower.contains('limit')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Quota exceeded.

Please check your Google Cloud Console:
1. Check if you've exceeded your API quota
2. Verify billing is enabled
3. Consider upgrading your plan if needed
''';
      } else if (errorStrLower.contains('billing') || errorStrLower.contains('payment')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Billing issue.

Please check your Google Cloud Console:
1. Ensure billing is enabled for your project
2. Verify your payment method is valid
3. Places API requires billing to be enabled
''';
      } else if (errorStrLower.contains('not available') || errorStrLower.contains('not loaded')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Places API not loaded.

This might indicate:
1. The Google Maps script failed to load
2. Network connectivity issues
3. API key restrictions blocking the request
4. Check browser console for detailed errors
''';
      } else {
        userFriendlyMessage = 'Failed to get autocomplete suggestions: $errorStr';
      }
      
      final error = StateError(userFriendlyMessage);
      AppLogger.error(
        userFriendlyMessage,
        name: 'PlacesWebService',
        error: error,
      );
      
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });
    
    // Add timeout to prevent hanging
    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        final timeoutError = TimeoutException(
          'Autocomplete request timed out after 10 seconds',
          const Duration(seconds: 10),
        );
        AppLogger.error(
          'Autocomplete request timed out',
          name: 'PlacesWebService',
          error: timeoutError,
        );
        completer.completeError(timeoutError);
      }
    });
    
    // Call JavaScript function with callbacks
    try {
      AppLogger.debug(
        'Calling JavaScript autocomplete function',
        name: 'PlacesWebService',
      );
      rocPlaces.autocomplete(query, onSuccess as JSFunction, onError as JSFunction);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error calling rocPlaces.autocomplete: $e',
        name: 'PlacesWebService',
        error: e,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) {
        completer.completeError(StateError('Failed to call autocomplete: $e'));
      }
    }
    
    return completer.future;
  }

  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lng) async {
    if (!kIsWeb) {
      AppLogger.debug(
        'reverseGeocode skipped: not running on web',
        name: 'PlacesWebService',
      );
      return null;
    }
    await ensureLoaded(Env.googleMapsApiKey);
    
    // Use callback-based approach to avoid promise conversion issues with minified code
    final completer = Completer<Map<String, dynamic>?>();
    
    // Helper function to process results
    void processResult(JSAny result) {
      try {
        final dartResult = _jsToDart(result);
        AppLogger.debug(
          'Reverse geocode result received, result type: ${dartResult.runtimeType}, is null: ${dartResult == null}',
          name: 'PlacesWebService',
        );
        
        if (dartResult == null) {
          AppLogger.warn(
            'Reverse geocode returned null result',
            name: 'PlacesWebService',
          );
          if (!completer.isCompleted) {
            completer.complete(null);
          }
          return;
        }
        
        // Convert JavaScript object to Dart Map
        final jsObj = result as JSObject;
        final formattedAddress = (_jsToDart(jsObj.getProperty('formatted_address'.toJS)) as String?) ?? '';
        final geometry = jsObj.getProperty('geometry'.toJS) as JSObject?;
        final location = geometry?.getProperty('location'.toJS) as JSObject?;
        final addressComponents = _jsToDart(jsObj.getProperty('address_components'.toJS)) as List<dynamic>?;
        
        AppLogger.debug(
          'Parsed reverse geocode result - formatted_address: $formattedAddress, has geometry: ${geometry != null}, has location: ${location != null}, address_components count: ${addressComponents?.length ?? 0}',
          name: 'PlacesWebService',
        );
        
        final locationMap = location != null
            ? <String, dynamic>{
                'lat': (_jsToDart(location.getProperty('lat'.toJS)) as num?)?.toDouble() ?? lat,
                'lng': (_jsToDart(location.getProperty('lng'.toJS)) as num?)?.toDouble() ?? lng,
              }
            : <String, dynamic>{'lat': lat, 'lng': lng};
        
        final componentsList = <Map<String, dynamic>>[];
        if (addressComponents != null) {
          for (var component in addressComponents) {
            final comp = component is JSObject ? component : (component as JSObject);
            componentsList.add(<String, dynamic>{
              'long_name': (_jsToDart(comp.getProperty('long_name'.toJS)) as String?) ?? '',
              'short_name': (_jsToDart(comp.getProperty('short_name'.toJS)) as String?) ?? '',
              'types': (_jsToDart(comp.getProperty('types'.toJS)) as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
            });
          }
        }
        
        final mappedResult = <String, dynamic>{
          'formatted_address': formattedAddress,
          'geometry': <String, dynamic>{'location': locationMap},
          'address_components': componentsList,
        };
        
        AppLogger.debug(
          'Reverse geocode returning mapped result with ${componentsList.length} address components',
          name: 'PlacesWebService',
        );
        
        if (!completer.isCompleted) {
          completer.complete(mappedResult);
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error processing reverse geocode result: $e',
          name: 'PlacesWebService',
          error: e,
          stackTrace: stackTrace,
        );
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    }
    
    // Create callbacks using toJS
    final onSuccess = ((JSAny result) {
      processResult(result);
    }).toJS;
    
    final onError = ((JSString errorMessage) {
      final errorStr = errorMessage.toDart;
      AppLogger.error(
        'Failed to reverse geocode coordinates: $lat, $lng - $errorStr',
        name: 'PlacesWebService',
      );
      if (!completer.isCompleted) {
        completer.completeError(StateError('Reverse geocode failed: $errorStr'));
      }
    }).toJS;
    
    // Add timeout to prevent hanging
    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        final timeoutError = TimeoutException(
          'Reverse geocode request timed out after 10 seconds',
          const Duration(seconds: 10),
        );
        AppLogger.error(
          'Reverse geocode request timed out',
          name: 'PlacesWebService',
          error: timeoutError,
        );
        completer.completeError(timeoutError);
      }
    });
    
    // Call JavaScript function with callbacks
    try {
      AppLogger.debug(
        'Calling reverseGeocode for coordinates: $lat, $lng',
        name: 'PlacesWebService',
      );
      rocPlaces.reverseGeocode(lat, lng, onSuccess as JSFunction, onError as JSFunction);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error calling rocPlaces.reverseGeocode: $e',
        name: 'PlacesWebService',
        error: e,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) {
        completer.completeError(StateError('Failed to call reverseGeocode: $e'));
      }
    }
    
    return completer.future;
  }

  static Future<Map<String, dynamic>?> placeDetails(String placeId) async {
    if (!kIsWeb || placeId.isEmpty) {
      AppLogger.debug(
        'Place details skipped: not web or empty placeId',
        name: 'PlacesWebService',
      );
      return null;
    }
    await ensureLoaded(Env.googleMapsApiKey);
    
    // Use callback-based approach to avoid promise conversion issues with minified code
    final completer = Completer<Map<String, dynamic>?>();
    
    // Helper function to process results
    void processResult(JSAny result) {
      try {
        final dartResult = _jsToDart(result);
        if (dartResult == null) {
          AppLogger.warn(
            'Place details returned null for placeId: $placeId',
            name: 'PlacesWebService',
          );
          if (!completer.isCompleted) {
            completer.complete(null);
          }
          return;
        }
        
        AppLogger.debug(
          'Successfully received place details for placeId: $placeId',
          name: 'PlacesWebService',
        );
        
        final mappedResult = Map<String, dynamic>.from(dartResult as Map);
        if (!completer.isCompleted) {
          completer.complete(mappedResult);
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error processing place details result: $e',
          name: 'PlacesWebService',
          error: e,
          stackTrace: stackTrace,
        );
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    }
    
    // Create callbacks using toJS
    final onSuccess = ((JSAny result) {
      processResult(result);
    }).toJS;
    
    final onError = ((JSString errorMessage) {
      final errorStr = errorMessage.toDart;
      final errorStrLower = errorStr.toLowerCase();
      
      // Provide helpful error messages for common Google Console issues
      String userFriendlyMessage = 'Failed to get place details';
      if (errorStrLower.contains('api key') || errorStrLower.contains('invalid key')) {
        userFriendlyMessage = '''
Failed to get place details: API key issue.

Please check your Google Cloud Console:
1. Verify the API key is correct in your environment variables
2. Ensure "Places API (New)" is enabled
3. Ensure "Places API" (legacy) is enabled as fallback
4. Ensure "Maps JavaScript API" is enabled
5. Check API key restrictions (HTTP referrer, IP) allow your domain
6. Verify billing is enabled for your Google Cloud project
''';
      } else if (errorStrLower.contains('quota') || errorStrLower.contains('limit')) {
        userFriendlyMessage = '''
Failed to get place details: Quota exceeded.

Please check your Google Cloud Console:
1. Check if you've exceeded your API quota
2. Verify billing is enabled
3. Consider upgrading your plan if needed
''';
      } else if (errorStrLower.contains('billing') || errorStrLower.contains('payment')) {
        userFriendlyMessage = '''
Failed to get place details: Billing issue.

Please check your Google Cloud Console:
1. Ensure billing is enabled for your project
2. Verify your payment method is valid
3. Places API requires billing to be enabled
''';
      } else if (errorStrLower.contains('invalid') && errorStrLower.contains('place')) {
        userFriendlyMessage = '''
Failed to get place details: Invalid place ID.

The place ID "$placeId" may be invalid or expired.
Please try selecting the address again.
''';
      } else {
        userFriendlyMessage = 'Failed to get place details: $errorStr';
      }
      
      final error = StateError(userFriendlyMessage);
      AppLogger.error(
        userFriendlyMessage,
        name: 'PlacesWebService',
        error: error,
      );
      
      // Log additional error details for debugging
      AppLogger.debug(
        'Place details error details - placeId: $placeId, error: $errorStr',
        name: 'PlacesWebService',
      );
      
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });
    
    // Add timeout to prevent hanging
    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        final timeoutError = TimeoutException(
          'Place details request timed out after 10 seconds',
          const Duration(seconds: 10),
        );
        AppLogger.error(
          'Place details request timed out',
          name: 'PlacesWebService',
          error: timeoutError,
        );
        completer.completeError(timeoutError);
      }
    });
    
    // Call JavaScript function with callbacks
    try {
      AppLogger.debug(
        'Fetching place details for placeId: $placeId',
        name: 'PlacesWebService',
      );
      rocPlaces.placeDetails(placeId, onSuccess as JSFunction, onError as JSFunction);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error calling rocPlaces.placeDetails: $e',
        name: 'PlacesWebService',
        error: e,
        stackTrace: stackTrace,
      );
      if (!completer.isCompleted) {
        completer.completeError(StateError('Failed to call placeDetails: $e'));
      }
    }
    
    return completer.future;
  }
}

