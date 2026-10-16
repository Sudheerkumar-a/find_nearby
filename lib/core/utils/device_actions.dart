import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/place.dart';
import '../errors/app_exception.dart';

abstract final class DeviceActions {
  static Future<void> dial(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    // ACTION_DIAL equivalent — never ACTION_CALL.
    if (!await launchUrl(uri)) {
      throw const ActionUnavailableException(
        message: 'Phone calls are not available on this device.',
      );
    }
  }

  static Future<void> website(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const ActionUnavailableException(
        message: 'Could not open this website.',
      );
    }
  }

  /// Google Maps search sheet for [query], centered on the user.
  /// Maps shows Distance as the default nearby sort.
  static Uri nearbyMapUri({
    required double latitude,
    required double longitude,
    required String query,
  }) {
    // 6e1 is Google's Distance chip. Relevance is the link default without it.
    return Uri.https(
      'www.google.com',
      '/maps/search/$query/@$latitude,$longitude,14z/data=!3m1!4b1!4m2!2m1!6e1',
    );
  }

  static Future<void> searchNearbyOnMap({
    required double latitude,
    required double longitude,
    required String query,
  }) async {
    final uri = nearbyMapUri(
      latitude: latitude,
      longitude: longitude,
      query: query,
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const ActionUnavailableException(
        message: 'Could not open Google Maps.',
      );
    }
  }

  /// Opens this place's pin in Google Maps. Google place ids go straight to
  /// that listing; other providers open the coordinates.
  static Uri placeMapUri(Place place) {
    if (place.provider == PlaceSource.googlePlaces &&
        place.providerPlaceId.isNotEmpty) {
      return Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': place.name,
        'query_place_id': place.providerPlaceId,
      });
    }
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${place.latitude},${place.longitude}',
    });
  }

  static Future<void> openPlaceOnMap(Place place) async {
    if (!await launchUrl(
      placeMapUri(place),
      mode: LaunchMode.externalApplication,
    )) {
      throw const ActionUnavailableException(
        message: 'Could not open Google Maps.',
      );
    }
  }

  static Future<void> sharePlace(Place place) {
    final buffer = StringBuffer(place.name);
    if (place.address != null) buffer.write('\n${place.address}');
    if (place.phoneNumber != null) buffer.write('\n${place.phoneNumber}');
    buffer.write(
      '\nhttps://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
    );
    return SharePlus.instance.share(ShareParams(text: buffer.toString()));
  }
}
