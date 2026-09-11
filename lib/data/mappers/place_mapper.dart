import 'package:drift/drift.dart';

import '../../domain/entities/place.dart';
import '../database/app_database.dart';

abstract final class PlaceMapper {
  static Place fromFavorite(FavoritePlace row) {
    return Place(
      id: row.id,
      provider: PlaceSource.values.firstWhere(
        (value) => value.name == row.provider,
        orElse: () => PlaceSource.mock,
      ),
      providerPlaceId: row.providerPlaceId,
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
    );
  }

  static FavoritePlacesCompanion toFavorite(Place place) {
    return FavoritePlacesCompanion.insert(
      id: place.id,
      provider: place.provider.name,
      providerPlaceId: place.providerPlaceId,
      name: place.name,
      category: Value(place.category),
      subcategory: Value(place.subcategory),
      latitude: place.latitude,
      longitude: place.longitude,
      address: Value(place.address),
      phoneNumber: Value(place.phoneNumber),
      website: Value(place.website),
      rating: Value(place.rating),
      reviewCount: Value(place.reviewCount),
      savedAt: DateTime.now(),
    );
  }
}
