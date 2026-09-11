import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/search_filters.dart';

class FiltersController extends Notifier<SearchFilters> {
  @override
  SearchFilters build() {
    Future<void>.microtask(_hydrate);
    return const SearchFilters();
  }

  Future<void> _hydrate() async {
    final meters = await ref
        .read(settingsRepositoryProvider)
        .getSearchRadiusMeters();
    state = state.copyWith(radiusMeters: meters);
  }

  void apply(SearchFilters filters) => state = filters;

  void setCategory({String? categoryId, String? subcategoryId}) {
    state = state.copyWith(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      clearCategory: categoryId == null,
      clearSubcategory: subcategoryId == null,
    );
  }

  void reset() => state = const SearchFilters();
}

final filtersProvider = NotifierProvider<FiltersController, SearchFilters>(
  FiltersController.new,
);
