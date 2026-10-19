import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/place.dart';
import '../errors/app_exception.dart';

abstract final class DeviceActions {
  static const _whatsAppChannel = MethodChannel('find_nearby/whatsapp');

  static const whatsAppApps = <String, String>{
    'com.whatsapp': 'WhatsApp',
    'com.whatsapp.w4b': 'WhatsApp Business',
  };

  static Future<void> dial(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    // ACTION_DIAL equivalent — never ACTION_CALL.
    if (!await launchUrl(uri)) {
      throw const ActionUnavailableException(
        message: 'Phone calls are not available on this device.',
      );
    }
  }

  /// Digits for wa.me. `+` and `00` numbers already include a country code.
  /// A leading `0` is a local trunk prefix; [address] supplies the country.
  /// ponytail: unknown countries keep the local number; add a name to [_callingCodes] to cover another.
  static String whatsAppDigits(String phone, {String? address}) {
    var digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('00')) digits = digits.substring(2);
    if (!digits.startsWith('0')) return digits;
    final code = _callingCode(address);
    if (code == null) return digits;
    return '$code${digits.substring(1)}';
  }

  static String? _callingCode(String? address) {
    if (address == null || address.isEmpty) return null;
    final text = address.toLowerCase();
    for (final entry in _callingCodes) {
      final name = entry.$1;
      final at = text.lastIndexOf(name);
      if (at < 0) continue;
      final end = at + name.length;
      final before = at == 0 || !_isNameEdge(text.codeUnitAt(at - 1));
      final after = end == text.length || !_isNameEdge(text.codeUnitAt(end));
      if (before && after) return entry.$2;
    }
    return null;
  }

  static bool _isNameEdge(int code) =>
      (code >= 97 && code <= 122) || (code >= 65 && code <= 90);

  /// Longest names first so "united arab emirates" wins over a shorter token.
  static const _callingCodes = <(String, String)>[
    ('united arab emirates', '971'),
    ('united kingdom', '44'),
    ('united states', '1'),
    ('saudi arabia', '966'),
    ('south africa', '27'),
    ('south korea', '82'),
    ('new zealand', '64'),
    ('sri lanka', '94'),
    ('abu dhabi', '971'),
    ('australia', '61'),
    ('bangladesh', '880'),
    ('indonesia', '62'),
    ('malaysia', '60'),
    ('pakistan', '92'),
    ('philippines', '63'),
    ('singapore', '65'),
    ('thailand', '66'),
    ('bahrain', '973'),
    ('belgium', '32'),
    ('brazil', '55'),
    ('canada', '1'),
    ('china', '86'),
    ('dubai', '971'),
    ('egypt', '20'),
    ('france', '33'),
    ('germany', '49'),
    ('india', '91'),
    ('italy', '39'),
    ('japan', '81'),
    ('jordan', '962'),
    ('kenya', '254'),
    ('kuwait', '965'),
    ('lebanon', '961'),
    ('mexico', '52'),
    ('morocco', '212'),
    ('nepal', '977'),
    ('nigeria', '234'),
    ('oman', '968'),
    ('qatar', '974'),
    ('russia', '7'),
    ('sharjah', '971'),
    ('spain', '34'),
    ('turkey', '90'),
    ('uae', '971'),
    ('uk', '44'),
    ('usa', '1'),
  ];

  /// Installed WhatsApp apps, in [whatsAppApps] order. Empty off Android.
  static Future<List<({String packageName, String label})>>
  installedWhatsAppApps() async {
    try {
      final raw = await _whatsAppChannel.invokeMethod<List<dynamic>>(
        'installed',
      );
      final found = raw?.cast<String>().toSet() ?? const <String>{};
      return [
        for (final entry in whatsAppApps.entries)
          if (found.contains(entry.key))
            (packageName: entry.key, label: entry.value),
      ];
    } on MissingPluginException {
      return const [];
    }
  }

  /// Opens the WhatsApp chat for [phone]. The app scheme goes straight to
  /// the chat; wa.me is the fallback when WhatsApp is not installed.
  static Uri whatsAppChatUri(String phone, {String? address}) {
    return Uri.https('wa.me', '/${whatsAppDigits(phone, address: address)}');
  }

  static Future<void> openWhatsApp(
    String phone, {
    String? address,
    String? packageName,
  }) async {
    final digits = whatsAppDigits(phone, address: address);
    if (digits.isEmpty) {
      throw const ActionUnavailableException(
        message: 'Could not open WhatsApp.',
      );
    }
    if (packageName != null) {
      try {
        final opened = await _whatsAppChannel.invokeMethod<bool>('open', {
          'phone': digits,
          'package': packageName,
        });
        if (opened == true) return;
      } on MissingPluginException {
        // iOS has no package pin; the scheme below opens WhatsApp.
      }
    }
    final openedApp = await launchUrl(
      Uri.parse('whatsapp://send?phone=$digits'),
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (openedApp) return;
    if (!await launchUrl(
      whatsAppChatUri(phone, address: address),
      mode: LaunchMode.externalApplication,
    )) {
      throw const ActionUnavailableException(
        message: 'Could not open WhatsApp.',
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
