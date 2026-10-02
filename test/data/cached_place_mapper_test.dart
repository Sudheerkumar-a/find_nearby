import 'package:find_nearby/data/database/app_database.dart';
import 'package:find_nearby/data/mappers/cached_place_mapper.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mergeInto fills phone from cache when search result lacks it', () {
    const searchResult = Place(
      id: 'googlePlaces:abc',
      provider: PlaceSource.googlePlaces,
      providerPlaceId: 'abc',
      name: 'Cafe',
      latitude: 25.2,
      longitude: 55.27,
    );

    final cached = CachedPlace(
      googlePlaceId: 'abc',
      provider: 'googlePlaces',
      name: 'Cafe',
      latitude: 25.2,
      longitude: 55.27,
      address: 'Main St',
      phoneNumber: '+971500000000',
      website: null,
      rating: 4.5,
      reviewCount: 10,
      isOpen: true,
      category: 'Food',
      subcategory: 'Cafes',
      openingHours: null,
      photos: null,
      description: null,
      lastUpdated: DateTime(2026),
      detailsUpdated: DateTime(2026),
      ratingUpdated: DateTime(2026),
      openingStatusUpdated: DateTime(2026),
    );

    final merged = CachedPlaceMapper.mergeInto(searchResult, cached);

    expect(merged.hasPhone, isTrue);
    expect(merged.phoneNumber, '+971500000000');
    expect(merged.address, isNull);
  });
}
