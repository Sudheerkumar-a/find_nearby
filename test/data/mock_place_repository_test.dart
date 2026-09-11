import 'package:find_nearby/data/datasources/mock_places.dart';
import 'package:find_nearby/data/repositories/mock_place_repository.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/repositories/place_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockPlaceRepository repository;

  setUp(() {
    repository = MockPlaceRepository();
  });

  test('nearby search returns places around downtown', () async {
    final page = await repository.searchNearby(
      NearbyQuery(origin: MockPlaces.downtown, radiusMeters: 5000),
    );
    expect(page.places, isNotEmpty);
    expect(page.places.every((place) => place.distanceMeters != null), isTrue);
  });

  test('text search finds hospitals', () async {
    final page = await repository.searchByText(
      TextSearchQuery(
        query: 'hospital',
        origin: MockPlaces.downtown,
        radiusMeters: 10000,
      ),
    );
    expect(page.places, isNotEmpty);
    expect(page.places.first.name.toLowerCase(), contains('hospital'));
  });

  test('details load a known place and reject unknown ids', () async {
    final known = await repository.getPlaceDetails(
      Place.composeId(PlaceSource.mock, 'life-pharmacy'),
    );
    expect(known?.name, 'Life Pharmacy');
    expect(known?.hasPhone, isTrue);

    expect(
      () => repository.getPlaceDetails('missing'),
      throwsA(isA<Exception>()),
    );
  });

  test('places without phone or rating stay usable', () {
    final kulfi = MockPlaces.all().firstWhere(
      (p) => p.providerPlaceId == 'kulfi-bar',
    );
    expect(kulfi.hasPhone, isFalse);
    expect(kulfi.hasRating, isFalse);
    expect(kulfi.hasWebsite, isFalse);
  });
}
