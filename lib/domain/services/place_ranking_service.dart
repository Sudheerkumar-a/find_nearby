import '../entities/place.dart';
import '../entities/search_filters.dart';

/// Central ranking so repositories stay dumb about UI sort preferences.
abstract final class PlaceRankingService {
  static List<Place> rank(
    List<Place> places, {
    SortOption sort = SortOption.nearest,
  }) {
    final copy = [...places];
    copy.sort((a, b) {
      final bySort = switch (sort) {
        SortOption.nearest => _cmp(
          a.distanceMeters ?? double.infinity,
          b.distanceMeters ?? double.infinity,
        ),
        SortOption.highestRated => _cmp(b.rating ?? -1, a.rating ?? -1),
        SortOption.mostPopular => _cmp(
          b.reviewCount ?? -1,
          a.reviewCount ?? -1,
        ),
      };
      if (bySort != 0) return bySort;

      // Tie-breakers: open now, completeness, distance.
      final openCmp = _boolRank(b.isOpen).compareTo(_boolRank(a.isOpen));
      if (openCmp != 0) return openCmp;
      final completeness = _completeness(b).compareTo(_completeness(a));
      if (completeness != 0) return completeness;
      return (a.distanceMeters ?? double.infinity).compareTo(
        b.distanceMeters ?? double.infinity,
      );
    });
    return copy;
  }

  static int _cmp(num a, num b) => a.compareTo(b);

  static int _boolRank(bool? value) => switch (value) {
    true => 2,
    false => 0,
    null => 1,
  };

  static int _completeness(Place place) {
    var score = 0;
    if (place.hasPhone) score += 3;
    if (place.hasRating) score += 2;
    if (place.hasWebsite) score += 1;
    if (place.address != null) score += 1;
    if (place.hasPhotos) score += 1;
    return score;
  }
}
