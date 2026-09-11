final class GeoapifyPlaceDto {
  const GeoapifyPlaceDto({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.phone,
    this.website,
    this.categories = const [],
    this.openingHours,
    this.distanceMeters,
    this.description,
  });

  final String placeId;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? phone;
  final String? website;
  final List<String> categories;
  final String? openingHours;
  final double? distanceMeters;
  final String? description;

  /// Returns null when coordinates are missing.
  static GeoapifyPlaceDto? tryFromFeature(Map<String, dynamic> feature) {
    final props = Map<String, dynamic>.from(
      (feature['properties'] as Map?) ?? const {},
    );
    final geometry = feature['geometry'] as Map?;
    final coords = geometry?['coordinates'] as List?;

    final lon =
        (props['lon'] as num?)?.toDouble() ??
        (coords != null && coords.length >= 2
            ? (coords[0] as num).toDouble()
            : null);
    final lat =
        (props['lat'] as num?)?.toDouble() ??
        (coords != null && coords.length >= 2
            ? (coords[1] as num).toDouble()
            : null);
    if (lat == null || lon == null) return null;

    final id =
        props['place_id']?.toString() ??
        props['osm_id']?.toString() ??
        '${lat}_$lon';

    final categories = <String>[];
    final cats = props['categories'];
    if (cats is List) {
      categories.addAll(cats.map((e) => e.toString()));
    } else if (props['category'] != null) {
      categories.add(props['category'].toString());
    }

    final contact = props['contact'] is Map
        ? Map<String, dynamic>.from(props['contact'] as Map)
        : const <String, dynamic>{};
    final raw = props['datasource'] is Map
        ? (props['datasource'] as Map)['raw']
        : null;
    final rawMap = raw is Map ? Map<String, dynamic>.from(raw) : null;

    final phone =
        _nonEmpty(props['phone']?.toString()) ??
        _nonEmpty(contact['phone']?.toString()) ??
        _nonEmpty(rawMap?['phone']?.toString());

    final website =
        _nonEmpty(props['website']?.toString()) ??
        _nonEmpty(contact['website']?.toString()) ??
        _nonEmpty(props['url']?.toString()) ??
        _nonEmpty(rawMap?['website']?.toString());

    final name =
        _nonEmpty(props['name']?.toString()) ??
        _nonEmpty(props['address_line1']?.toString()) ??
        _nonEmpty(props['formatted']?.toString()) ??
        'Unknown place';

    final address =
        _nonEmpty(props['formatted']?.toString()) ??
        [props['address_line1'], props['city'], props['country']]
            .whereType<Object>()
            .map((e) => e.toString())
            .where((s) => s.isNotEmpty)
            .join(', ');

    return GeoapifyPlaceDto(
      placeId: id,
      name: name,
      latitude: lat,
      longitude: lon,
      address: address.isEmpty ? null : address,
      phone: phone,
      website: website,
      categories: categories,
      openingHours: _nonEmpty(props['opening_hours']?.toString()),
      distanceMeters: (props['distance'] as num?)?.toDouble(),
      description: _nonEmpty(props['description']?.toString()),
    );
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
