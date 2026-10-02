import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/datasources/geolocator_location_service.dart';
import '../../../data/datasources/mock_places.dart';
import '../../../domain/entities/user_location.dart';
import '../../../domain/repositories/location_service.dart';

class LocationController extends Notifier<UserLocation> {
  @override
  UserLocation build() {
    Future<void>.microtask(_bootstrap);
    return const UserLocation(status: LocationStatus.locating);
  }

  Future<void> _bootstrap() async {
    final saved = await ref.read(settingsRepositoryProvider).getManualLocation();
    if (saved != null) {
      state = saved;
      return;
    }
    await refresh();
  }

  Future<void> refresh() async {
    await ref.read(settingsRepositoryProvider).clearManualLocation();
    state = state.copyWith(
      status: LocationStatus.locating,
      message: null,
      source: LocationSource.device,
    );
    final next = await ref.read(locationServiceProvider).current();
    state = next;
  }

  Future<String?> setFromAddress(String query) async {
    final needle = query.trim();
    if (needle.isEmpty) return 'Enter a city or address';

    final previous = state;
    state = previous.copyWith(status: LocationStatus.locating, message: null);
    final match = await ref.read(locationServiceProvider).lookupAddress(needle);
    if (match == null) {
      state = previous;
      return 'No results found';
    }

    final next = UserLocation(
      status: LocationStatus.ready,
      point: match.point,
      label: match.label,
      source: LocationSource.manual,
    );
    await ref.read(settingsRepositoryProvider).setManualLocation(next);
    state = next;
    return null;
  }

  Future<void> useDeviceLocation() => refresh();

  Future<void> openSettings() async {
    final service = ref.read(locationServiceProvider);
    if (state.status == LocationStatus.serviceDisabled) {
      await service.openLocationSettings();
    } else {
      await service.openAppSettings();
    }
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});

final locationProvider = NotifierProvider<LocationController, UserLocation>(
  LocationController.new,
);

/// Used by widget tests so Home does not request device GPS.
final testLocation = const UserLocation(
  status: LocationStatus.ready,
  point: MockPlaces.downtown,
  label: 'Downtown Dubai, UAE',
);
