import '../entities/place.dart';
import '../entities/user_location.dart';

abstract class LocationService {
  Future<UserLocation> current();

  Future<({GeoPoint point, String label})?> lookupAddress(String query);

  Future<void> openAppSettings();

  Future<void> openLocationSettings();
}
