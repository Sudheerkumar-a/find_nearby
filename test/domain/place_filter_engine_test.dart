import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/entities/search_filters.dart';
import 'package:find_nearby/domain/services/place_filter_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const origin = GeoPoint(25.1972, 55.2744);

  Place place({
    required String id,
    double lat = 25.1980,
    double lng = 55.2744,
    double? rating,
    int? reviews,
    bool? isOpen = true,
  }) {
    return Place(
      id: id,
      provider: PlaceSource.mock,
      providerPlaceId: id,
      name: id,
      latitude: lat,
      longitude: lng,
      rating: rating,
      reviewCount: reviews,
      isOpen: isOpen,
    );
  }

  test('drops places outside radius', () {
    final result = PlaceFilterEngine.apply(
      places: [
        place(id: 'near'),
        place(id: 'far', lat: 25.30, lng: 55.40),
      ],
      filters: const SearchFilters(radiusMeters: 2000),
      origin: origin,
    );
    expect(result.map((p) => p.id), ['near']);
  });

  test('keeps rating threshold and open now', () {
    final result = PlaceFilterEngine.apply(
      places: [
        place(id: 'good', rating: 4.6, isOpen: true),
        place(id: 'low', rating: 3.1, isOpen: true),
        place(id: 'closed', rating: 4.9, isOpen: false),
      ],
      filters: const SearchFilters(minRating: 4, openNow: true),
      origin: origin,
    );
    expect(result.map((p) => p.id), ['good']);
  });

  test('sorts by nearest, rating, and popularity', () {
    final places = [
      place(id: 'a', lat: 25.1990, rating: 4.1, reviews: 10),
      place(id: 'b', lat: 25.1975, rating: 4.8, reviews: 3),
      place(id: 'c', lat: 25.1985, rating: 4.4, reviews: 90),
    ];

    expect(
      PlaceFilterEngine.apply(
        places: places,
        filters: const SearchFilters(sort: SortOption.nearest),
        origin: origin,
      ).map((p) => p.id),
      ['b', 'c', 'a'],
    );
    expect(
      PlaceFilterEngine.apply(
        places: places,
        filters: const SearchFilters(sort: SortOption.highestRated),
        origin: origin,
      ).map((p) => p.id),
      ['b', 'c', 'a'],
    );
    expect(
      PlaceFilterEngine.apply(
        places: places,
        filters: const SearchFilters(sort: SortOption.mostPopular),
        origin: origin,
      ).map((p) => p.id),
      ['c', 'a', 'b'],
    );
  });
}
