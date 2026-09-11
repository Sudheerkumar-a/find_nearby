import 'dart:math' as math;

abstract final class Distance {
  static const _earthRadiusMeters = 6371000.0;

  /// Haversine distance in meters.
  static double metersBetween({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    final dLat = _radians(toLat - fromLat);
    final dLng = _radians(toLng - fromLng);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_radians(fromLat)) *
            math.cos(_radians(toLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return _earthRadiusMeters * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static String format(double? meters) {
    if (meters == null || meters.isNaN || meters.isInfinite) return 'Nearby';
    if (meters < 1000) return '${meters.round()} m';
    final km = meters / 1000;
    return km >= 10 ? '${km.round()} km' : '${km.toStringAsFixed(1)} km';
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
