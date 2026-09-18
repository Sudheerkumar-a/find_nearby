abstract final class AppConstants {
  static const String appName = 'FindNearby';
  static const String tagline = 'Find what you need, nearby.';

  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const Duration nearbyCacheTtl = Duration(minutes: 2);
  static const Duration locationTimeout = Duration(seconds: 12);

  static const double minRadiusMeters = 5000;
  static const double maxRadiusMeters = 50000;
  static const double defaultRadiusMeters = minRadiusMeters;
  static const List<double> radiusPresetsMeters = [
    5000,
    10000,
    25000,
    50000,
  ];

  static const int searchHistoryLimit = 12;
  static const int nearbyPageSize = 20;

  static const String privacyPolicyUrl =
      'https://example.com/findnearby/privacy';
  static const String termsUrl = 'https://example.com/findnearby/terms';

  static double clampRadiusMeters(double meters) =>
      meters.clamp(minRadiusMeters, maxRadiusMeters).toDouble();
}

abstract final class SettingKeys {
  static const String themeMode = 'theme_mode';
  static const String searchRadiusMeters = 'search_radius_meters';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String placeSearchMode = 'place_search_mode';
}
