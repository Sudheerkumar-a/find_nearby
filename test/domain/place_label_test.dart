import 'package:find_nearby/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('categoryLabel title-cases words and replaces underscores', () {
    const place = Place(
      id: 'x',
      provider: PlaceSource.googlePlaces,
      providerPlaceId: 'x',
      name: 'Office',
      latitude: 0,
      longitude: 0,
      subcategory: 'govement_build',
      category: 'point_of_interest',
    );

    expect(place.primaryCategory, 'Govement Build');
    expect(place.categoryLabel, 'Govement Build');
  });
}
