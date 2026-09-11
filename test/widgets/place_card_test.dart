import 'package:find_nearby/core/widgets/place_card.dart';
import 'package:find_nearby/data/datasources/mock_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('place card shows name, rating, and actions', (tester) async {
    final place = MockPlaces.all().firstWhere(
      (item) => item.providerPlaceId == 'emirates-hospital',
    );
    var opened = false;
    var called = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaceCard(
            place: place,
            isFavorite: false,
            onOpen: () => opened = true,
            onFavorite: () {},
            onCall: () => called = true,
            onDirections: () {},
          ),
        ),
      ),
    );

    expect(find.text('Emirates Specialty Hospital'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);
    expect(find.text('Open now'), findsOneWidget);

    await tester.tap(find.text('Emirates Specialty Hospital'));
    expect(opened, isTrue);
    await tester.tap(find.text('Call'));
    expect(called, isTrue);
  });

  testWidgets('place card disables call when phone is missing', (tester) async {
    final place = MockPlaces.all().firstWhere(
      (item) => item.providerPlaceId == 'kulfi-bar',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaceCard(
            place: place,
            isFavorite: false,
            onOpen: () {},
            onFavorite: () {},
            onCall: () {},
            onDirections: () {},
          ),
        ),
      ),
    );

    final call = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Call'),
    );
    expect(call.onPressed, isNull);
    expect(find.text('No ratings yet'), findsOneWidget);
  });
}
