import '../../domain/entities/place.dart';
import '../models/geoapify_place_dto.dart';

abstract final class GeoapifyPlaceMapper {
  static Place? toPlace(GeoapifyPlaceDto? dto) {
    if (dto == null) return null;
    final (category, subcategory) = _categoryFrom(dto.categories);
    return Place(
      id: Place.composeId(PlaceSource.geoapify, dto.placeId),
      provider: PlaceSource.geoapify,
      providerPlaceId: dto.placeId,
      name: dto.name,
      category: category,
      subcategory: subcategory,
      latitude: dto.latitude,
      longitude: dto.longitude,
      address: dto.address,
      phoneNumber: dto.phone,
      website: dto.website,
      // Geoapify Places list responses typically omit ratings.
      rating: null,
      reviewCount: null,
      // Do not invent open status.
      isOpen: null,
      openingHours: dto.openingHours == null ? const [] : [dto.openingHours!],
      distanceMeters: dto.distanceMeters,
      photos: const [],
      description: dto.description,
    );
  }

  static Place? fromFeature(Map<String, dynamic> feature) {
    return toPlace(GeoapifyPlaceDto.tryFromFeature(feature));
  }

  static List<Place> fromResponse(Map<String, dynamic>? data) {
    final features = data?['features'] as List? ?? const [];
    return features
        .whereType<Map>()
        .map((item) => fromFeature(Map<String, dynamic>.from(item)))
        .whereType<Place>()
        .toList();
  }

  static (String?, String?) _categoryFrom(List<String> categories) {
    for (final raw in categories) {
      if (raw.startsWith('catering')) {
        return ('Food', _sub(raw, 'Restaurants'));
      }
      if (raw.startsWith('healthcare')) {
        return ('Health', _sub(raw, 'Health'));
      }
      if (raw.startsWith('commercial')) {
        return ('Shopping', _sub(raw, 'Shopping'));
      }
      if (raw.startsWith('accommodation')) {
        return ('Travel', _sub(raw, 'Hotels'));
      }
      if (raw.startsWith('education')) {
        return ('Education', _sub(raw, 'Education'));
      }
      if (raw.startsWith('entertainment') || raw.startsWith('leisure')) {
        return ('Entertainment', _sub(raw, 'Entertainment'));
      }
      if (raw.startsWith('service') || raw.startsWith('rental')) {
        return ('Services', _sub(raw, 'Services'));
      }
      if (raw.startsWith('tourism') ||
          raw.startsWith('airport') ||
          raw.startsWith('public_transport')) {
        return ('Travel', _sub(raw, 'Travel'));
      }
    }
    return (categories.firstOrNull, null);
  }

  static String _sub(String raw, String fallback) {
    final parts = raw.split('.');
    if (parts.length < 2) return fallback;
    return parts.last
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) {
          if (w.isEmpty) return w;
          return '${w[0].toUpperCase()}${w.substring(1)}';
        })
        .join(' ');
  }
}
