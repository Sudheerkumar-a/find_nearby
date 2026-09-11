import 'place.dart';

enum LocationStatus {
  initial,
  locating,
  ready,
  denied,
  deniedForever,
  serviceDisabled,
  unavailable,
  timeout,
}

final class UserLocation {
  const UserLocation({
    required this.status,
    this.point,
    this.label = 'Current location',
    this.message,
  });

  final LocationStatus status;
  final GeoPoint? point;
  final String label;
  final String? message;

  bool get isReady => status == LocationStatus.ready && point != null;

  UserLocation copyWith({
    LocationStatus? status,
    GeoPoint? point,
    String? label,
    String? message,
  }) {
    return UserLocation(
      status: status ?? this.status,
      point: point ?? this.point,
      label: label ?? this.label,
      message: message,
    );
  }
}
