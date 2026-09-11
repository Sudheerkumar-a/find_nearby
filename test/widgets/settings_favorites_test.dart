import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('settings tab shows theme and categories', (tester) async {
    await pumpFindNearby(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Manage Categories'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Search Radius'), findsOneWidget);
  });

  testWidgets('favorites empty state', (tester) async {
    await pumpFindNearby(tester);
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet'), findsOneWidget);
  });
}
