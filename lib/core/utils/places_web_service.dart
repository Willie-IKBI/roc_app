import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

import '../config/env.dart';
import '../logging/logger.dart';

@JS('rocPlaces')
external RocPlaces get rocPlaces;

@JS()
@anonymous
class RocPlaces {
  external Object ensureLoaded(String apiKey);
  external Object autocomplete(String query);
  external Object reverseGeocode(double lat, double lng);
  external Object placeDetails(String placeId);
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
      // Convert JS promise to Dart Future using dart:html
      final promise = rocPlaces.ensureLoaded(apiKey);
      
      // Add timeout to prevent hanging
      final timeoutFuture = Future.delayed(const Duration(seconds: 15), () {
        throw TimeoutException(
          'Google Maps Places API loading timed out after 15 seconds. '
          'Please check your internet connection and API key configuration.',
          const Duration(seconds: 15),
        );
      });
      
      Future.any([
        _promiseToFuture(promise),
        timeoutFuture,
      ]).then((_) {
        AppLogger.debug(
          'Google Maps Places API loaded successfully',
          name: 'PlacesWebService',
        );
        if (!_loader!.isCompleted) {
          _loader!.complete();
        }
      }).catchError((error) {
        final errorStr = error.toString().toLowerCase();
        String userMessage = 'Failed to load Google Maps Places API';
        
        if (errorStr.contains('api key') || errorStr.contains('invalid key')) {
          userMessage = '''
Failed to load Google Maps Places API: Invalid API key.

Please check:
1. Verify GOOGLE_MAPS_API_KEY is set correctly
2. Check Google Cloud Console for API key restrictions
3. Ensure the API key has not been deleted or restricted
''';
        } else if (errorStr.contains('not available') || errorStr.contains('not loaded')) {
          userMessage = '''
Failed to load Google Maps Places API: API not available.

Please check Google Cloud Console:
1. Enable "Places API (New)"
2. Enable "Places API" (legacy fallback)
3. Enable "Maps JavaScript API"
4. Check API key restrictions allow your domain
''';
        }
        
        AppLogger.error(
          userMessage,
          name: 'PlacesWebService',
          error: error,
        );
        
        if (!_loader!.isCompleted) {
          _loader!.completeError(error);
        }
      });
    }
    return _loader!.future;
  }
  
  // Helper to convert JS promise to Dart Future
  static Future<T> _promiseToFuture<T>(Object promise) {
    if (!kIsWeb) {
      return Future.value(null as T);
    }
    final completer = Completer<T>();
    final jsPromise = promise as dynamic;
    
    // Use allowInterop to create callbacks that can be called from JavaScript
    final onResolve = allowInterop((value) {
      AppLogger.debug(
        'JavaScript Promise resolved',
        name: 'PlacesWebService',
      );
      if (!completer.isCompleted) {
        completer.complete(value as T);
      }
    });
    
    final onReject = allowInterop((error) {
      AppLogger.warn(
        'JavaScript Promise rejected: $error',
        name: 'PlacesWebService',
        error: error,
      );
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });
    
    // Call .then() with positional arguments (JavaScript Promise API)
    // Note: JavaScript Promise.then() takes two positional arguments, not named parameters
    AppLogger.debug(
      'Attaching promise handlers',
      name: 'PlacesWebService',
    );
    jsPromise.then(onResolve, onReject);
    
    return completer.future;
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
    try {
      AppLogger.debug(
        'Calling JavaScript autocomplete function',
        name: 'PlacesWebService',
      );
      final result = await _promiseToFuture<dynamic>(rocPlaces.autocomplete(query));
      AppLogger.debug(
        'Autocomplete promise resolved, processing results',
        name: 'PlacesWebService',
      );
      AppLogger.debug(
        'Result: $result',
        name: 'PlacesWebService',
      );
      AppLogger.debug(
        'Result type: ${result.runtimeType}, is List: ${result is List}, is Iterable: ${result is Iterable}',
        name: 'PlacesWebService',
      );
      
      // Handle different possible result types
      List<dynamic> dartified;
      if (result == null) {
        AppLogger.warn(
          'Autocomplete returned null result',
          name: 'PlacesWebService',
        );
        return const [];
      } else if (result is List) {
        dartified = result;
        AppLogger.debug(
          'Result is already a Dart List',
          name: 'PlacesWebService',
        );
      } else if (result is Iterable) {
        dartified = result.toList();
        AppLogger.debug(
          'Result is Iterable, converted to List',
          name: 'PlacesWebService',
        );
      } else {
        // Try to cast as List (might be a JavaScript array)
        try {
          dartified = (result as List<dynamic>);
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
          return const [];
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
        return const [];
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
          final jsObj = item as dynamic;
          
          // Try multiple ways to access properties
          dynamic description;
          dynamic placeId;
          
          // Method 1: Direct property access with bracket notation
          try {
            description = jsObj['description'];
            placeId = jsObj['place_id'];
          } catch (e) {
            AppLogger.debug(
              'Bracket access failed for item $i, trying dot notation',
              name: 'PlacesWebService',
            );
          }
          
          // Method 2: Try dot notation (might work for some JS objects)
          if (description == null) {
            try {
              description = (jsObj as dynamic).description;
            } catch (_) {}
          }
          if (placeId == null) {
            try {
              placeId = (jsObj as dynamic).place_id;
            } catch (_) {}
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
      return mapped;
    } catch (error, stackTrace) {
      final errorMessage = error.toString().toLowerCase();
      
      // Provide helpful error messages for common Google Console issues
      String userFriendlyMessage = 'Failed to get autocomplete suggestions';
      if (errorMessage.contains('api key') || errorMessage.contains('invalid key')) {
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
      } else if (errorMessage.contains('quota') || errorMessage.contains('limit')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Quota exceeded.

Please check your Google Cloud Console:
1. Check if you've exceeded your API quota
2. Verify billing is enabled
3. Consider upgrading your plan if needed
''';
      } else if (errorMessage.contains('billing') || errorMessage.contains('payment')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Billing issue.

Please check your Google Cloud Console:
1. Ensure billing is enabled for your project
2. Verify your payment method is valid
3. Places API requires billing to be enabled
''';
      } else if (errorMessage.contains('not available') || errorMessage.contains('not loaded')) {
        userFriendlyMessage = '''
Failed to get autocomplete suggestions: Places API not loaded.

This might indicate:
1. The Google Maps script failed to load
2. Network connectivity issues
3. API key restrictions blocking the request
4. Check browser console for detailed errors
''';
      }
      
      AppLogger.error(
        userFriendlyMessage,
        name: 'PlacesWebService',
        error: error,
        stackTrace: stackTrace,
      );
      
      // Log the original error for debugging
      AppLogger.debug(
        'Original error: $error',
        name: 'PlacesWebService',
      );
      
      return const [];
    }
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
    try {
      AppLogger.debug(
        'Calling reverseGeocode for coordinates: $lat, $lng',
        name: 'PlacesWebService',
      );
      final result = await _promiseToFuture<dynamic>(rocPlaces.reverseGeocode(lat, lng));
      
      AppLogger.debug(
        'Reverse geocode Promise resolved, result type: ${result.runtimeType}, is null: ${result == null}',
        name: 'PlacesWebService',
      );
      
      if (result == null) {
        AppLogger.warn(
          'Reverse geocode returned null result',
          name: 'PlacesWebService',
        );
        return null;
      }
      
      // Convert JavaScript object to Dart Map
      final jsObj = result as dynamic;
      final formattedAddress = jsObj['formatted_address']?.toString() ?? '';
      final geometry = jsObj['geometry'] as dynamic;
      final location = geometry?['location'] as dynamic;
      final addressComponents = jsObj['address_components'] as List<dynamic>?;
      
      AppLogger.debug(
        'Parsed reverse geocode result - formatted_address: $formattedAddress, has geometry: ${geometry != null}, has location: ${location != null}, address_components count: ${addressComponents?.length ?? 0}',
        name: 'PlacesWebService',
      );
      
      final locationMap = location != null
          ? <String, dynamic>{
              'lat': (location['lat'] as num?)?.toDouble() ?? lat,
              'lng': (location['lng'] as num?)?.toDouble() ?? lng,
            }
          : <String, dynamic>{'lat': lat, 'lng': lng};
      
      final componentsList = <Map<String, dynamic>>[];
      if (addressComponents != null) {
        for (var component in addressComponents) {
          final comp = component as dynamic;
          componentsList.add(<String, dynamic>{
            'long_name': comp['long_name']?.toString() ?? '',
            'short_name': comp['short_name']?.toString() ?? '',
            'types': (comp['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
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
      
      return mappedResult;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to reverse geocode coordinates: $lat, $lng',
        name: 'PlacesWebService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
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
    try {
      AppLogger.debug(
        'Fetching place details for placeId: $placeId',
        name: 'PlacesWebService',
      );
      final result = await _promiseToFuture<dynamic>(rocPlaces.placeDetails(placeId));
      if (result == null) {
        AppLogger.warn(
          'Place details returned null for placeId: $placeId',
          name: 'PlacesWebService',
        );
        return null;
      }
      AppLogger.debug(
        'Successfully received place details for placeId: $placeId',
        name: 'PlacesWebService',
      );
      return Map<String, dynamic>.from(result as Map);
    } catch (error, stackTrace) {
      final errorMessage = error.toString().toLowerCase();
      
      // Provide helpful error messages for common Google Console issues
      String userFriendlyMessage = 'Failed to get place details';
      if (errorMessage.contains('api key') || errorMessage.contains('invalid key')) {
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
      } else if (errorMessage.contains('quota') || errorMessage.contains('limit')) {
        userFriendlyMessage = '''
Failed to get place details: Quota exceeded.

Please check your Google Cloud Console:
1. Check if you've exceeded your API quota
2. Verify billing is enabled
3. Consider upgrading your plan if needed
''';
      } else if (errorMessage.contains('billing') || errorMessage.contains('payment')) {
        userFriendlyMessage = '''
Failed to get place details: Billing issue.

Please check your Google Cloud Console:
1. Ensure billing is enabled for your project
2. Verify your payment method is valid
3. Places API requires billing to be enabled
''';
      } else if (errorMessage.contains('invalid') && errorMessage.contains('place')) {
        userFriendlyMessage = '''
Failed to get place details: Invalid place ID.

The place ID "$placeId" may be invalid or expired.
Please try selecting the address again.
''';
      }
      
      AppLogger.error(
        userFriendlyMessage,
        name: 'PlacesWebService',
        error: error,
        stackTrace: stackTrace,
      );
      
      // Log additional error details for debugging
      AppLogger.debug(
        'Place details error details - placeId: $placeId, error: $error, error type: ${error.runtimeType}',
        name: 'PlacesWebService',
      );
      
      return null;
    }
  }
}

