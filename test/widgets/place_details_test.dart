import 'package:drift/native.dart';
import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/data/datasources/geolocator_location_service.dart';
import 'package:find_nearby/data/database/app_database.dart';
import 'package:find_nearby/data/repositories/mock_place_repository.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/features/location/application/location_controller.dart';
import 'package:find_nearby/features/places/application/place_cache_service.dart';
import 'package:find_nearby/features/places/presentation/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('place details shows phone and actions', (tester) async {
    final id = Place.composeId(PlaceSource.mock, 'emirates-hospital');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith(
            (ref) => AppDatabase(NativeDatabase.memory()),
          ),
          placeRepositoryProvider.overrideWithValue(MockPlaceRepository()),
          placeCacheServiceProvider.overrideWith(
            (ref) => PlaceCacheService(
              cache: ref.watch(placeCacheRepositoryProvider),
              places: MockPlaceRepository(),
            ),
          ),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
          locationServiceProvider.overrideWithValue(
            FixedLocationService(testLocation),
          ),
        ],
        child: MaterialApp(home: PlaceDetailsScreen(placeId: id)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Emirates Specialty Hospital'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);
    expect(find.textContaining('+971'), findsOneWidget);
  });
}
