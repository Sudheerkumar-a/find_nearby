import '../../core/utils/distance.dart';
import '../entities/place.dart';
import '../entities/search_filters.dart';

abstract final class PlaceFilterEngine {
  static List<Place> apply({
    required List<Place> places,
    required SearchFilters filters,
    required GeoPoint origin,
  }) {
    final withDistance = places
        .map(
          (place) => place.copyWith(
            distanceMeters: Distance.metersBetween(
              fromLat: origin.latitude,
              fromLng: origin.longitude,
              toLat: place.latitude,
              toLng: place.longitude,
            ),
          ),
        )
        .where((place) {
          final distance = place.distanceMeters ?? double.infinity;
          if (distance > filters.radiusMeters) return false;
          if (filters.minRating != null) {
            final rating = place.rating;
            if (rating == null || rating < filters.minRating!) return false;
          }
          if (filters.openNow && place.isOpen == false) return false;
          return true;
        })
        .toList();

    withDistance.sort((a, b) => _compare(a, b, filters.sort));
    return withDistance;
  }

  static int _compare(Place a, Place b, SortOption sort) {
    return switch (sort) {
      SortOption.nearest => (a.distanceMeters ?? double.infinity).compareTo(
        b.distanceMeters ?? double.infinity,
      ),
      SortOption.highestRated => (b.rating ?? 0).compareTo(a.rating ?? 0),
      SortOption.mostPopular => (b.reviewCount ?? 0).compareTo(
        a.reviewCount ?? 0,
      ),
    };
  }
}
