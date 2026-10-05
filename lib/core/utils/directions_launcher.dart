import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../domain/entities/place.dart';
import '../errors/app_exception.dart';

/// Maps offered for directions (tree-shaken — only these ship in release).
const directionMapApps = <MapApp>[MapApp.google, MapApp.apple, MapApp.waze];

abstract final class DirectionsLauncher {
  /// Shows installed map apps; opens route preview (not turn-by-turn start).
  static Future<void> show(
    BuildContext context, {
    required double latitude,
    required double longitude,
    String? name,
    GeoPoint? origin,
  }) async {
    final destination = LocationCoords(latitude, longitude, title: name);
    final request = MapLauncher.directions(
      destination,
      from: origin == null
          ? null
          : LocationCoords(origin.latitude, origin.longitude),
    );

    final maps = (await request.getSupportedMaps(
      directionMapApps,
    )).where((map) => map.isInstalled).toList();
    if (maps.isEmpty) {
      throw const ActionUnavailableException(
        message: 'Install Google Maps, Apple Maps, or Waze to get directions.',
      );
    }

    if (maps.length == 1) {
      await _openDirectionsMap(maps.first);
      return;
    }

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => _MapAppPickerSheet(maps: maps),
    );
  }
}

Future<void> _openDirectionsMap(SupportedMap map) async {
  try {
    await map.show();
  } on MapLaunchException {
    throw const ActionUnavailableException(
      message: 'Could not open the selected map app.',
    );
  }
}

class _MapAppPickerSheet extends StatelessWidget {
  const _MapAppPickerSheet({required this.maps});

  final List<SupportedMap> maps;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              'Open directions with',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          for (final map in maps)
            ListTile(
              leading: Image.memory(map.iconBytes, width: 32, height: 32),
              title: Text(map.name),
              onTap: () async {
                Navigator.of(context).pop();
                await _openDirectionsMap(map);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
