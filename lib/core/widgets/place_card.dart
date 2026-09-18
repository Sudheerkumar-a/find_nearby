import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import '../theme/app_colors.dart';
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
    return Material(
      color: AppColors.card,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
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
                if (place.isOpen != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: place.isOpen!
                            ? AppColors.success
                            : AppColors.coral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        place.isOpen! ? 'Open' : 'Closed',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                      fontWeight: FontWeight.w800,
                      color: AppColors.tealDark,
                    ),
                  ),
                  if (place.categoryLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      place.categoryLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
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
