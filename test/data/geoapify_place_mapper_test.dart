import 'package:find_nearby/data/mappers/geoapify_place_mapper.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a Geoapify Places feature to Place', () {
    final place = GeoapifyPlaceMapper.fromFeature({
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': [55.27, 25.2],
      },
      'properties': {
        'place_id': 'abc123',
        'name': 'Life Pharmacy',
        'formatted': 'Sheikh Zayed Road, Dubai',
        'lat': 25.2,
        'lon': 55.27,
        'categories': ['healthcare.pharmacy'],
        'phone': '+971 4 344 1122',
        'website': 'https://example.com',
        'distance': 420,
      },
    });

    expect(place, isNotNull);
    expect(place!.provider, PlaceSource.geoapify);
    expect(place.id, 'geoapify:abc123');
    expect(place.name, 'Life Pharmacy');
    expect(place.hasPhone, isTrue);
    expect(place.hasWebsite, isTrue);
    expect(place.isOpen, isNull);
    expect(place.category, 'Health');
    expect(place.distanceMeters, 420);
  });

  test('returns null when coordinates are missing', () {
    expect(
      GeoapifyPlaceMapper.fromFeature({
        'properties': {'place_id': 'x', 'name': 'Nope'},
      }),
      isNull,
    );
  });

  test('keeps sparse fields nullable', () {
    final place = GeoapifyPlaceMapper.fromFeature({
      'geometry': {
        'type': 'Point',
        'coordinates': [55.2, 25.1],
      },
      'properties': {
        'place_id': 'park1',
        'name': 'Park',
        'categories': ['leisure.park'],
      },
    });

    expect(place!.hasPhone, isFalse);
    expect(place.hasWebsite, isFalse);
    expect(place.hasRating, isFalse);
    expect(place.hasPhotos, isFalse);
  });
}
