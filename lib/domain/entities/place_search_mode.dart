/// How FindNearby chooses place-data backends.
enum PlaceSearchMode {
  /// Parallel Google + Geoapify, then dedupe + rank.
  automatic,

  /// Google Places only.
  google,

  /// Geoapify only.
  geoapify,

  /// Local fixtures (no network).
  mock,
}

extension PlaceSearchModeX on PlaceSearchMode {
  String get label => switch (this) {
    PlaceSearchMode.automatic => 'Automatic',
    PlaceSearchMode.google => 'Google',
    PlaceSearchMode.geoapify => 'Geoapify',
    PlaceSearchMode.mock => 'Mock',
  };

  static PlaceSearchMode parse(
    String? raw, {
    PlaceSearchMode fallback = PlaceSearchMode.automatic,
  }) {
    final value = raw?.trim().toLowerCase();
    return switch (value) {
      'automatic' || 'hybrid' || 'auto' => PlaceSearchMode.automatic,
      'google' => PlaceSearchMode.google,
      'geoapify' => PlaceSearchMode.geoapify,
      'mock' => PlaceSearchMode.mock,
      _ => fallback,
    };
  }
}
