import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_bounds.freezed.dart';

/// Geographic bounding box for map queries
@freezed
abstract class MapBounds with _$MapBounds {
  const factory MapBounds({
    required double north,  // Maximum latitude
    required double south,  // Minimum latitude
    required double east,   // Maximum longitude
    required double west,   // Minimum longitude
  }) = _MapBounds;

  const MapBounds._();

  /// Check if bounds are valid (north > south, east > west)
  bool get isValid => north > south && east > west;

  /// Check if a point is within bounds
  bool contains(double lat, double lng) {
    return lat >= south && lat <= north && lng >= west && lng <= east;
  }
}

