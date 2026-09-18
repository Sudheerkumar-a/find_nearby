import 'package:flutter/material.dart';

import '../../domain/entities/user_location.dart';
import '../theme/app_colors.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({
    super.key,
    required this.location,
    required this.onRefresh,
    this.onOpenSettings,
    this.onTeal = false,
  });

  final UserLocation location;
  final VoidCallback onRefresh;
  final VoidCallback? onOpenSettings;
  final bool onTeal;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, action) = switch (location.status) {
      LocationStatus.locating => (
        'Finding you',
        'Getting a more accurate location…',
        ('Refresh', onRefresh),
      ),
      LocationStatus.denied => (
        'Location needed',
        'Allow location to find places around you.',
        ('Enable Location', onRefresh),
      ),
      LocationStatus.deniedForever => (
        'Location blocked',
        'Open settings and allow location access.',
        ('Open Settings', onOpenSettings ?? onRefresh),
      ),
      LocationStatus.serviceDisabled => (
        'GPS is off',
        'Turn on location services to search nearby.',
        ('Enable Location', onRefresh),
      ),
      LocationStatus.timeout || LocationStatus.unavailable => (
        'Location unavailable',
        location.message ?? "We couldn't find you. Try again.",
        ('Try Again', onRefresh),
      ),
      LocationStatus.ready || LocationStatus.initial => (
        'Current location',
        location.label,
        ('Refresh', onRefresh),
      ),
    };

    final titleColor = onTeal ? AppColors.onTeal.withValues(alpha: 0.85) : null;
    final subtitleColor = onTeal ? AppColors.onTeal : null;
    final iconColor = onTeal ? AppColors.onTeal : AppColors.teal;

    return Row(
      children: [
        Icon(Icons.place_rounded, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: titleColor),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: action.$2,
          style: TextButton.styleFrom(
            foregroundColor: onTeal ? AppColors.onTeal : AppColors.tealDark,
          ),
          child: Text(action.$1),
        ),
      ],
    );
  }
}
