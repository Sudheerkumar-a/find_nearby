import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../location/application/location_controller.dart';
import '../../places/application/discovery_providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearby = ref.watch(nearbyPlacesProvider);
    final location = ref.watch(locationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            tooltip: 'Recenter',
            onPressed: () => ref.read(locationProvider.notifier).refresh(),
            icon: const Icon(Icons.my_location_rounded),
          ),
        ],
      ),
      body: nearby.when(
        loading: () => const Center(child: PlaceCardSkeleton()),
        error: (error, _) => ErrorState.fromError(
          error,
          onRetry: () => ref.invalidate(nearbyPlacesProvider),
        ),
        data: (places) {
          if (places.isEmpty) {
            return const EmptyState(
              title: 'No places to show',
              message: 'Search or pick a category first, then open the map.',
            );
          }
          return Column(
            children: [
              Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: Text(location.label),
                  subtitle: const Text(
                    'List is the primary way to discover. Open a place for directions.',
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: places.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return ListTile(
                      title: Text(place.name),
                      subtitle: Text(place.address ?? place.categoryLabel),
                      trailing: IconButton(
                        tooltip: 'Directions',
                        onPressed: () => context.runAction(
                          () => DeviceActions.directions(
                            latitude: place.latitude,
                            longitude: place.longitude,
                            name: place.name,
                          ),
                        ),
                        icon: const Icon(Icons.near_me_outlined),
                      ),
                      onTap: () => context.push(AppRoutes.place(place.id)),
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
