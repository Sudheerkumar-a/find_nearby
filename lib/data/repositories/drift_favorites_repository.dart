import 'package:drift/drift.dart';

import '../../domain/entities/place.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../database/app_database.dart';
import '../mappers/place_mapper.dart';

final class DriftFavoritesRepository implements FavoritesRepository {
  DriftFavoritesRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Place>> watchAll() {
    return (_db.select(_db.favoritePlaces)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)]))
        .watch()
        .map((rows) => rows.map(PlaceMapper.fromFavorite).toList());
  }

  @override
  Future<List<Place>> getAll() async {
    final rows = await (_db.select(
      _db.favoritePlaces,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)])).get();
    return rows.map(PlaceMapper.fromFavorite).toList();
  }

  @override
  Future<bool> isFavorite(String placeId) async {
    final row = await (_db.select(
      _db.favoritePlaces,
    )..where((tbl) => tbl.id.equals(placeId))).getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> add(Place place) {
    return _db
        .into(_db.favoritePlaces)
        .insertOnConflictUpdate(PlaceMapper.toFavorite(place));
  }

  @override
  Future<void> remove(String placeId) {
    return (_db.delete(
      _db.favoritePlaces,
    )..where((tbl) => tbl.id.equals(placeId))).go();
  }

  @override
  Future<void> toggle(Place place) async {
    if (await isFavorite(place.id)) {
      await remove(place.id);
    } else {
      await add(place);
    }
  }
}
