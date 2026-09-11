import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/repositories/location_service.dart';

final class GeolocatorLocationService implements LocationService {
  @override
  Future<UserLocation> current() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const UserLocation(
        status: LocationStatus.serviceDisabled,
        message: 'Location services are turned off.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return const UserLocation(
        status: LocationStatus.denied,
        message: 'Location permission is needed to find places around you.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      return const UserLocation(
        status: LocationStatus.deniedForever,
        message: 'Location access is blocked. Open settings to enable it.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: AppConstants.locationTimeout,
        ),
      );
      final point = GeoPoint(position.latitude, position.longitude);
      return UserLocation(
        status: LocationStatus.ready,
        point: point,
        label: await _labelFor(point),
      );
    } on TimeoutException {
      return const UserLocation(
        status: LocationStatus.timeout,
        message: 'Finding your location took too long. Try again.',
      );
    } catch (error) {
      return UserLocation(
        status: LocationStatus.unavailable,
        message: error is AppException
            ? error.userMessage
            : "We couldn't find your location. Try again.",
      );
    }
  }

  @override
  Future<void> openAppSettings() => ph.openAppSettings();

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<String> _labelFor(GeoPoint point) async {
    try {
      final places = await Geocoding().placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      final mark = places.firstOrNull;
      if (mark == null) return 'Current location';
      final city = mark.locality?.trim().isNotEmpty == true
          ? mark.locality
          : mark.subAdministrativeArea;
      final country = mark.country;
      final parts = [
        city,
        country,
      ].whereType<String>().where((part) => part.isNotEmpty);
      return parts.isEmpty ? 'Current location' : parts.join(', ');
    } catch (_) {
      return 'Current location';
    }
  }
}

final class FixedLocationService implements LocationService {
  FixedLocationService(this.location);

  final UserLocation location;

  @override
  Future<UserLocation> current() async => location;

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}
