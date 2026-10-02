import 'package:find_nearby/core/di/providers.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/entities/user_location.dart';
import 'package:find_nearby/domain/repositories/location_service.dart';
import 'package:find_nearby/features/location/application/location_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

final class _LookupLocationService implements LocationService {
  @override
  Future<UserLocation> current() async => testLocation;

  @override
  Future<({GeoPoint point, String label})?> lookupAddress(String query) async {
    if (query == 'Abu Dhabi') {
      return (
        point: const GeoPoint(24.4539, 54.3773),
        label: 'Abu Dhabi',
      );
    }
    return null;
  }

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}

void main() {
  test('setFromAddress saves manual location', () async {
    final settings = FakeSettingsRepository();
    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(settings),
        locationServiceProvider.overrideWithValue(_LookupLocationService()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(locationProvider.notifier).refresh();
    expect(container.read(locationProvider).label, testLocation.label);

    final error = await container
        .read(locationProvider.notifier)
        .setFromAddress('Abu Dhabi');
    expect(error, isNull);

    final location = container.read(locationProvider);
    expect(location.isManual, isTrue);
    expect(location.label, 'Abu Dhabi');
    expect(await settings.getManualLocation(), isNotNull);
  });
}
