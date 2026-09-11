import 'package:find_nearby/core/utils/greeting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('greeting changes by time of day', () {
    expect(greetingFor(DateTime(2026, 1, 1, 8)), 'Good morning');
    expect(greetingFor(DateTime(2026, 1, 1, 14)), 'Good afternoon');
    expect(greetingFor(DateTime(2026, 1, 1, 20)), 'Good evening');
  });
}
