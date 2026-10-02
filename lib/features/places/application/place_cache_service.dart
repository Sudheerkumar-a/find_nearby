import '../../../core/errors/app_exception.dart';
import '../../../data/database/app_database.dart';
import '../../../data/mappers/cached_place_mapper.dart';
import '../../../data/repositories/drift_place_cache_repository.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/repositories/place_repository.dart';

final class PlaceCacheService {
  PlaceCacheService({
    required DriftPlaceCacheRepository cache,
    required PlaceRepository places,
  }) : _cache = cache,
       _places = places;

  final DriftPlaceCacheRepository _cache;
  final PlaceRepository _places;

  Future<List<Place>> enrichPlaces(List<Place> places) async {
    if (places.isEmpty) return places;

    final cached = await _cache.getByIds(places.map((p) => p.providerPlaceId));
    if (cached.isEmpty) return places;

    return [
      for (final place in places)
        _mergeListPlace(place, cached[place.providerPlaceId]),
    ];
  }

  Place _mergeListPlace(Place place, CachedPlace? cached) {
    if (cached == null || !_cache.isBasicFresh(cached)) return place;
    return CachedPlaceMapper.mergeInto(place, cached);
  }

  Future<Place> getDetails(String placeId) async {
    final providerId = _providerPlaceId(placeId);
    final cached = await _cache.getById(providerId);
    if (cached != null && !_cache.needsGoogleRefresh(cached)) {
      return CachedPlaceMapper.toPlace(cached);
    }

    final fresh = await _places.getPlaceDetails(placeId);
    if (fresh == null) throw const PlaceNotFoundException();

    await _cache.upsertFromPlace(fresh, fromDetails: true);
    return fresh;
  }

  static String _providerPlaceId(String placeId) =>
      placeId.contains(':') ? placeId.split(':').last : placeId;
}
