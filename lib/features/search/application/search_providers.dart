import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/repositories/place_repository.dart';
import '../../filters/application/filters_controller.dart';
import '../../location/application/location_controller.dart';

class SearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}

final searchQueryProvider = NotifierProvider<SearchQueryController, String>(
  SearchQueryController.new,
);

final searchHistoryProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(searchHistoryRepositoryProvider).watchRecent();
});

final searchResultsProvider = FutureProvider<List<Place>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.length < 2) return const [];

  final origin = ref.watch(locationProvider).point;
  if (origin == null) return const [];

  final filters = ref.watch(filtersProvider);
  final page = await ref
      .watch(placeRepositoryProvider)
      .searchByText(
        TextSearchQuery(
          query: query,
          origin: origin,
          radiusMeters: filters.radiusMeters,
          openNow: filters.openNow ? true : null,
        ),
      );
  return page.places;
});
