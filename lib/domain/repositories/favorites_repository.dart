import '../entities/place.dart';

abstract class FavoritesRepository {
  Stream<List<Place>> watchAll();

  Future<List<Place>> getAll();

  Future<bool> isFavorite(String placeId);

  Future<void> add(Place place);

  Future<void> remove(String placeId);

  Future<void> toggle(Place place);
}
