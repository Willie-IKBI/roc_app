import 'dart:async';

class PlacesWebService {
  PlacesWebService._();

  static Completer<void>? _loader;

  static Future<void> ensureLoaded(String apiKey) {
    throw UnsupportedError('PlacesWebService is only supported on Flutter Web.');
  }

  static Future<List<Map<String, dynamic>>> autocomplete(String query) {
    throw UnsupportedError('PlacesWebService is only supported on Flutter Web.');
  }

  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lng) {
    throw UnsupportedError('PlacesWebService is only supported on Flutter Web.');
  }

  static Future<Map<String, dynamic>?> placeDetails(String placeId) {
    throw UnsupportedError('PlacesWebService is only supported on Flutter Web.');
  }
}

