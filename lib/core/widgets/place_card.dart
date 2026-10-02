import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import '../theme/app_colors.dart';
import '../utils/icon_map.dart';
import 'distance_widget.dart';
import 'opening_status.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final category = place.categoryLabel;
    final muted = scheme.onSurface.withValues(alpha: 0.72);

    return Material(
      color: scheme.surfaceContainerLow,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: PlaceImage(place: place, height: 72),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                place.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: text.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                              onPressed: onFavorite,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 22,
                                color: isFavorite
                                    ? AppColors.coral
                                    : scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingWidget(
                              rating: place.rating,
                              reviewCount: place.reviewCount,
                            ),
                            const Spacer(),
                            DistanceWidget(
                              meters: place.distanceMeters,
                              compact: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            OpeningStatus(isOpen: place.isOpen),
                            if (category.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '·',
                                  style: text.bodySmall?.copyWith(color: muted),
                                ),
                              ),
                              Icon(
                                iconFromName(_categoryIcon(place)),
                                size: 14,
                                color: muted,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.bodySmall?.copyWith(color: muted),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (place.address != null && place.address!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.place_outlined, size: 16, color: muted),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        place.address!,
                        style: text.bodySmall?.copyWith(color: muted),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    _ActionPill(
                      tooltip: place.hasPhone
                          ? 'Call'
                          : 'Phone number unavailable',
                      icon: Icons.call_outlined,
                      label: 'Call',
                      onPressed: place.hasPhone ? onCall : null,
                    ),
                    _ActionPill(
                      tooltip: 'Directions',
                      icon: Icons.near_me_outlined,
                      label: 'Directions',
                      onPressed: onDirections,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryIcon(Place place) {
    final sub = place.subcategory?.toLowerCase() ?? '';
    if (sub.contains('hospital')) return 'local_hospital';
    if (sub.contains('pharmac')) return 'local_pharmacy';
    if (sub.contains('cafe')) return 'local_cafe';
    if (sub.contains('hotel')) return 'hotel';
    if (sub.contains('atm')) return 'atm';
    if (sub.contains('park')) return 'park';
    if (sub.contains('cinema')) return 'movie';
    if (place.category?.toLowerCase() == 'food') return 'restaurant';
    if (place.category?.toLowerCase() == 'health') return 'health_and_safety';
    return 'place';
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.tooltip,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.onTeal,
          disabledBackgroundColor: AppColors.teal.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.onTeal.withValues(alpha: 0.7),
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(0, 32),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
