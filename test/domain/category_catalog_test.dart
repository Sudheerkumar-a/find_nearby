import 'package:find_nearby/core/constants/category_catalog.dart';
import 'package:find_nearby/domain/entities/place_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default catalog has the seven main categories', () {
    expect(CategoryCatalog.defaults.map((c) => c.id).toList(), [
      'food',
      'travel',
      'education',
      'health',
      'shopping',
      'services',
      'entertainment',
    ]);
  });

  test('food includes restaurants and cafes with PlaceCategory', () {
    final food = CategoryCatalog.byId('food');
    expect(food, isNotNull);
    expect(
      food!.subcategories.map((s) => s.id),
      containsAll(['restaurants', 'cafes']),
    );
    expect(
      food.subcategories.firstWhere((s) => s.id == 'restaurants').placeCategory,
      PlaceCategory.restaurant,
    );
  });

  test('applyPreferences can disable and reorder', () {
    final merged = CategoryCatalog.applyPreferences(
      defaults: CategoryCatalog.defaults,
      prefs: {
        'food': (enabled: false, sortOrder: 10),
        'health': (enabled: true, sortOrder: 0),
      },
      custom: const [],
    );
    expect(merged.first.id, 'health');
    expect(merged.firstWhere((c) => c.id == 'food').enabled, isFalse);
  });
}
