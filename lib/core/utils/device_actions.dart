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

  static Future<void> directions({
    required double latitude,
    required double longitude,
    String? name,
  }) async {
    final encoded = Uri.encodeComponent(name ?? '$latitude,$longitude');
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&destination_place_id=&travelmode=driving&dir_action=navigate&query=$encoded',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw const ActionUnavailableException(
        message: 'Maps are not available on this device.',
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
