import '../../core/errors/app_exception.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/services/place_filter_engine.dart';
import '../datasources/mock_places.dart';
import '../mappers/google_category_mapper.dart';

final class MockPlaceRepository implements PlaceRepository {
  MockPlaceRepository({List<Place>? places})
    : _places = places ?? MockPlaces.all();

  final List<Place> _places;

  @override
  Future<PlacePage> searchNearby(NearbyQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return PlacePage(places: _filter(query.origin, query));
  }

  @override
  Future<PlacePage> searchByText(TextSearchQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final needle = query.query.trim().toLowerCase();
    final matches = _places.where((place) {
      final haystack = [
        place.name,
        place.category,
        place.subcategory,
        place.address,
        place.description,
      ].whereType<String>().join(' ').toLowerCase();
      return haystack.contains(needle);
    }).toList();

    final filtered = PlaceFilterEngine.apply(
      places: matches.map((place) => _rebased(place, query.origin)).toList(),
      filters: SearchFilters(
        radiusMeters: query.radiusMeters,
        openNow: query.openNow ?? false,
      ),
      origin: query.origin,
    );
    return PlacePage(places: filtered);
  }

  @override
  Future<Place?> getPlaceDetails(String placeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    try {
      return _places.firstWhere(
        (place) => place.id == placeId || place.providerPlaceId == placeId,
      );
    } on StateError {
      throw const PlaceNotFoundException();
    }
  }

  @override
  Future<List<String>> getPlacePhotos(String placeId) async {
    final place = await getPlaceDetails(placeId);
    return place?.photos ?? const [];
  }

  List<Place> _filter(GeoPoint origin, NearbyQuery query) {
    var source = _places;
    final needles = <String>[
      if (query.placeCategory != null) ...[
        query.placeCategory!.name,
        query.placeCategory!.label,
        ?GoogleCategoryMapper.typeOf(query.placeCategory!),
      ],
      if (query.categoryGroup != null) query.categoryGroup!.label,
      if ((query.textQuery ?? '').trim().isNotEmpty) query.textQuery!.trim(),
    ].map((s) => s.toLowerCase()).toList();

    if (needles.isNotEmpty) {
      source = source.where((place) {
        final haystack = [
          place.category,
          place.subcategory,
          place.name,
        ].whereType<String>().join(' ').toLowerCase();
        return needles.any(
          (needle) =>
              haystack.contains(needle) || _aliasMatch(needle, haystack),
        );
      }).toList();
    }

    return PlaceFilterEngine.apply(
      places: source.map((place) => _rebased(place, origin)).toList(),
      filters: SearchFilters(
        radiusMeters: query.radiusMeters,
        openNow: query.openNow ?? false,
      ),
      origin: origin,
    );
  }

  /// ponytail: fixtures are authored around Downtown Dubai; rebase onto the user so mock works worldwide
  Place _rebased(Place place, GeoPoint origin) {
    const anchor = MockPlaces.downtown;
    return Place(
      id: place.id,
      provider: place.provider,
      providerPlaceId: place.providerPlaceId,
      name: place.name,
      category: place.category,
      subcategory: place.subcategory,
      latitude: origin.latitude + (place.latitude - anchor.latitude),
      longitude: origin.longitude + (place.longitude - anchor.longitude),
      address: place.address,
      phoneNumber: place.phoneNumber,
      website: place.website,
      rating: place.rating,
      reviewCount: place.reviewCount,
      isOpen: place.isOpen,
      openingHours: place.openingHours,
      photos: place.photos,
      description: place.description,
      priceLevel: place.priceLevel,
    );
  }

  bool _aliasMatch(String query, String haystack) {
    const aliases = {
      'hospital': 'hospital',
      'pharmacy': 'pharmac',
      'restaurant': 'restaurant',
      'cafe': 'cafe',
      'atm': 'atm',
      'hotel': 'hotel',
      'supermarket': 'supermarket',
      'car_repair': 'car service',
      'gas_station': 'gas',
      'park': 'park',
      'museum': 'museum',
      'movie_theater': 'cinema',
    };
    final alias = aliases[query];
    return alias != null && haystack.contains(alias);
  }
}
