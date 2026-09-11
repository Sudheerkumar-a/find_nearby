import 'package:find_nearby/data/mappers/geoapify_category_mapper.dart';
import 'package:find_nearby/data/mappers/google_category_mapper.dart';
import 'package:find_nearby/domain/entities/place_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeoapifyCategoryMapper', () {
    test('maps required categories to hierarchical Geoapify keys', () {
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.restaurant),
        'catering.restaurant',
      );
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.cafe),
        'catering.cafe',
      );
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.fastFood),
        'catering.fast_food',
      );
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.hospital),
        'healthcare.hospital',
      );
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.pharmacy),
        'healthcare.pharmacy',
      );
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.school),
        'education.school',
      );
    });

    test('never maps to invalid restaurants plural', () {
      for (final category in PlaceCategory.values) {
        final mapped = GeoapifyCategoryMapper.categoryOf(category);
        expect(mapped, isNot('restaurants'));
        expect(mapped, isNot('restaurant'));
        expect(
          GeoapifyCategoryMapper.isValidGeoapifyCategory(mapped),
          isTrue,
          reason: '$category → $mapped',
        );
      }
    });

    test('rejects restaurants as a Geoapify category', () {
      expect(
        GeoapifyCategoryMapper.isValidGeoapifyCategory('restaurants'),
        isFalse,
      );
    });

    test('uses documented electronics spelling', () {
      expect(
        GeoapifyCategoryMapper.categoryOf(PlaceCategory.electronics),
        'commercial.elektronics',
      );
    });
  });

  group('GoogleCategoryMapper', () {
    test('maps core categories to Google Places types', () {
      expect(
        GoogleCategoryMapper.typeOf(PlaceCategory.restaurant),
        'restaurant',
      );
      expect(GoogleCategoryMapper.typeOf(PlaceCategory.cafe), 'cafe');
      expect(
        GoogleCategoryMapper.typeOf(PlaceCategory.fastFood),
        'fast_food_restaurant',
      );
      expect(GoogleCategoryMapper.typeOf(PlaceCategory.hotel), 'hotel');
      expect(GoogleCategoryMapper.typeOf(PlaceCategory.hospital), 'hospital');
      expect(GoogleCategoryMapper.typeOf(PlaceCategory.pharmacy), 'pharmacy');
      expect(GoogleCategoryMapper.typeOf(PlaceCategory.school), 'school');
      expect(
        GoogleCategoryMapper.typeOf(PlaceCategory.university),
        'university',
      );
      expect(
        GoogleCategoryMapper.typeOf(PlaceCategory.supermarket),
        'supermarket',
      );
    });

    test('covers every PlaceCategory', () {
      for (final category in PlaceCategory.values) {
        expect(
          GoogleCategoryMapper.typeOf(category),
          isNotNull,
          reason: category.name,
        );
      }
    });
  });
}
