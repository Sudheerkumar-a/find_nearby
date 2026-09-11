import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/data/datasources/geolocator_location_service.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/features/location/application/location_controller.dart';
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
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Emirates Specialty Hospital'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);
    expect(find.textContaining('+971'), findsOneWidget);
  });
}
