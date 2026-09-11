import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/entities/search_filters.dart';
import 'package:find_nearby/domain/repositories/place_repository.dart';
import 'package:find_nearby/domain/services/place_ranking_service.dart';
import 'package:find_nearby/data/repositories/hybrid_place_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Place _p({
  required String id,
  required PlaceSource provider,
  double? distance,
  double? rating,
  int? reviews,
  bool? isOpen,
  String? phone,
}) {
  return Place(
    id: Place.composeId(provider, id),
    provider: provider,
    providerPlaceId: id,
    name: id,
    latitude: 25.2,
    longitude: 55.27,
    distanceMeters: distance,
    rating: rating,
    reviewCount: reviews,
    isOpen: isOpen,
    phoneNumber: phone,
  );
}

final class _FixedRepo implements PlaceRepository {
  _FixedRepo(this.places, {this.error});

  final List<Place> places;
  final Object? error;

  @override
  Future<PlacePage> searchNearby(NearbyQuery query) async {
    if (error != null) throw error!;
    return PlacePage(places: places);
  }

  @override
  Future<PlacePage> searchByText(TextSearchQuery query) async {
    if (error != null) throw error!;
    return PlacePage(places: places);
  }

  @override
  Future<Place?> getPlaceDetails(String placeId) async => null;

  @override
  Future<List<String>> getPlacePhotos(String placeId) async => const [];
}

void main() {
  test('ranks by distance first, then open status on ties', () {
    final ranked = PlaceRankingService.rank([
      _p(
        id: 'far-open',
        provider: PlaceSource.googlePlaces,
        distance: 2000,
        isOpen: true,
      ),
      _p(
        id: 'near-closed',
        provider: PlaceSource.geoapify,
        distance: 100,
        isOpen: false,
      ),
      _p(
        id: 'near-open',
        provider: PlaceSource.googlePlaces,
        distance: 100,
        isOpen: true,
        phone: '1',
      ),
    ], sort: SortOption.nearest);

    expect(ranked.first.providerPlaceId, 'near-open');
    expect(ranked.last.providerPlaceId, 'far-open');
  });

  test('ranks highest rated when that sort is selected', () {
    final ranked = PlaceRankingService.rank([
      _p(id: 'low', provider: PlaceSource.geoapify, rating: 3.2, distance: 10),
      _p(
        id: 'high',
        provider: PlaceSource.googlePlaces,
        rating: 4.8,
        distance: 900,
      ),
    ], sort: SortOption.highestRated);

    expect(ranked.first.providerPlaceId, 'high');
  });

  test('hybrid keeps Google results when Geoapify fails', () async {
    final hybrid = HybridPlaceRepository(
      google: _FixedRepo([
        _p(id: 'g1', provider: PlaceSource.googlePlaces, distance: 50),
      ]),
      geoapify: _FixedRepo(const [], error: Exception('down')),
    );

    final page = await hybrid.searchNearby(
      const NearbyQuery(origin: GeoPoint(25.2, 55.27), radiusMeters: 2000),
    );
    expect(page.places.map((p) => p.providerPlaceId), ['g1']);
  });

  test('hybrid keeps Geoapify results when Google fails', () async {
    final hybrid = HybridPlaceRepository(
      google: _FixedRepo(const [], error: Exception('down')),
      geoapify: _FixedRepo([
        _p(id: 'a1', provider: PlaceSource.geoapify, distance: 80),
      ]),
    );

    final page = await hybrid.searchNearby(
      const NearbyQuery(origin: GeoPoint(25.2, 55.27), radiusMeters: 2000),
    );
    expect(page.places.map((p) => p.providerPlaceId), ['a1']);
  });

  test('hybrid throws when both providers fail', () async {
    final hybrid = HybridPlaceRepository(
      google: _FixedRepo(const [], error: Exception('g')),
      geoapify: _FixedRepo(const [], error: Exception('a')),
    );

    expect(
      () => hybrid.searchNearby(
        const NearbyQuery(origin: GeoPoint(25.2, 55.27), radiusMeters: 2000),
      ),
      throwsA(isA<Exception>()),
    );
  });
}
