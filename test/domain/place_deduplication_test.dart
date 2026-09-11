import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/services/place_deduplication_service.dart';
import 'package:flutter_test/flutter_test.dart';

Place _place({
  required PlaceSource provider,
  required String id,
  required String name,
  required double lat,
  required double lng,
  String? phone,
  String? website,
  double? rating,
}) {
  return Place(
    id: Place.composeId(provider, id),
    provider: provider,
    providerPlaceId: id,
    name: name,
    latitude: lat,
    longitude: lng,
    phoneNumber: phone,
    website: website,
    rating: rating,
  );
}

void main() {
  test('merges same restaurant from Google and Geoapify', () {
    final google = _place(
      provider: PlaceSource.googlePlaces,
      id: 'ChIJ',
      name: 'ABC Restaurant',
      lat: 25.123,
      lng: 55.123,
      rating: 4.5,
    );
    final geo = _place(
      provider: PlaceSource.geoapify,
      id: 'osm1',
      name: 'ABC Restaurant',
      lat: 25.1231,
      lng: 55.1231,
      phone: '+971500000000',
    );

    final result = PlaceDeduplicationService.dedupe([google, geo]);
    expect(result, hasLength(1));
    expect(result.single.hasPhone, isTrue);
    expect(result.single.hasRating, isTrue);
  });

  test('does not merge distinct businesses with related names', () {
    final a = _place(
      provider: PlaceSource.googlePlaces,
      id: '1',
      name: 'ABC Restaurant',
      lat: 25.123,
      lng: 55.123,
    );
    final b = _place(
      provider: PlaceSource.geoapify,
      id: '2',
      name: 'ABC Restaurant Downtown',
      lat: 25.123,
      lng: 55.123,
    );

    final result = PlaceDeduplicationService.dedupe([a, b]);
    expect(result, hasLength(2));
  });

  test('merges on matching phone even with slight name variance', () {
    final a = _place(
      provider: PlaceSource.googlePlaces,
      id: '1',
      name: 'Life Pharmacy',
      lat: 25.2,
      lng: 55.27,
      phone: '+971 4 344 1122',
    );
    final b = _place(
      provider: PlaceSource.geoapify,
      id: '2',
      name: 'Life Pharmacy LLC',
      lat: 25.2002,
      lng: 55.2701,
      phone: '97143441122',
    );

    expect(PlaceDeduplicationService.dedupe([a, b]), hasLength(1));
  });
}
