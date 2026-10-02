import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/entities/place.dart';
import '../database/app_database.dart';

abstract final class CachedPlaceMapper {
  static Place toPlace(CachedPlace row) {
    return Place(
      id: Place.composeId(
        PlaceSource.values.firstWhere(
          (value) => value.name == row.provider,
          orElse: () => PlaceSource.googlePlaces,
        ),
        row.googlePlaceId,
      ),
      provider: PlaceSource.values.firstWhere(
        (value) => value.name == row.provider,
        orElse: () => PlaceSource.googlePlaces,
      ),
      providerPlaceId: row.googlePlaceId,
      name: row.name,
      category: row.category,
      subcategory: row.subcategory,
      latitude: row.latitude,
      longitude: row.longitude,
      address: row.address,
      phoneNumber: row.phoneNumber,
      website: row.website,
      rating: row.rating,
      reviewCount: row.reviewCount,
      isOpen: row.isOpen,
      openingHours: _decodeList(row.openingHours),
      photos: _decodeList(row.photos),
      description: row.description,
    );
  }

  static CachedPlacesCompanion fromPlace(
    Place place, {
    DateTime? detailsUpdated,
    DateTime? ratingUpdated,
    DateTime? openingStatusUpdated,
  }) {
    final now = DateTime.now();
    return CachedPlacesCompanion.insert(
      googlePlaceId: place.providerPlaceId,
      provider: place.provider.name,
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude,
      address: Value(place.address),
      phoneNumber: Value(place.phoneNumber),
      website: Value(place.website),
      rating: Value(place.rating),
      reviewCount: Value(place.reviewCount),
      isOpen: Value(place.isOpen),
      category: Value(place.category),
      subcategory: Value(place.subcategory),
      openingHours: Value(_encodeList(place.openingHours)),
      photos: Value(_encodeList(place.photos)),
      description: Value(place.description),
      lastUpdated: now,
      detailsUpdated: Value(detailsUpdated ?? now),
      ratingUpdated: Value(ratingUpdated ?? now),
      openingStatusUpdated: Value(openingStatusUpdated ?? now),
    );
  }

  static Place mergeInto(Place place, CachedPlace cached) {
    final cachedPlace = toPlace(cached);
    return place.copyWith(
      phoneNumber: place.phoneNumber ?? cachedPlace.phoneNumber,
      website: place.website ?? cachedPlace.website,
    );
  }

  static List<String> _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList();
    } catch (_) {
      return const [];
    }
  }

  static String? encodeStringList(List<String> values) => _encodeList(values);

  static String? _encodeList(List<String> values) {
    if (values.isEmpty) return null;
    return jsonEncode(values);
  }
}
