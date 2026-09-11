import 'package:find_nearby/core/constants/category_catalog.dart';
import 'package:find_nearby/domain/entities/app_category.dart';
import 'package:find_nearby/domain/entities/place.dart';
import 'package:find_nearby/domain/entities/place_search_mode.dart';
import 'package:find_nearby/domain/repositories/category_repository.dart';
import 'package:find_nearby/domain/repositories/favorites_repository.dart';
import 'package:find_nearby/domain/repositories/search_history_repository.dart';
import 'package:find_nearby/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

final class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    this.themeMode = ThemeMode.system,
    this.radiusMeters = 2000,
    this.placeSearchMode = PlaceSearchMode.mock,
  });

  ThemeMode themeMode;
  double radiusMeters;
  bool notifications = false;
  PlaceSearchMode placeSearchMode;

  @override
  Stream<ThemeMode> watchThemeMode() => Stream.value(themeMode);

  @override
  Future<ThemeMode> getThemeMode() async => themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => themeMode = mode;

  @override
  Future<double> getSearchRadiusMeters() async => radiusMeters;

  @override
  Future<void> setSearchRadiusMeters(double meters) async =>
      radiusMeters = meters;

  @override
  Future<bool> getNotificationsEnabled() async => notifications;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async =>
      notifications = enabled;

  @override
  Stream<PlaceSearchMode> watchPlaceSearchMode() =>
      Stream.value(placeSearchMode);

  @override
  Future<PlaceSearchMode> getPlaceSearchMode() async => placeSearchMode;

  @override
  Future<void> setPlaceSearchMode(PlaceSearchMode mode) async =>
      placeSearchMode = mode;
}

final class FakeFavoritesRepository implements FavoritesRepository {
  final _items = <Place>[];

  @override
  Stream<List<Place>> watchAll() => Stream.value(List.unmodifiable(_items));

  @override
  Future<List<Place>> getAll() async => List.unmodifiable(_items);

  @override
  Future<bool> isFavorite(String placeId) async =>
      _items.any((place) => place.id == placeId);

  @override
  Future<void> add(Place place) async {
    _items.removeWhere((item) => item.id == place.id);
    _items.add(place);
  }

  @override
  Future<void> remove(String placeId) async {
    _items.removeWhere((item) => item.id == placeId);
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

final class FakeCategoryRepository implements CategoryRepository {
  List<AppCategory> items = List.of(CategoryCatalog.defaults);

  @override
  Stream<List<AppCategory>> watchAll() => Stream.value(items);

  @override
  Future<List<AppCategory>> getAll() async => items;

  @override
  Future<void> setEnabled(String categoryId, bool enabled) async {
    items = [
      for (final item in items)
        if (item.id == categoryId) item.copyWith(enabled: enabled) else item,
    ];
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    items = [
      for (var i = 0; i < orderedIds.length; i++)
        items
            .firstWhere((item) => item.id == orderedIds[i])
            .copyWith(sortOrder: i),
    ];
  }

  @override
  Future<void> addCustom({
    required String name,
    required String query,
    String icon = 'place',
  }) async {
    items = [
      ...items,
      AppCategory(
        id: 'custom_$name',
        name: name,
        icon: icon,
        isCustom: true,
        customQuery: query,
        sortOrder: items.length,
        subcategories: [
          AppSubcategory(
            id: 'custom_${name}_all',
            name: name,
            searchQuery: query,
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> removeCustom(String categoryId) async {
    items = items.where((item) => item.id != categoryId).toList();
  }

  @override
  Future<void> resetToDefaults() async =>
      items = List.of(CategoryCatalog.defaults);
}

final class FakeSearchHistoryRepository implements SearchHistoryRepository {
  final items = <String>[];

  @override
  Stream<List<String>> watchRecent() => Stream.value(List.of(items));

  @override
  Future<List<String>> getRecent() async => List.of(items);

  @override
  Future<void> add(String query) async {
    items.remove(query);
    items.insert(0, query);
  }

  @override
  Future<void> remove(String query) async => items.remove(query);

  @override
  Future<void> clear() async => items.clear();
}
