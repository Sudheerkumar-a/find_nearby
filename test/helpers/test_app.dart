import 'package:find_nearby/app.dart';
import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/data/datasources/geolocator_location_service.dart';
import 'package:find_nearby/features/location/application/location_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

List<Override> testOverrides({
  FakeSettingsRepository? settings,
  FakeFavoritesRepository? favorites,
  FakeCategoryRepository? categories,
  FakeSearchHistoryRepository? history,
}) {
  return [
    settingsRepositoryProvider.overrideWithValue(
      settings ?? FakeSettingsRepository(),
    ),
    favoritesRepositoryProvider.overrideWithValue(
      favorites ?? FakeFavoritesRepository(),
    ),
    categoryRepositoryProvider.overrideWithValue(
      categories ?? FakeCategoryRepository(),
    ),
    searchHistoryRepositoryProvider.overrideWithValue(
      history ?? FakeSearchHistoryRepository(),
    ),
    locationServiceProvider.overrideWithValue(
      FixedLocationService(testLocation),
    ),
  ];
}

Future<void> pumpFindNearby(
  WidgetTester tester, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? testOverrides(),
      child: const FindNearbyApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
