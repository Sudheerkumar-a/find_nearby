import '../entities/user_location.dart';

abstract class LocationService {
  Future<UserLocation> current();

  Future<void> openAppSettings();

  Future<void> openLocationSettings();
}
