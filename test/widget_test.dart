import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('home shows search, categories, and navigation', (tester) async {
    await pumpFindNearby(tester);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Search nearby...'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Quick'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
  });
}
