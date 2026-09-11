import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/place_card.dart';
import '../../categories/application/category_providers.dart';
import '../application/favorites_filter.dart';
import '../application/favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final filter = ref.watch(favoritesFilterProvider);
    final categories = ref.watch(enabledCategoriesProvider);
    final ids = ref.watch(favoriteIdsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            PlaceCardSkeleton(),
            SizedBox(height: 14),
            PlaceCardSkeleton(),
          ],
        ),
        error: (error, _) => ErrorState.fromError(
          error,
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
        data: (places) {
          if (places.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the heart on a place to save it here.',
            );
          }

          final visible = filter == null
              ? places
              : places.where((place) => place.category == filter).toList();

          return Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: filter == null,
                        onSelected: (_) => ref
                            .read(favoritesFilterProvider.notifier)
                            .setFilter(null),
                      ),
                    ),
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: filter == category.name,
                          onSelected: (_) => ref
                              .read(favoritesFilterProvider.notifier)
                              .setFilter(category.name),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(
                        title: 'Nothing in this category',
                        message:
                            'Saved places from other categories are still here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: visible.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final place = visible[index];
                          return PlaceCard(
                            place: place,
                            isFavorite: ids.contains(place.id),
                            onOpen: () =>
                                context.push(AppRoutes.place(place.id)),
                            onFavorite: () =>
                                ref.read(favoriteToggleProvider)(place),
                            onCall: () => context.runAction(
                              () => DeviceActions.dial(place.phoneNumber!),
                            ),
                            onDirections: () => context.runAction(
                              () => DeviceActions.directions(
                                latitude: place.latitude,
                                longitude: place.longitude,
                                name: place.name,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
