import 'package:drift/drift.dart';

import '../../core/constants/cache_config.dart';
import '../../domain/entities/place.dart';
import '../database/app_database.dart';
import '../mappers/cached_place_mapper.dart';

final class DriftPlaceCacheRepository {
  DriftPlaceCacheRepository(this._db);

  final AppDatabase _db;

  Future<CachedPlace?> getById(String googlePlaceId) {
    return (_db.select(_db.cachedPlaces)
          ..where((row) => row.googlePlaceId.equals(googlePlaceId)))
        .getSingleOrNull();
  }

  Future<Map<String, CachedPlace>> getByIds(Iterable<String> googlePlaceIds) async {
    final ids = googlePlaceIds.toSet().toList();
    if (ids.isEmpty) return const {};

    final rows = await (_db.select(_db.cachedPlaces)
          ..where((row) => row.googlePlaceId.isIn(ids)))
        .get();
    return {for (final row in rows) row.googlePlaceId: row};
  }

  bool isBasicFresh(CachedPlace row) =>
      _isFresh(row.detailsUpdated, CacheConfig.placeBasicTtl);

  bool isRatingFresh(CachedPlace row) =>
      _isFresh(row.ratingUpdated, CacheConfig.ratingTtl);

  bool isOpeningFresh(CachedPlace row) =>
      _isFresh(row.openingStatusUpdated, CacheConfig.openingStatusTtl);

  bool isFullyFresh(CachedPlace row) =>
      isBasicFresh(row) && isRatingFresh(row) && isOpeningFresh(row);

  bool needsGoogleRefresh(CachedPlace row) => !isFullyFresh(row);

  Future<void> upsertFromPlace(Place place, {required bool fromDetails}) async {
    final existing = await getById(place.providerPlaceId);
    final now = DateTime.now();
    final basicUpdated = fromDetails ? now : existing?.detailsUpdated;
    final ratingUpdated = fromDetails && _hasRating(place)
        ? now
        : existing?.ratingUpdated;
    final openingUpdated = fromDetails && _hasOpening(place)
        ? now
        : existing?.openingStatusUpdated;

    await _db.into(_db.cachedPlaces).insertOnConflictUpdate(
      CachedPlacesCompanion(
        googlePlaceId: Value(place.providerPlaceId),
        provider: Value(place.provider.name),
        name: Value(place.name),
        latitude: Value(place.latitude),
        longitude: Value(place.longitude),
        address: Value(place.address ?? existing?.address),
        phoneNumber: Value(place.phoneNumber ?? existing?.phoneNumber),
        website: Value(place.website ?? existing?.website),
        rating: Value(place.rating ?? existing?.rating),
        reviewCount: Value(place.reviewCount ?? existing?.reviewCount),
        isOpen: Value(place.isOpen ?? existing?.isOpen),
        category: Value(place.category ?? existing?.category),
        subcategory: Value(place.subcategory ?? existing?.subcategory),
        openingHours: Value(
          place.openingHours.isNotEmpty
              ? CachedPlaceMapper.encodeStringList(place.openingHours)
              : existing?.openingHours,
        ),
        photos: Value(
          place.photos.isNotEmpty
              ? CachedPlaceMapper.encodeStringList(place.photos)
              : existing?.photos,
        ),
        description: Value(place.description ?? existing?.description),
        lastUpdated: Value(now),
        detailsUpdated: Value(basicUpdated),
        ratingUpdated: Value(ratingUpdated),
        openingStatusUpdated: Value(openingUpdated),
      ),
    );
  }

  static bool _isFresh(DateTime? updated, Duration ttl) {
    if (updated == null) return false;
    return DateTime.now().difference(updated) <= ttl;
  }

  static bool _hasRating(Place place) =>
      place.rating != null || place.reviewCount != null;

  static bool _hasOpening(Place place) =>
      place.isOpen != null || place.openingHours.isNotEmpty;
}
