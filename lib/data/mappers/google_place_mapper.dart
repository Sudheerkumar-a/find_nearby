import '../../domain/entities/place.dart';

abstract final class GooglePlaceMapper {
  static const listFieldMask =
      'places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.userRatingCount,places.currentOpeningHours.openNow,places.types,places.photos.name,places.priceLevel';

  static const detailsFieldMask =
      'id,displayName,formattedAddress,location,rating,userRatingCount,nationalPhoneNumber,internationalPhoneNumber,websiteUri,currentOpeningHours,regularOpeningHours,editorialSummary,photos,priceLevel,types';

  static Place? fromJson(Map<String, dynamic> json, {required String? apiKey}) {
    final providerId = json['id'] as String?;
    final location = json['location'] as Map<String, dynamic>?;
    final lat = (location?['latitude'] as num?)?.toDouble();
    final lng = (location?['longitude'] as num?)?.toDouble();
    if (providerId == null || lat == null || lng == null) return null;

    final displayName = json['displayName'] as Map<String, dynamic>?;
    final name = displayName?['text'] as String? ?? 'Unknown place';
    final types = (json['types'] as List?)?.cast<String>() ?? const [];
    final hours = json['currentOpeningHours'] as Map<String, dynamic>?;
    final regular = json['regularOpeningHours'] as Map<String, dynamic>?;
    final weekday =
        (regular?['weekdayDescriptions'] as List?)?.cast<String>() ??
        (hours?['weekdayDescriptions'] as List?)?.cast<String>() ??
        const [];
    final photos = _photos(json['photos'], apiKey);
    final editorial = json['editorialSummary'] as Map<String, dynamic>?;
    final (category, subcategory) = _categoryFromTypes(types);

    return Place(
      id: Place.composeId(PlaceSource.googlePlaces, providerId),
      provider: PlaceSource.googlePlaces,
      providerPlaceId: providerId,
      name: name,
      category: category,
      subcategory: subcategory,
      latitude: lat,
      longitude: lng,
      address: json['formattedAddress'] as String?,
      phoneNumber:
          json['nationalPhoneNumber'] as String? ??
          json['internationalPhoneNumber'] as String?,
      website: json['websiteUri'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['userRatingCount'] as int?,
      isOpen: hours?['openNow'] as bool?,
      openingHours: weekday,
      photos: photos,
      description: editorial?['text'] as String?,
      priceLevel: _priceLevel(json['priceLevel']),
    );
  }

  static List<String> _photos(Object? raw, String? apiKey) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((photo) => photo['name'] as String?)
        .whereType<String>()
        .map((name) {
          if (apiKey == null || apiKey.isEmpty) return name;
          return 'https://places.googleapis.com/v1/$name/media?maxWidthPx=800&key=$apiKey';
        })
        .toList();
  }

  static int? _priceLevel(Object? raw) {
    return switch (raw) {
      'PRICE_LEVEL_FREE' => 0,
      'PRICE_LEVEL_INEXPENSIVE' => 1,
      'PRICE_LEVEL_MODERATE' => 2,
      'PRICE_LEVEL_EXPENSIVE' => 3,
      'PRICE_LEVEL_VERY_EXPENSIVE' => 4,
      int value => value,
      _ => null,
    };
  }

  static (String?, String?) _categoryFromTypes(List<String> types) {
    const map = {
      'restaurant': ('Food', 'Restaurants'),
      'cafe': ('Food', 'Cafes'),
      'bakery': ('Food', 'Bakeries'),
      'hospital': ('Health', 'Hospitals'),
      'pharmacy': ('Health', 'Pharmacies'),
      'dentist': ('Health', 'Dental Clinics'),
      'hotel': ('Travel', 'Hotels'),
      'airport': ('Travel', 'Airports'),
      'shopping_mall': ('Shopping', 'Shopping Malls'),
      'supermarket': ('Shopping', 'Supermarkets'),
      'bank': ('Services', 'Banks'),
      'atm': ('Services', 'ATMs'),
      'movie_theater': ('Entertainment', 'Cinemas'),
      'park': ('Entertainment', 'Parks'),
      'museum': ('Entertainment', 'Museums'),
      'school': ('Education', 'Schools'),
      'university': ('Education', 'Universities'),
    };
    for (final type in types) {
      final mapped = map[type];
      if (mapped != null) return mapped;
    }
    return (types.firstOrNull, null);
  }
}
