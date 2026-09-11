import 'package:flutter/material.dart';

import '../../domain/entities/user_location.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({
    super.key,
    required this.location,
    required this.onRefresh,
    this.onOpenSettings,
  });

  final UserLocation location;
  final VoidCallback onRefresh;
  final VoidCallback? onOpenSettings;

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

    return Row(
      children: [
        Icon(Icons.place_rounded, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        TextButton(onPressed: action.$2, child: Text(action.$1)),
      ],
    );
  }
}
