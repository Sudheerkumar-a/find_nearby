import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/di/providers.dart';
import '../../../domain/entities/place.dart';

final favoritesProvider = StreamProvider<List<Place>>((ref) {
  return ref.watch(favoritesRepositoryProvider).watchAll();
});

final favoriteIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(favoritesProvider).value?.map((place) => place.id).toSet() ??
      {};
});

final favoriteToggleProvider = Provider<FavoriteToggle>((ref) {
  return FavoriteToggle(ref);
});

final class FavoriteToggle {
  FavoriteToggle(this._ref);

  final Ref _ref;

  Future<void> call(Place place) async {
    final ids = _ref.read(favoriteIdsProvider);
    final adding = !ids.contains(place.id);
    await _ref.read(favoritesRepositoryProvider).toggle(place);
    _ref.read(analyticsProvider).track(
      adding ? AnalyticsEvents.favoriteAdded : AnalyticsEvents.favoriteRemoved,
      {'place_id': place.id},
    );
  }
}
