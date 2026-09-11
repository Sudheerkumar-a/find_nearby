import 'package:drift/drift.dart';

import '../../core/constants/category_catalog.dart';
import '../../domain/entities/app_category.dart';
import '../../domain/repositories/category_repository.dart';
import '../database/app_database.dart';

final class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<AppCategory>> watchAll() {
    return _db.select(_db.categoryPreferences).watch().map(_merge);
  }

  @override
  Future<List<AppCategory>> getAll() async {
    return _merge(await _db.select(_db.categoryPreferences).get());
  }

  @override
  Future<void> setEnabled(String categoryId, bool enabled) async {
    final existing = await _pref(categoryId);
    if (existing == null) {
      final fallback = CategoryCatalog.byId(categoryId);
      await _db
          .into(_db.categoryPreferences)
          .insert(
            CategoryPreferencesCompanion.insert(
              categoryId: categoryId,
              enabled: Value(enabled),
              sortOrder: fallback?.sortOrder ?? 99,
            ),
          );
      return;
    }
    await (_db.update(_db.categoryPreferences)
          ..where((tbl) => tbl.categoryId.equals(categoryId)))
        .write(CategoryPreferencesCompanion(enabled: Value(enabled)));
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        final id = orderedIds[i];
        final existing = await _pref(id);
        if (existing == null) {
          await _db
              .into(_db.categoryPreferences)
              .insert(
                CategoryPreferencesCompanion.insert(
                  categoryId: id,
                  sortOrder: i,
                ),
              );
        } else {
          await (_db.update(_db.categoryPreferences)
                ..where((tbl) => tbl.categoryId.equals(id)))
              .write(CategoryPreferencesCompanion(sortOrder: Value(i)));
        }
      }
    });
  }

  @override
  Future<void> addCustom({
    required String name,
    required String query,
    String icon = 'place',
  }) async {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final current = await getAll();
    await _db
        .into(_db.categoryPreferences)
        .insert(
          CategoryPreferencesCompanion.insert(
            categoryId: id,
            sortOrder: current.length,
            isCustom: const Value(true),
            customName: Value(name),
            customQuery: Value(query),
            customIcon: Value(icon),
          ),
        );
  }

  @override
  Future<void> removeCustom(String categoryId) {
    return (_db.delete(_db.categoryPreferences)..where(
          (tbl) =>
              tbl.categoryId.equals(categoryId) & tbl.isCustom.equals(true),
        ))
        .go();
  }

  @override
  Future<void> resetToDefaults() {
    return _db.delete(_db.categoryPreferences).go();
  }

  Future<CategoryPreference?> _pref(String id) {
    return (_db.select(
      _db.categoryPreferences,
    )..where((tbl) => tbl.categoryId.equals(id))).getSingleOrNull();
  }

  List<AppCategory> _merge(List<CategoryPreference> rows) {
    final prefs = <String, ({bool enabled, int sortOrder})>{};
    final custom = <AppCategory>[];

    for (final row in rows) {
      if (row.isCustom) {
        custom.add(
          AppCategory(
            id: row.categoryId,
            name: row.customName ?? 'Custom',
            icon: row.customIcon ?? 'place',
            subcategories: [
              AppSubcategory(
                id: '${row.categoryId}_all',
                name: row.customName ?? 'Custom',
                searchQuery: row.customQuery,
              ),
            ],
            enabled: row.enabled,
            sortOrder: row.sortOrder,
            isCustom: true,
            customQuery: row.customQuery,
          ),
        );
      } else {
        prefs[row.categoryId] = (
          enabled: row.enabled,
          sortOrder: row.sortOrder,
        );
      }
    }

    return CategoryCatalog.applyPreferences(
      defaults: CategoryCatalog.defaults,
      prefs: prefs,
      custom: custom,
    );
  }
}
