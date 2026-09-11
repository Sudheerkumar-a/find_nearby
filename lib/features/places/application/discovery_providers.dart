import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/category_catalog.dart';
import '../../../core/di/providers.dart';
import '../../../domain/entities/app_category.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/repositories/place_repository.dart';
import '../../../domain/services/place_filter_engine.dart';
import '../../categories/application/category_providers.dart';
import '../../filters/application/filters_controller.dart';
import '../../location/application/location_controller.dart';

final selectedCategoryIdProvider = Provider<String?>((ref) {
  return ref.watch(filtersProvider).categoryId;
});

final selectedSubcategoryIdProvider = Provider<String?>((ref) {
  return ref.watch(filtersProvider).subcategoryId;
});

final selectedCategoryProvider = Provider<AppCategory?>((ref) {
  final id = ref.watch(selectedCategoryIdProvider);
  if (id == null) return null;
  final categories = ref.watch(enabledCategoriesProvider);
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return CategoryCatalog.byId(id);
});

final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final location = ref.watch(locationProvider);
  final origin = location.point;
  if (origin == null) return const [];

  final filters = ref.watch(filtersProvider);
  final categories = ref.watch(enabledCategoriesProvider);
  AppCategory? category;
  if (filters.categoryId != null) {
    for (final item in [...categories, ...CategoryCatalog.defaults]) {
      if (item.id == filters.categoryId) {
        category = item;
        break;
      }
    }
  }

  AppSubcategory? subcategory;
  if (filters.subcategoryId != null) {
    subcategory = CategoryCatalog.subcategoryById(filters.subcategoryId!, [
      ?category,
      ...CategoryCatalog.defaults,
    ]);
    subcategory ??= category?.subcategories
        .where((item) => item.id == filters.subcategoryId)
        .firstOrNull;
  }

  final placeCategory = subcategory?.placeCategory;
  final categoryGroup = placeCategory == null ? category?.group : null;

  // Text only for custom categories / explicit searchQuery — never provider strings.
  final textQuery =
      subcategory?.searchQuery ??
      category?.customQuery ??
      (placeCategory == null && categoryGroup == null ? category?.name : null);

  final repo = ref.watch(placeRepositoryProvider);
  final page = await repo.searchNearby(
    NearbyQuery(
      origin: origin,
      radiusMeters: filters.radiusMeters,
      placeCategory: placeCategory,
      categoryGroup: categoryGroup,
      textQuery: textQuery,
      openNow: filters.openNow ? true : null,
    ),
  );

  return PlaceFilterEngine.apply(
    places: page.places,
    filters: filters,
    origin: origin,
  );
});

final bestRatedNearbyProvider = Provider<List<Place>>((ref) {
  final places = ref.watch(nearbyPlacesProvider).value ?? const [];
  final rated = places.where((place) => (place.rating ?? 0) >= 4.5).toList()
    ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
  return rated.take(8).toList();
});

final openNowNearbyProvider = Provider<List<Place>>((ref) {
  final places = ref.watch(nearbyPlacesProvider).value ?? const [];
  return places.where((place) => place.isOpen == true).take(8).toList();
});
