import 'package:find_nearby/data/mappers/google_place_mapper.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a complete Places JSON object', () {
    final place = GooglePlaceMapper.fromJson({
      'id': 'ChIJabc',
      'displayName': {'text': 'Life Pharmacy'},
      'formattedAddress': 'Sheikh Zayed Road, Dubai',
      'location': {'latitude': 25.2, 'longitude': 55.27},
      'rating': 4.5,
      'userRatingCount': 2103,
      'nationalPhoneNumber': '+971 4 344 1122',
      'websiteUri': 'https://example.com',
      'currentOpeningHours': {'openNow': true},
      'types': ['pharmacy', 'health'],
      'editorialSummary': {'text': 'A local pharmacy.'},
      'photos': [
        {'name': 'places/ChIJabc/photos/AAA'},
      ],
      'priceLevel': 'PRICE_LEVEL_MODERATE',
    }, apiKey: 'test-key');

    expect(place, isNotNull);
    expect(place!.provider, PlaceSource.googlePlaces);
    expect(place.name, 'Life Pharmacy');
    expect(place.hasPhone, isTrue);
    expect(place.hasWebsite, isTrue);
    expect(place.isOpen, isTrue);
    expect(place.category, 'Health');
    expect(place.priceLevel, 2);
    expect(place.photos.single, contains('test-key'));
  });

  test('returns null when coordinates are missing', () {
    expect(GooglePlaceMapper.fromJson({'id': 'x'}, apiKey: null), isNull);
  });

  test('keeps nullable fields empty instead of crashing', () {
    final place = GooglePlaceMapper.fromJson({
      'id': 'ChIJxyz',
      'displayName': {'text': 'Park'},
      'location': {'latitude': 25.1, 'longitude': 55.2},
      'types': ['park'],
    }, apiKey: null);

    expect(place!.hasPhone, isFalse);
    expect(place.hasWebsite, isFalse);
    expect(place.hasRating, isFalse);
    expect(place.hasPhotos, isFalse);
    expect(place.openingHours, isEmpty);
  });
}
