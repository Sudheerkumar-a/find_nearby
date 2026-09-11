enum PlaceSource { mock, googlePlaces, geoapify }

final class Place {
  const Place({
    required this.id,
    required this.provider,
    required this.providerPlaceId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.category,
    this.subcategory,
    this.address,
    this.phoneNumber,
    this.website,
    this.rating,
    this.reviewCount,
    this.isOpen,
    this.openingHours = const [],
    this.distanceMeters,
    this.photos = const [],
    this.description,
    this.priceLevel,
  });

  final String id;
  final PlaceSource provider;
  final String providerPlaceId;
  final String name;
  final String? category;
  final String? subcategory;
  final double latitude;
  final double longitude;
  final String? address;
  final String? phoneNumber;
  final String? website;
  final double? rating;
  final int? reviewCount;
  final bool? isOpen;
  final List<String> openingHours;
  final double? distanceMeters;
  final List<String> photos;
  final String? description;
  final int? priceLevel;

  bool get hasPhone => phoneNumber != null && phoneNumber!.trim().isNotEmpty;
  bool get hasWebsite => website != null && website!.trim().isNotEmpty;
  bool get hasRating => rating != null && rating! > 0;
  bool get hasPhotos => photos.isNotEmpty;

  String get categoryLabel {
    final parts = [
      subcategory,
      category,
    ].whereType<String>().where((s) => s.isNotEmpty);
    return parts.join(' · ');
  }

  Place copyWith({
    double? distanceMeters,
    bool? isOpen,
    String? phoneNumber,
    String? website,
    String? description,
    List<String>? openingHours,
    List<String>? photos,
    double? rating,
    int? reviewCount,
  }) {
    return Place(
      id: id,
      provider: provider,
      providerPlaceId: providerPlaceId,
      name: name,
      category: category,
      subcategory: subcategory,
      latitude: latitude,
      longitude: longitude,
      address: address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      openingHours: openingHours ?? this.openingHours,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      photos: photos ?? this.photos,
      description: description ?? this.description,
      priceLevel: priceLevel,
    );
  }

  static String composeId(PlaceSource provider, String providerPlaceId) =>
      '${provider.name}:$providerPlaceId';
}

final class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}
