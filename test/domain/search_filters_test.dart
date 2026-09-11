import 'package:find_nearby/domain/entities/search_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default filters have no active count', () {
    expect(const SearchFilters().activeCount, 0);
  });

  test('counts each non-default filter', () {
    const filters = SearchFilters(
      radiusMeters: 5000,
      minRating: 4,
      openNow: true,
      categoryId: 'food',
      subcategoryId: 'cafes',
      sort: SortOption.highestRated,
    );
    expect(filters.activeCount, 6);
  });

  test('reset returns defaults', () {
    const dirty = SearchFilters(openNow: true, minRating: 4.5);
    expect(dirty.reset().activeCount, 0);
    expect(dirty.reset().openNow, isFalse);
  });
}
