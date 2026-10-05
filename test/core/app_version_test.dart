import 'package:find_nearby/core/utils/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compare semver strings', () {
    expect(AppVersion.compare('1.0.0', '1.1.0'), lessThan(0));
    expect(AppVersion.compare('2.0.0', '1.9.9'), greaterThan(0));
    expect(AppVersion.compare('1.0.0+1', '1.0.0'), 0);
  });

  test('isOlder detects outdated app', () {
    expect(AppVersion.isOlder('1.0.0', '1.0.1'), isTrue);
    expect(AppVersion.isOlder('1.1.0', '1.0.9'), isFalse);
  });
}
