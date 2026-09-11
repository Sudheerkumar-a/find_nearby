import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/place_search_mode.dart';

/// Central config — do not read dotenv from feature code.
abstract final class AppConfig {
  static PlaceSearchMode get defaultPlaceSearchMode {
    final raw = _read('PLACE_PROVIDER', fromEnvironment: 'PLACE_PROVIDER');
    if (raw.isEmpty) return PlaceSearchMode.mock;
    return PlaceSearchModeX.parse(raw, fallback: PlaceSearchMode.mock);
  }

  static String get googlePlacesApiKey =>
      _read('GOOGLE_PLACES_API_KEY', fromEnvironment: 'GOOGLE_PLACES_API_KEY');

  static String get googleMapsApiKey =>
      _read('GOOGLE_MAPS_API_KEY', fromEnvironment: 'GOOGLE_MAPS_API_KEY');

  static String get geoapifyApiKey =>
      _read('GEOAPIFY_API_KEY', fromEnvironment: 'GEOAPIFY_API_KEY');

  static bool get hasPlacesKey => googlePlacesApiKey.isNotEmpty;
  static bool get hasGeoapifyKey => geoapifyApiKey.isNotEmpty;

  static String _read(String dotenvKey, {required String fromEnvironment}) {
    const compiledPlaces = String.fromEnvironment('GOOGLE_PLACES_API_KEY');
    const compiledMaps = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    const compiledGeo = String.fromEnvironment('GEOAPIFY_API_KEY');
    const compiledProvider = String.fromEnvironment('PLACE_PROVIDER');

    final fromDefine = switch (fromEnvironment) {
      'GOOGLE_PLACES_API_KEY' => compiledPlaces,
      'GOOGLE_MAPS_API_KEY' => compiledMaps,
      'GEOAPIFY_API_KEY' => compiledGeo,
      'PLACE_PROVIDER' => compiledProvider,
      _ => '',
    };
    if (fromDefine.isNotEmpty) return fromDefine;

    if (dotenv.isInitialized) {
      return dotenv.maybeGet(dotenvKey)?.trim() ?? '';
    }
    return '';
  }

  static Future<void> loadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      try {
        await dotenv.load(fileName: '.env.example');
      } catch (_) {
        // ponytail: first-run and CI have no env file; mock provider is the default
      }
    }
  }
}
