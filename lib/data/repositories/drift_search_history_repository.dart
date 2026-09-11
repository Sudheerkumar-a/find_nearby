import 'package:drift/drift.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../database/app_database.dart';

final class DriftSearchHistoryRepository implements SearchHistoryRepository {
  DriftSearchHistoryRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<String>> watchRecent() {
    return (_db.select(_db.searchHistoryEntries)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.searchedAt)])
          ..limit(AppConstants.searchHistoryLimit))
        .watch()
        .map((rows) => rows.map((row) => row.query).toList());
  }

  @override
  Future<List<String>> getRecent() async {
    final rows =
        await (_db.select(_db.searchHistoryEntries)
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.searchedAt)])
              ..limit(AppConstants.searchHistoryLimit))
            .get();
    return rows.map((row) => row.query).toList();
  }

  @override
  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    await _db.transaction(() async {
      await (_db.delete(
        _db.searchHistoryEntries,
      )..where((tbl) => tbl.query.lower().equals(trimmed.toLowerCase()))).go();
      await _db
          .into(_db.searchHistoryEntries)
          .insert(
            SearchHistoryEntriesCompanion.insert(
              query: trimmed,
              searchedAt: DateTime.now(),
            ),
          );

      final extras =
          await (_db.select(_db.searchHistoryEntries)
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.searchedAt)])
                ..limit(100, offset: AppConstants.searchHistoryLimit))
              .get();
      for (final extra in extras) {
        await (_db.delete(
          _db.searchHistoryEntries,
        )..where((tbl) => tbl.id.equals(extra.id))).go();
      }
    });
  }

  @override
  Future<void> remove(String query) {
    return (_db.delete(
      _db.searchHistoryEntries,
    )..where((tbl) => tbl.query.equals(query))).go();
  }

  @override
  Future<void> clear() => _db.delete(_db.searchHistoryEntries).go();
}
