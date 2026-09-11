import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics.dart';
import '../../../core/di/providers.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/opening_status.dart';
import '../../../core/widgets/place_image.dart';
import '../../../core/widgets/rating_widget.dart';
import '../../../domain/entities/place.dart';
import '../../favorites/application/favorites_providers.dart';
import '../application/place_details_provider.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  const PlaceDetailsScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(placeDetailsProvider(placeId));
    final favoriteIds = ref.watch(favoriteIdsProvider);

    return details.when(
      loading: () => const Scaffold(body: Center(child: PlaceCardSkeleton())),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState.fromError(
          error,
          onRetry: () => ref.invalidate(placeDetailsProvider(placeId)),
        ),
      ),
      data: (place) => _DetailsBody(
        place: place,
        isFavorite: favoriteIds.contains(place.id),
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.place, required this.isFavorite});

  final Place place;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            flexibleSpace: FlexibleSpaceBar(
              background: PlaceImage(place: place, height: 300),
            ),
            actions: [
              FavoriteButton(
                isFavorite: isFavorite,
                onPressed: () => ref.read(favoriteToggleProvider)(place),
              ),
              IconButton(
                tooltip: 'Share',
                onPressed: () =>
                    context.runAction(() => DeviceActions.sharePlace(place)),
                icon: const Icon(Icons.share_outlined),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                RatingWidget(
                  rating: place.rating,
                  reviewCount: place.reviewCount,
                ),
                if (place.categoryLabel.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    place.categoryLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 16),
                if (place.address != null)
                  _InfoRow(icon: Icons.place_outlined, text: place.address!),
                const SizedBox(height: 8),
                OpeningStatus(isOpen: place.isOpen),
                if (place.openingHours.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    place.openingHours.join('\n'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (place.hasPhone) ...[
                  const SizedBox(height: 16),
                  _InfoRow(icon: Icons.call_outlined, text: place.phoneNumber!),
                ],
                if (place.hasWebsite) ...[
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.public_outlined, text: place.website!),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: place.hasPhone
                            ? () {
                                ref.read(analyticsProvider).track(
                                  AnalyticsEvents.callClicked,
                                  {'place_id': place.id},
                                );
                                context.runAction(
                                  () => DeviceActions.dial(place.phoneNumber!),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.call_rounded),
                        label: const Text('Call'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          ref.read(analyticsProvider).track(
                            AnalyticsEvents.directionsClicked,
                            {'place_id': place.id},
                          );
                          context.runAction(
                            () => DeviceActions.directions(
                              latitude: place.latitude,
                              longitude: place.longitude,
                              name: place.name,
                            ),
                          );
                        },
                        icon: const Icon(Icons.near_me_rounded),
                        label: const Text('Directions'),
                      ),
                    ),
                  ],
                ),
                if (place.hasWebsite) ...[
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(analyticsProvider).track(
                        AnalyticsEvents.websiteClicked,
                        {'place_id': place.id},
                      );
                      context.runAction(
                        () => DeviceActions.website(place.website!),
                      );
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Visit website'),
                  ),
                ],
                if (place.description != null) ...[
                  const SizedBox(height: 28),
                  Text('About', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(place.description!),
                ],
                const SizedBox(height: 28),
                Text('Map', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Material(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.push(AppRoutes.map),
                    child: SizedBox(
                      height: 160,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: colors.primary,
                              size: 36,
                            ),
                            const SizedBox(height: 8),
                            const Text('Open map'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
