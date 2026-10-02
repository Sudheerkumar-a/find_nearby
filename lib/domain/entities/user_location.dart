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

enum LocationSource { device, manual }

final class UserLocation {
  const UserLocation({
    required this.status,
    this.point,
    this.label = 'Current location',
    this.message,
    this.source = LocationSource.device,
  });

  final LocationStatus status;
  final GeoPoint? point;
  final String label;
  final String? message;
  final LocationSource source;

  bool get isReady => status == LocationStatus.ready && point != null;
  bool get isManual => source == LocationSource.manual;

  UserLocation copyWith({
    LocationStatus? status,
    GeoPoint? point,
    String? label,
    String? message,
    LocationSource? source,
  }) {
    return UserLocation(
      status: status ?? this.status,
      point: point ?? this.point,
      label: label ?? this.label,
      message: message,
      source: source ?? this.source,
    );
  }
}
