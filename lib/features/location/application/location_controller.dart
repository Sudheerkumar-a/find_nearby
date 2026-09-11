import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/geolocator_location_service.dart';
import '../../../data/datasources/mock_places.dart';
import '../../../domain/entities/user_location.dart';
import '../../../domain/repositories/location_service.dart';

class LocationController extends Notifier<UserLocation> {
  @override
  UserLocation build() {
    Future<void>.microtask(refresh);
    return const UserLocation(status: LocationStatus.locating);
  }

  Future<void> refresh() async {
    state = state.copyWith(status: LocationStatus.locating, message: null);
    final next = await ref.read(locationServiceProvider).current();
    state = next;
  }

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
