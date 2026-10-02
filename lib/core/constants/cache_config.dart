abstract final class CacheConfig {
  /// ponytail: single TTL for now; split per-field TTLs when needed.
  static const Duration placeCacheTtl = Duration(days: 15);

  static const Duration placeBasicTtl = placeCacheTtl;
  static const Duration ratingTtl = placeCacheTtl;
  static const Duration openingStatusTtl = placeCacheTtl;
}
