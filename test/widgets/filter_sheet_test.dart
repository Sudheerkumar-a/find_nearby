import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/features/filters/presentation/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

void main() {
  testWidgets('filter sheet can apply open now and rating', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryRepositoryProvider.overrideWithValue(
            FakeCategoryRepository(),
          ),
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository(),
          ),
        ],
        child: const MaterialApp(home: FilterPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Apply Filters'), findsOneWidget);
    await tester.tap(find.text('Open now'));
    await tester.pump();
    await tester.tap(find.text('4+'));
    await tester.pump();
    expect(find.text('Filters (2)'), findsOneWidget);
  });
}
