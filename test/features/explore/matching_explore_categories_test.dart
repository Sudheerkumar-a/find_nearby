import 'package:find_nearby/domain/entities/app_category.dart';
import 'package:find_nearby/features/explore/presentation/explore_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const food = AppCategory(
    id: 'food',
    name: 'Food',
    icon: 'restaurant',
    subcategories: [
      AppSubcategory(id: 'restaurants', name: 'Restaurants'),
      AppSubcategory(id: 'cafes', name: 'Cafes'),
    ],
  );
  const health = AppCategory(
    id: 'health',
    name: 'Health',
    icon: 'health',
    subcategories: [AppSubcategory(id: 'hospitals', name: 'Hospitals')],
  );

  test('blank search keeps every category', () {
    expect(matchingExploreCategories([food, health], '  '), [food, health]);
  });

  test('category name keeps its subcategories', () {
    final matches = matchingExploreCategories([food, health], 'food');
    expect(matches, [food]);
    expect(matches.single.subcategories, food.subcategories);
  });

  test('subcategory name keeps only that match', () {
    final matches = matchingExploreCategories([food, health], 'caf');
    expect(matches.single.id, 'food');
    expect(matches.single.subcategories.map((sub) => sub.id), ['cafes']);
  });
}
