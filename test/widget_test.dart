import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('home shows search, categories, and navigation', (tester) async {
    await pumpFindNearby(tester);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Search nearby...'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
  });
}
