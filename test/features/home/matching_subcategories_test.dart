import 'package:find_nearby/domain/entities/app_category.dart';
import 'package:find_nearby/features/home/presentation/subcategory_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = [
    AppSubcategory(id: 'car_wash', name: 'Car wash'),
    AppSubcategory(id: 'cafe', name: 'Cafes'),
    AppSubcategory(id: 'atm', name: 'ATMs'),
  ];

  test('blank search keeps every subcategory', () {
    expect(matchingSubcategories(items, '  '), items);
  });

  test('search matches subcategory names ignoring case', () {
    expect(matchingSubcategories(items, 'car').map((item) => item.id), [
      'car_wash',
    ]);
    expect(matchingSubcategories(items, 'CAF').map((item) => item.id), [
      'cafe',
    ]);
  });
}
