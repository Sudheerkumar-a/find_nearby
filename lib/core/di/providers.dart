import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/drift_category_repository.dart';
import '../../data/repositories/drift_favorites_repository.dart';
import '../../data/repositories/drift_search_history_repository.dart';
import '../../data/repositories/drift_settings_repository.dart';
import '../../data/repositories/geoapify_place_repository.dart';
import '../../data/repositories/google_places_repository.dart';
import '../../data/repositories/hybrid_place_repository.dart';
import '../../data/repositories/mock_place_repository.dart';
import '../../domain/entities/place_search_mode.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../analytics/analytics.dart';
import '../config/app_config.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final analyticsProvider = Provider<Analytics>((ref) => const NoOpAnalytics());

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return DriftSettingsRepository(ref.watch(appDatabaseProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return DriftFavoritesRepository(ref.watch(appDatabaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(appDatabaseProvider));
});

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((
  ref,
) {
  return DriftSearchHistoryRepository(ref.watch(appDatabaseProvider));
});

final googlePlacesRepositoryProvider = Provider<PlaceRepository>((ref) {
  if (!AppConfig.hasPlacesKey) return MockPlaceRepository();
  return GooglePlacesRepository();
});

final geoapifyRepositoryProvider = Provider<PlaceRepository>((ref) {
  if (!AppConfig.hasGeoapifyKey) return MockPlaceRepository();
  return GeoapifyPlaceRepository();
});

final placeSearchModeProvider = StreamProvider<PlaceSearchMode>((ref) {
  return ref.watch(settingsRepositoryProvider).watchPlaceSearchMode();
});

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final mode =
      ref.watch(placeSearchModeProvider).value ??
      AppConfig.defaultPlaceSearchMode;

  return switch (mode) {
    PlaceSearchMode.mock => MockPlaceRepository(),
    PlaceSearchMode.google => ref.watch(googlePlacesRepositoryProvider),
    PlaceSearchMode.geoapify => ref.watch(geoapifyRepositoryProvider),
    PlaceSearchMode.automatic => _automaticRepo(ref),
  };
});

PlaceRepository _automaticRepo(Ref ref) {
  final hasGoogle = AppConfig.hasPlacesKey;
  final hasGeo = AppConfig.hasGeoapifyKey;
  if (hasGoogle && hasGeo) {
    return HybridPlaceRepository(
      google: ref.watch(googlePlacesRepositoryProvider),
      geoapify: ref.watch(geoapifyRepositoryProvider),
    );
  }
  if (hasGoogle) return ref.watch(googlePlacesRepositoryProvider);
  if (hasGeo) return ref.watch(geoapifyRepositoryProvider);
  return MockPlaceRepository();
}
