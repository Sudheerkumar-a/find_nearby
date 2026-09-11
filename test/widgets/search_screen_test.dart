import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/data/datasources/geolocator_location_service.dart';
import 'package:find_nearby/features/location/application/location_controller.dart';
import 'package:find_nearby/features/search/presentation/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('search shows recent and suggestions', (tester) async {
    final history = FakeSearchHistoryRepository()..items.add('Pizza');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          searchHistoryRepositoryProvider.overrideWithValue(history),
          locationServiceProvider.overrideWithValue(
            FixedLocationService(testLocation),
          ),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(),
          ),
        ],
        child: const MaterialApp(home: SearchScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Search nearby...'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Pizza'), findsWidgets);
    expect(find.text('Hospitals'), findsOneWidget);
  });
}
