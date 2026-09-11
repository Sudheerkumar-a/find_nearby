import 'package:find_nearby/core/utils/distance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('same point is zero meters', () {
    expect(
      Distance.metersBetween(
        fromLat: 25.2,
        fromLng: 55.27,
        toLat: 25.2,
        toLng: 55.27,
      ),
      0,
    );
  });

  test('downtown to nearby hospital is under 2 km', () {
    final meters = Distance.metersBetween(
      fromLat: 25.1972,
      fromLng: 55.2744,
      toLat: 25.2048,
      toLng: 55.2708,
    );
    expect(meters, greaterThan(500));
    expect(meters, lessThan(2000));
  });

  test('format uses meters then km', () {
    expect(Distance.format(240), '240 m');
    expect(Distance.format(1200), '1.2 km');
    expect(Distance.format(12500), '13 km');
    expect(Distance.format(null), 'Nearby');
  });
}
