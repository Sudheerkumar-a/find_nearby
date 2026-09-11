import '../entities/place.dart';
import '../entities/place_category.dart';
import '../entities/search_filters.dart';

class NearbyQuery {
  const NearbyQuery({
    required this.origin,
    required this.radiusMeters,
    this.placeCategory,
    this.categoryGroup,
    this.textQuery,
    this.openNow,
    this.pageToken,
  });

  final GeoPoint origin;
  final double radiusMeters;

  /// Internal category from UI — providers map this themselves.
  final PlaceCategory? placeCategory;

  /// When only a main category chip is selected.
  final PlaceCategoryGroup? categoryGroup;

  /// Free-text / custom category query — never a provider category string.
  final String? textQuery;
  final bool? openNow;
  final String? pageToken;
}

class TextSearchQuery {
  const TextSearchQuery({
    required this.query,
    required this.origin,
    required this.radiusMeters,
    this.openNow,
    this.pageToken,
  });

  final String query;
  final GeoPoint origin;
  final double radiusMeters;
  final bool? openNow;
  final String? pageToken;
}

class PlacePage {
  const PlacePage({required this.places, this.nextPageToken});

  final List<Place> places;
  final String? nextPageToken;
}

/// App code depends on this — never on a specific provider.
abstract class PlaceRepository {
  Future<PlacePage> searchNearby(NearbyQuery query);

  Future<PlacePage> searchByText(TextSearchQuery query);

  Future<Place?> getPlaceDetails(String placeId);

  Future<List<String>> getPlacePhotos(String placeId);
}

abstract class PlaceQueryMapper {
  static NearbyQuery fromFilters({
    required GeoPoint origin,
    required SearchFilters filters,
    PlaceCategory? placeCategory,
    PlaceCategoryGroup? categoryGroup,
    String? textQuery,
  }) {
    return NearbyQuery(
      origin: origin,
      radiusMeters: filters.radiusMeters,
      placeCategory: placeCategory,
      categoryGroup: categoryGroup,
      textQuery: textQuery,
      openNow: filters.openNow ? true : null,
    );
  }
}
