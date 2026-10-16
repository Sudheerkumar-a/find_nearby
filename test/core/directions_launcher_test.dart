import 'package:find_nearby/core/utils/directions_launcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('waze link opens the route list', () {
    final uri = wazeNavigationUri(25.2, 55.27);
    expect(uri.scheme, 'https');
    expect(uri.host, 'waze.com');
    expect(uri.path, '/ul');
    expect(uri.queryParameters['ll'], '25.2,55.27');
    expect(uri.queryParameters['navigate'], 'yes');
  });
}
