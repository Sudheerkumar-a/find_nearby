import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import 'distance_widget.dart';
import 'favorite_button.dart';
import 'opening_status.dart';
import 'place_action_button.dart';
import 'place_image.dart';
import 'rating_widget.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.place,
    required this.isFavorite,
    required this.onOpen,
    required this.onFavorite,
    required this.onCall,
    required this.onDirections,
  });

  final Place place;
  final bool isFavorite;
  final VoidCallback onOpen;
  final VoidCallback onFavorite;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PlaceImage(place: place),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onFavorite,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (place.categoryLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      place.categoryLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  RatingWidget(
                    rating: place.rating,
                    reviewCount: place.reviewCount,
                  ),
                  const SizedBox(height: 6),
                  DistanceWidget(
                    meters: place.distanceMeters,
                    address: place.address,
                  ),
                  const SizedBox(height: 6),
                  OpeningStatus(isOpen: place.isOpen),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      PlaceActionButton(
                        icon: Icons.call_outlined,
                        label: 'Call',
                        enabled: place.hasPhone,
                        onPressed: onCall,
                      ),
                      const SizedBox(width: 10),
                      PlaceActionButton(
                        icon: Icons.near_me_outlined,
                        label: 'Directions',
                        onPressed: onDirections,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
