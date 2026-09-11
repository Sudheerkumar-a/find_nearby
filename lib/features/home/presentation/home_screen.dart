import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/category_catalog.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/utils/greeting.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/filter_button.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/location_header.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/quick_action_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../domain/entities/place.dart';
import '../../categories/application/category_providers.dart';
import '../../favorites/application/favorites_providers.dart';
import '../../filters/application/filters_controller.dart';
import '../../filters/presentation/filter_bottom_sheet.dart';
import '../../location/application/location_controller.dart';
import '../../places/application/discovery_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final filters = ref.watch(filtersProvider);
    final categories = ref.watch(enabledCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final nearby = ref.watch(nearbyPlacesProvider);
    final bestRated = ref.watch(bestRatedNearbyProvider);
    final favoriteIds = ref.watch(favoriteIdsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(locationProvider.notifier).refresh();
            ref.invalidate(nearbyPlacesProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${greetingFor(DateTime.now())} 👋',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppConstants.tagline,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LocationHeader(
                        location: location,
                        onRefresh: () =>
                            ref.read(locationProvider.notifier).refresh(),
                        onOpenSettings: () =>
                            ref.read(locationProvider.notifier).openSettings(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppSearchBar(
                              readOnly: true,
                              onTap: () => context.push(AppRoutes.search),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilterButton(
                            activeCount: filters.activeCount,
                            onPressed: () => showFilterBottomSheet(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SectionHeader(title: 'Popular')),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryChip(
                        category: category,
                        selected: filters.categoryId == category.id,
                        onTap: () {
                          final selected = filters.categoryId == category.id;
                          ref
                              .read(filtersProvider.notifier)
                              .setCategory(
                                categoryId: selected ? null : category.id,
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              if (selectedCategory != null) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Subcategories'),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: selectedCategory.subcategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sub = selectedCategory.subcategories[index];
                        return SubcategoryChip(
                          subcategory: sub,
                          selected: filters.subcategoryId == sub.id,
                          onTap: () {
                            final selected = filters.subcategoryId == sub.id;
                            ref
                                .read(filtersProvider.notifier)
                                .setCategory(
                                  categoryId: selectedCategory.id,
                                  subcategoryId: selected ? null : sub.id,
                                );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(
                child: SectionHeader(title: 'Quick actions'),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: CategoryCatalog.quickActions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 4),
                    itemBuilder: (context, index) {
                      final action = CategoryCatalog.quickActions[index];
                      return QuickActionButton(
                        action: action,
                        onTap: () {
                          ref
                              .read(filtersProvider.notifier)
                              .setCategory(
                                categoryId: action.categoryId,
                                subcategoryId: action.subcategoryId,
                              );
                        },
                      );
                    },
                  ),
                ),
              ),
              if (bestRated.isNotEmpty && filters.categoryId == null) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Best rated nearby'),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 86,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: bestRated.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final place = bestRated[index];
                        return ActionChip(
                          label: Text(
                            '${place.name}  ${place.rating?.toStringAsFixed(1) ?? ''}',
                          ),
                          onPressed: () =>
                              context.push(AppRoutes.place(place.id)),
                        );
                      },
                    ),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 8, 10),
                  child: Row(
                    children: [
                      Text(
                        'Nearby places',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => context.push(AppRoutes.map),
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Map'),
                      ),
                    ],
                  ),
                ),
              ),
              ...nearby.when(
                data: (places) {
                  if (places.isEmpty) {
                    return [
                      const SliverToBoxAdapter(
                        child: EmptyState(
                          title: 'Nothing nearby',
                          message:
                              'Try a wider search radius or a different category.',
                        ),
                      ),
                    ];
                  }
                  return [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverList.separated(
                        itemCount: places.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return _HomePlaceCard(
                            place: places[index],
                            isFavorite: favoriteIds.contains(places[index].id),
                          );
                        },
                      ),
                    ),
                  ];
                },
                loading: () => [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverList.separated(
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) =>
                          const PlaceCardSkeleton(),
                    ),
                  ),
                ],
                error: (error, _) => [
                  SliverToBoxAdapter(
                    child: ErrorState.fromError(
                      error,
                      onRetry: () => ref.invalidate(nearbyPlacesProvider),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePlaceCard extends ConsumerWidget {
  const _HomePlaceCard({required this.place, required this.isFavorite});

  final Place place;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlaceCard(
      place: place,
      isFavorite: isFavorite,
      onOpen: () => context.push(AppRoutes.place(place.id)),
      onFavorite: () => ref.read(favoriteToggleProvider)(place),
      onCall: () =>
          context.runAction(() => DeviceActions.dial(place.phoneNumber!)),
      onDirections: () => context.runAction(
        () => DeviceActions.directions(
          latitude: place.latitude,
          longitude: place.longitude,
          name: place.name,
        ),
      ),
    );
  }
}
