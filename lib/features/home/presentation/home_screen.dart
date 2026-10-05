import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/category_catalog.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/utils/directions_launcher.dart';
import '../../../core/errors/app_exception.dart';
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
import '../../../core/widgets/teal_wave_header.dart';
import '../../../domain/entities/place.dart';
import '../../categories/application/category_providers.dart';
import '../../favorites/application/favorites_providers.dart';
import '../../filters/application/filters_controller.dart';
import '../../filters/presentation/filter_bottom_sheet.dart';
import '../../location/application/location_controller.dart';
import '../../location/presentation/location_picker_sheet.dart';
import '../../places/application/discovery_providers.dart';
import '../../update/presentation/home_update_checker.dart';

const _sectionPad = EdgeInsets.fromLTRB(20, 12, 20, 6);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeUpdateChecker(child: _HomeBody(ref: ref));
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final filters = ref.watch(filtersProvider);
    final categories = ref.watch(enabledCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final nearby = ref.watch(nearbyPlacesProvider);
    final favoriteIds = ref.watch(favoriteIdsProvider);
    final quickActions = CategoryCatalog.homeQuickActions;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: RefreshIndicator(
        color: AppColors.coral,
        onRefresh: () async {
          await ref.read(locationProvider.notifier).refresh();
          ref.invalidate(nearbyPlacesProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TealWaveHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationHeader(
                      location: location,
                      onTeal: true,
                      onRefresh: () =>
                          ref.read(locationProvider.notifier).refresh(),
                      onChangeLocation: () =>
                          showLocationPickerSheet(context, ref),
                      onOpenSettings: () =>
                          ref.read(locationProvider.notifier).openSettings(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2,
                            shadowColor: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                            child: AppSearchBar(
                              readOnly: true,
                              onTap: () => context.push(AppRoutes.search),
                            ),
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
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Categories',
                padding: _sectionPad,
                trailing: TextButton(
                  onPressed: () => context.go(AppRoutes.explore),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.tealDark,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('See all'),
                      Icon(Icons.chevron_right_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 38,
                child: Stack(
                  children: [
                    ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 0, 52, 0),
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryChip(
                          compact: true,
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
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.scaffold.withValues(alpha: 0),
                              AppColors.scaffold,
                            ],
                          ),
                        ),
                        child: IconButton(
                          tooltip: 'See all categories',
                          onPressed: () => context.go(AppRoutes.explore),
                          icon: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedCategory != null) ...[
              const SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Subcategories',
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedCategory.subcategories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final sub = selectedCategory.subcategories[index];
                      return SubcategoryChip(
                        compact: true,
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
              child: SectionHeader(
                title: 'Quick',
                padding: EdgeInsets.fromLTRB(20, 10, 20, 6),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: quickActions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final action = quickActions[index];
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 8, 6),
                child: Row(
                  children: [
                    Text(
                      'Nearby places',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
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
            ..._nearbySlivers(
              nearby: nearby,
              locationReady: location.isReady,
              favoriteIds: favoriteIds,
              onRetry: () => ref.invalidate(nearbyPlacesProvider),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _nearbySlivers({
  required AsyncValue<List<Place>> nearby,
  required bool locationReady,
  required Set<String> favoriteIds,
  required VoidCallback onRetry,
}) {
  if (!locationReady) {
    return _nearbyLoadingSlivers();
  }

  return nearby.when(
    loading: _nearbyLoadingSlivers,
    error: (error, _) {
      if (error is LocationNotReadyException) {
        return _nearbyLoadingSlivers();
      }
      return [
        SliverToBoxAdapter(
          child: ErrorState.fromError(error, onRetry: onRetry),
        ),
      ];
    },
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
            separatorBuilder: (context, index) => const SizedBox(height: 10),
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
  );
}

List<Widget> _nearbyLoadingSlivers() {
  return [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => const PlaceCardSkeleton(),
      ),
    ),
  ];
}

class _HomePlaceCard extends ConsumerWidget {
  const _HomePlaceCard({required this.place, required this.isFavorite});

  final Place place;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final origin = ref.read(locationProvider).point;

    return PlaceCard(
      place: place,
      isFavorite: isFavorite,
      onOpen: () => context.push(AppRoutes.place(place.id)),
      onFavorite: () => ref.read(favoriteToggleProvider)(place),
      onCall: () =>
          context.runAction(() => DeviceActions.dial(place.phoneNumber!)),
      onDirections: () => context.runAction(
        () => DirectionsLauncher.show(
          context,
          latitude: place.latitude,
          longitude: place.longitude,
          name: place.name,
          origin: origin,
        ),
      ),
    );
  }
}
