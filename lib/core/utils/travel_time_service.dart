import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../logging/logger.dart';
import '../../domain/models/address.dart';

/// Service for calculating travel time between addresses using Google Maps Distance Matrix API.
/// 
/// This service calculates driving time and distance between two or more addresses,
/// which is essential for scheduling and route optimization.
class TravelTimeService {
  TravelTimeService._();

  /// Cache for travel time results to avoid excessive API calls
  static final Map<String, TravelTimeResult> _cache = {};
  
  /// Cache expiration time (1 hour)
  static const _cacheExpiration = Duration(hours: 1);
  
  /// Maximum cache size
  static const _maxCacheSize = 1000;

  /// Calculate travel time between two addresses.
  /// 
  /// Returns the travel time in minutes, or null if calculation fails.
  /// Results are cached to minimize API calls.
  static Future<int?> calculateTravelTime({
    required Address from,
    required Address to,
  }) async {
    if (!kIsWeb) {
      AppLogger.debug(
        'Travel time calculation skipped: not running on web',
        name: 'TravelTimeService',
      );
      return null;
    }

    if (Env.googleMapsApiKey.isEmpty) {
      AppLogger.warn(
        'Google Maps API key is empty. Travel time calculation will not work.',
        name: 'TravelTimeService',
      );
      return null;
    }

    // Check cache first
    final cacheKey = _getCacheKey(from, to);
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      AppLogger.debug(
        'Using cached travel time: ${cached.durationMinutes} minutes',
        name: 'TravelTimeService',
      );
      return cached.durationMinutes;
    }

    try {
      // Build origin and destination strings
      final origin = _buildAddressString(from);
      final destination = _buildAddressString(to);

      if (origin.isEmpty || destination.isEmpty) {
        AppLogger.warn(
          'Invalid address for travel time calculation',
          name: 'TravelTimeService',
        );
        return null;
      }

      // Call Google Maps Distance Matrix API
      final uri = Uri.https('maps.googleapis.com', '/maps/api/distancematrix/json', {
        'origins': origin,
        'destinations': destination,
        'mode': 'driving',
        'key': Env.googleMapsApiKey,
        'units': 'metric', // Use metric for distance
      });

      AppLogger.debug(
        'Calculating travel time from ${from.street} to ${to.street}',
        name: 'TravelTimeService',
      );

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
            'Travel time calculation timed out',
            const Duration(seconds: 10),
          );
        },
      );

      if (response.statusCode != 200) {
        AppLogger.error(
          'Travel time API returned status ${response.statusCode}',
          name: 'TravelTimeService',
        );
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Check for API errors
      if (data['status'] != 'OK') {
        final errorMessage = data['error_message'] as String? ?? 'Unknown error';
        AppLogger.error(
          'Travel time API error: ${data['status']} - $errorMessage',
          name: 'TravelTimeService',
        );
        return null;
      }

      // Extract duration from response
      final rows = data['rows'] as List<dynamic>?;
      if (rows == null || rows.isEmpty) {
        AppLogger.warn(
          'No travel time data in API response',
          name: 'TravelTimeService',
        );
        return null;
      }

      final elements = rows[0]['elements'] as List<dynamic>?;
      if (elements == null || elements.isEmpty) {
        AppLogger.warn(
          'No travel time elements in API response',
          name: 'TravelTimeService',
        );
        return null;
      }

      final element = elements[0] as Map<String, dynamic>;
      if (element['status'] != 'OK') {
        AppLogger.warn(
          'Travel time element status: ${element['status']}',
          name: 'TravelTimeService',
        );
        return null;
      }

      final duration = element['duration'] as Map<String, dynamic>?;
      if (duration == null) {
        AppLogger.warn(
          'No duration in travel time response',
          name: 'TravelTimeService',
        );
        return null;
      }

      // Duration is in seconds, convert to minutes
      final durationSeconds = duration['value'] as int?;
      if (durationSeconds == null) {
        return null;
      }

      final durationMinutes = (durationSeconds / 60).ceil();

      // Cache the result
      _cacheResult(cacheKey, durationMinutes);

      AppLogger.debug(
        'Travel time calculated: $durationMinutes minutes',
        name: 'TravelTimeService',
      );

      return durationMinutes;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to calculate travel time',
        name: 'TravelTimeService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Calculate travel times for a sequence of addresses (route optimization).
  /// 
  /// Returns a list of travel times in minutes, where each element represents
  /// travel time from the previous address (first element is null).
  static Future<List<int?>> calculateRouteTravelTimes({
    required List<Address> addresses,
  }) async {
    if (addresses.length < 2) {
      return [null];
    }

    final travelTimes = <int?>[null]; // First address has no previous travel time

    for (int i = 1; i < addresses.length; i++) {
      final travelTime = await calculateTravelTime(
        from: addresses[i - 1],
        to: addresses[i],
      );
      travelTimes.add(travelTime);
    }

    return travelTimes;
  }

  /// Build address string for Google Maps API.
  static String _buildAddressString(Address address) {
    final parts = <String>[];
    if (address.street.isNotEmpty) parts.add(address.street);
    if (address.suburb.isNotEmpty) parts.add(address.suburb);
    if (address.city != null && address.city!.isNotEmpty) parts.add(address.city!);
    if (address.province != null && address.province!.isNotEmpty) parts.add(address.province!);
    
    // If we have coordinates, use them for more accurate results
    if (address.latitude != null && address.longitude != null) {
      return '${address.latitude},${address.longitude}';
    }
    
    return parts.join(', ');
  }

  /// Generate cache key from addresses.
  static String _getCacheKey(Address from, Address to) {
    final fromKey = '${from.latitude ?? 0},${from.longitude ?? 0}';
    final toKey = '${to.latitude ?? 0},${to.longitude ?? 0}';
    return '$fromKey|$toKey';
  }

  /// Cache a travel time result.
  static void _cacheResult(String key, int durationMinutes) {
    // Remove oldest entries if cache is too large
    if (_cache.length >= _maxCacheSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }

    _cache[key] = TravelTimeResult(
      durationMinutes: durationMinutes,
      timestamp: DateTime.now(),
    );
  }

  /// Clear the travel time cache.
  static void clearCache() {
    _cache.clear();
  }

  /// Get cache statistics (for debugging).
  static Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    final validEntries = _cache.values.where((r) => !r.isExpiredAt(now)).length;
    final expiredEntries = _cache.length - validEntries;

    return {
      'total': _cache.length,
      'valid': validEntries,
      'expired': expiredEntries,
    };
  }
}

/// Cached travel time result.
class TravelTimeResult {
  TravelTimeResult({
    required this.durationMinutes,
    required this.timestamp,
  });

  final int durationMinutes;
  final DateTime timestamp;

  bool get isExpired {
    return isExpiredAt(DateTime.now());
  }

  bool isExpiredAt(DateTime now) {
    return now.difference(timestamp) > TravelTimeService._cacheExpiration;
  }
}

