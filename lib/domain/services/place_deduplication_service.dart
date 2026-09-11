import '../../core/utils/distance.dart';
import '../../domain/entities/place.dart';

/// Conservative multi-provider dedupe. Prefer richer contact data when merging.
abstract final class PlaceDeduplicationService {
  /// Places closer than this (and similar name) may be the same business.
  static const double matchDistanceMeters = 60;

  static List<Place> dedupe(List<Place> input) {
    final results = <Place>[];
    for (final candidate in input) {
      final index = results.indexWhere(
        (existing) => _isDuplicate(existing, candidate),
      );
      if (index < 0) {
        results.add(candidate);
      } else {
        results[index] = merge(results[index], candidate);
      }
    }
    return results;
  }

  static bool _isDuplicate(Place a, Place b) {
    if (a.provider == b.provider && a.providerPlaceId == b.providerPlaceId) {
      return true;
    }

    final meters = Distance.metersBetween(
      fromLat: a.latitude,
      fromLng: a.longitude,
      toLat: b.latitude,
      toLng: b.longitude,
    );
    if (meters > matchDistanceMeters) return false;

    final phoneA = _digits(a.phoneNumber);
    final phoneB = _digits(b.phoneNumber);
    if (phoneA != null && phoneB != null && phoneA == phoneB) return true;

    final siteA = _normalizeUrl(a.website);
    final siteB = _normalizeUrl(b.website);
    if (siteA != null && siteB != null && siteA == siteB) return true;

    final nameA = _normalizeName(a.name);
    final nameB = _normalizeName(b.name);
    if (nameA.isEmpty || nameB.isEmpty) return false;
    if (nameA == nameB) return true;

    // Require strong name overlap — avoid merging "ABC" with "ABC Downtown".
    if (_tokenJaccard(nameA, nameB) >= 0.85 && meters <= 35) return true;
    return false;
  }

  static Place merge(Place a, Place b) {
    final preferA = _completeness(a) >= _completeness(b);
    final primary = preferA ? a : b;
    final secondary = preferA ? b : a;

    return Place(
      id: primary.id,
      provider: primary.provider,
      providerPlaceId: primary.providerPlaceId,
      name: primary.name,
      category: primary.category ?? secondary.category,
      subcategory: primary.subcategory ?? secondary.subcategory,
      latitude: primary.latitude,
      longitude: primary.longitude,
      address: _longer(primary.address, secondary.address),
      phoneNumber: _preferPhone(primary.phoneNumber, secondary.phoneNumber),
      website: primary.website ?? secondary.website,
      rating: primary.rating ?? secondary.rating,
      reviewCount: primary.reviewCount ?? secondary.reviewCount,
      isOpen: primary.isOpen ?? secondary.isOpen,
      openingHours: primary.openingHours.isNotEmpty
          ? primary.openingHours
          : secondary.openingHours,
      distanceMeters: _minNullable(
        primary.distanceMeters,
        secondary.distanceMeters,
      ),
      photos: primary.photos.isNotEmpty ? primary.photos : secondary.photos,
      description: primary.description ?? secondary.description,
      priceLevel: primary.priceLevel ?? secondary.priceLevel,
    );
  }

  static int _completeness(Place place) {
    var score = 0;
    if (place.hasPhone) score += 4;
    if (place.hasWebsite) score += 2;
    if (place.hasRating) score += 2;
    if (place.address != null) score += 1;
    if (place.hasPhotos) score += 1;
    if (place.description != null) score += 1;
    if (place.openingHours.isNotEmpty) score += 1;
    // Prefer Google when completeness ties — richer details API.
    if (place.provider == PlaceSource.googlePlaces) score += 1;
    return score;
  }

  static String? _preferPhone(String? a, String? b) {
    final da = _digits(a);
    final db = _digits(b);
    if (da == null) return b;
    if (db == null) return a;
    return da.length >= db.length ? a : b;
  }

  static String? _longer(String? a, String? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.length >= b.length ? a : b;
  }

  static double? _minNullable(double? a, double? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a < b ? a : b;
  }

  static String _normalizeName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String? _digits(String? phone) {
    if (phone == null) return null;
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7) return null;
    return digits;
  }

  static String? _normalizeUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    return url
        .toLowerCase()
        .replaceFirst(RegExp(r'^https?://'), '')
        .replaceFirst(RegExp(r'^www\.'), '')
        .split('/')
        .first;
  }

  static double _tokenJaccard(String a, String b) {
    final ta = a.split(' ').where((t) => t.length > 1).toSet();
    final tb = b.split(' ').where((t) => t.length > 1).toSet();
    if (ta.isEmpty || tb.isEmpty) return 0;
    final inter = ta.intersection(tb).length;
    final union = ta.union(tb).length;
    return inter / union;
  }
}
