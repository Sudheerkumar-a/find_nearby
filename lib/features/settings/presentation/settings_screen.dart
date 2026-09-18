import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/device_actions.dart';
import '../../../domain/entities/place_search_mode.dart';
import '../../filters/application/filters_controller.dart';
import '../../location/application/location_controller.dart';
import '../../places/application/discovery_providers.dart';
import '../application/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsRepositoryProvider);
    final themeAsync = ref.watch(themeModeProvider);
    final themeMode = themeAsync.value ?? ThemeMode.system;
    final filters = ref.watch(filtersProvider);
    final placeMode =
        ref.watch(placeSearchModeProvider).value ?? PlaceSearchMode.mock;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Manage Categories'),
            onTap: () => context.push(AppRoutes.manageCategories),
          ),
          ListTile(
            leading: const Icon(Icons.radar_outlined),
            title: const Text('Search Radius'),
            subtitle: Text(
              '${(filters.radiusMeters / 1000).toStringAsFixed(1)} km',
            ),
            onTap: () => _editRadius(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.my_location_outlined),
            title: const Text('Location Settings'),
            subtitle: const Text('Refresh or grant location access'),
            onTap: () => ref.read(locationProvider.notifier).refresh(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Place Data Provider',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Automatic combines Google and Geoapify when both keys are set.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mode in const [
                  PlaceSearchMode.automatic,
                  PlaceSearchMode.google,
                  PlaceSearchMode.geoapify,
                  PlaceSearchMode.mock,
                ])
                  ChoiceChip(
                    label: Text(mode.label),
                    selected: placeMode == mode,
                    onSelected: (_) async {
                      await settings.setPlaceSearchMode(mode);
                      ref.invalidate(nearbyPlacesProvider);
                    },
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('Theme', style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('System'),
                  selected: themeMode == ThemeMode.system,
                  onSelected: (_) => settings.setThemeMode(ThemeMode.system),
                ),
                ChoiceChip(
                  label: const Text('Light'),
                  selected: themeMode == ThemeMode.light,
                  onSelected: (_) => settings.setThemeMode(ThemeMode.light),
                ),
                ChoiceChip(
                  label: const Text('Dark'),
                  selected: themeMode == ThemeMode.dark,
                  onSelected: (_) => settings.setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Coming later — preference is saved locally.'),
            value: false,
            onChanged: (value) => settings.setNotificationsEnabled(value),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => context.runAction(
              () => DeviceActions.website(AppConstants.privacyPolicyUrl),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Terms'),
            onTap: () => context.runAction(
              () => DeviceActions.website(AppConstants.termsUrl),
            ),
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: AppConstants.appName,
            applicationLegalese: AppConstants.tagline,
            applicationVersion: '1.0.0',
          ),
        ],
      ),
    );
  }

  Future<void> _editRadius(BuildContext context, WidgetRef ref) async {
    final current = ref.read(filtersProvider).radiusMeters;
    var km = current / 1000;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Search radius',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Slider(
                    min: AppConstants.minRadiusMeters / 1000,
                    max: AppConstants.maxRadiusMeters / 1000,
                    divisions: 45,
                    label: '${km.toStringAsFixed(0)} km',
                    value: km.clamp(
                      AppConstants.minRadiusMeters / 1000,
                      AppConstants.maxRadiusMeters / 1000,
                    ),
                    onChanged: (value) => setState(() => km = value),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final meters = AppConstants.clampRadiusMeters(km * 1000);
                      ref
                          .read(filtersProvider.notifier)
                          .apply(
                            ref
                                .read(filtersProvider)
                                .copyWith(
                                  radiusMeters: meters,
                                  customRadius: !AppConstants
                                      .radiusPresetsMeters
                                      .contains(meters),
                                ),
                          );
                      await ref
                          .read(settingsRepositoryProvider)
                          .setSearchRadiusMeters(meters);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
