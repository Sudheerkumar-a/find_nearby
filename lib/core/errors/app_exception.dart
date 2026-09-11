sealed class AppException implements Exception {
  const AppException(this.userMessage, {this.cause});

  final String userMessage;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $userMessage';
}

final class NetworkException extends AppException {
  const NetworkException({
    String message =
        "We couldn't reach the network. Please check your connection and try again.",
    Object? cause,
  }) : super(message, cause: cause);
}

final class ApiException extends AppException {
  const ApiException({
    this.statusCode,
    String message = "We couldn't load places right now. Please try again.",
    Object? cause,
  }) : super(message, cause: cause);

  final int? statusCode;

  factory ApiException.fromStatus(int? status, {Object? cause}) {
    return switch (status) {
      401 || 403 => ApiException(
        statusCode: status,
        message:
            'The Places API key is missing or not allowed. Check your Google Cloud setup.',
        cause: cause,
      ),
      429 => ApiException(
        statusCode: status,
        message:
            'Too many place lookups right now. Please wait a moment and try again.',
        cause: cause,
      ),
      _ => ApiException(statusCode: status, cause: cause),
    };
  }
}

final class LocationUnavailableException extends AppException {
  const LocationUnavailableException({
    String message =
        "We couldn't find your location. Try again or set a location manually.",
    Object? cause,
  }) : super(message, cause: cause);
}

final class LocationServiceDisabledException extends AppException {
  const LocationServiceDisabledException({
    String message =
        'Location services are turned off. Enable GPS to find nearby places.',
    Object? cause,
  }) : super(message, cause: cause);
}

final class PermissionDeniedException extends AppException {
  const PermissionDeniedException({
    this.permanentlyDenied = false,
    String message = 'Location permission is needed to find places around you.',
    Object? cause,
  }) : super(message, cause: cause);

  final bool permanentlyDenied;
}

final class PlaceNotFoundException extends AppException {
  const PlaceNotFoundException({
    String message = 'This place is no longer available.',
    Object? cause,
  }) : super(message, cause: cause);
}

final class ActionUnavailableException extends AppException {
  const ActionUnavailableException({
    String message = "This action isn't available on your device.",
    Object? cause,
  }) : super(message, cause: cause);
}

final class UnexpectedException extends AppException {
  const UnexpectedException({
    String message = 'Something went wrong. Please try again.',
    Object? cause,
  }) : super(message, cause: cause);
}
