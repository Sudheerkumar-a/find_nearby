import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/debounce.dart';
import '../../../core/utils/device_actions.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/place_card.dart';
import '../../favorites/application/favorites_providers.dart';
import '../application/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  final _debouncer = Debouncer(delay: AppConstants.searchDebounce);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final history = ref.watch(searchHistoryProvider).value ?? const [];
    final favoriteIds = ref.watch(favoriteIdsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: AppSearchBar(
              controller: _controller,
              autofocus: true,
              onChanged: (value) {
                _debouncer.run(() {
                  ref.read(searchQueryProvider.notifier).setQuery(value);
                  if (value.trim().length >= 2) {
                    ref.read(searchHistoryRepositoryProvider).add(value);
                  }
                });
              },
            ),
          ),
          Expanded(child: _body(query, results, history, favoriteIds)),
        ],
      ),
    );
  }

  Widget _body(
    String query,
    AsyncValue<List<dynamic>> results,
    List<String> history,
    Set<String> favoriteIds,
  ) {
    if (query.trim().length < 2) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          if (history.isNotEmpty) ...[
            Row(
              children: [
                Text('Recent', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      ref.read(searchHistoryRepositoryProvider).clear(),
                  child: const Text('Clear'),
                ),
              ],
            ),
            for (final item in history)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history_rounded),
                title: Text(item),
                onTap: () {
                  _controller.text = item;
                  ref.read(searchQueryProvider.notifier).setQuery(item);
                },
              ),
          ],
          const SizedBox(height: 8),
          Text('Suggested', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in const [
                'Restaurants',
                'Pizza',
                'Hospitals',
                'Pharmacies',
                'Hotels',
                'Schools',
                'Car repair',
                'Cafes',
              ])
                ActionChip(
                  label: Text(suggestion),
                  onPressed: () {
                    _controller.text = suggestion;
                    ref.read(searchQueryProvider.notifier).setQuery(suggestion);
                    ref.read(searchHistoryRepositoryProvider).add(suggestion);
                  },
                ),
            ],
          ),
        ],
      );
    }

    return results.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          PlaceCardSkeleton(),
          SizedBox(height: 14),
          PlaceCardSkeleton(),
        ],
      ),
      error: (error, _) => ErrorState.fromError(
        error,
        onRetry: () => ref.invalidate(searchResultsProvider),
      ),
      data: (places) {
        if (places.isEmpty) {
          return const EmptyState(
            title: 'No places found',
            message: 'Try another search or widen the radius in Filters.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          itemCount: places.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final place = places[index];
            return PlaceCard(
              place: place,
              isFavorite: favoriteIds.contains(place.id),
              onOpen: () => context.push(AppRoutes.place(place.id)),
              onFavorite: () => ref.read(favoriteToggleProvider)(place),
              onCall: () => context.runAction(
                () => DeviceActions.dial(place.phoneNumber!),
              ),
              onDirections: () => context.runAction(
                () => DeviceActions.directions(
                  latitude: place.latitude,
                  longitude: place.longitude,
                  name: place.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
