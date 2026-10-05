import 'package:find_nearby/core/utils/google_place_type_priority.dart';
import 'package:find_nearby/data/mappers/google_place_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getPrimaryCategory', () {
    test('picks car_repair over generic types', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory([
          'point_of_interest',
          'car_repair',
          'establishment',
        ]),
        'Car Repair',
      );
    });

    test('picks restaurant over generic types', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory([
          'point_of_interest',
          'restaurant',
          'establishment',
        ]),
        'Restaurant',
      );
    });

    test('falls back to service when only generic types', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory([
          'point_of_interest',
          'service',
          'establishment',
        ]),
        'Service',
      );
    });

    test('handles null and empty', () {
      expect(GooglePlaceTypePriority.getPrimaryCategory(null), '');
      expect(GooglePlaceTypePriority.getPrimaryCategory([]), '');
    });

    test('falls back to first type when none recognized', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory(['custom_type_xyz']),
        'Custom Type Xyz',
      );
    });

    test('picks unknown specific type over point_of_interest', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory([
          'government_office',
          'point_of_interest',
          'establishment',
        ]),
        'Government Office',
      );
    });

    test('uses point_of_interest only when no specific type exists', () {
      expect(
        GooglePlaceTypePriority.getPrimaryCategory([
          'point_of_interest',
          'establishment',
        ]),
        'Point Of Interest',
      );
    });
  });

  test('mapper stores prioritized category on place', () {
    final place = GooglePlaceMapper.fromJson({
      'id': 'ChIJtest',
      'displayName': {'text': 'Auto Shop'},
      'location': {'latitude': 25.2, 'longitude': 55.27},
      'types': ['point_of_interest', 'car_repair', 'establishment'],
    }, apiKey: null);

    expect(place!.subcategory, 'Car Repair');
    expect(place.category, 'Services');
    expect(place.primaryCategory, 'Car Repair');
  });
}
