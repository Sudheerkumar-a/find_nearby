import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/category_catalog.dart';
import '../../../domain/entities/search_filters.dart';
import '../../categories/application/category_providers.dart';
import '../application/filters_controller.dart';

Future<void> showFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const FilterBottomSheet(),
  );
}

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: FilterBottomSheet()));
  }
}

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late SearchFilters _draft;
  late double _customKm;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(filtersProvider);
    _customKm = (_draft.radiusMeters / 1000).clamp(0.5, 50);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(enabledCategoriesProvider);
    final selectedCategory = CategoryCatalog.byId(
      _draft.categoryId ?? '',
      categories,
    );

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.82,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _draft.activeCount == 0
                        ? 'Filters'
                        : 'Filters (${_draft.activeCount})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _draft = const SearchFilters();
                      _customKm = 2;
                    }),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _label(context, 'Distance'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final meters in AppConstants.radiusPresetsMeters)
                          ChoiceChip(
                            label: Text(_radiusLabel(meters)),
                            selected:
                                !_draft.customRadius &&
                                _draft.radiusMeters == meters,
                            onSelected: (_) => setState(() {
                              _draft = _draft.copyWith(
                                radiusMeters: meters,
                                customRadius: false,
                              );
                            }),
                          ),
                        ChoiceChip(
                          label: const Text('Custom'),
                          selected: _draft.customRadius,
                          onSelected: (_) => setState(() {
                            _draft = _draft.copyWith(
                              radiusMeters: _customKm * 1000,
                              customRadius: true,
                            );
                          }),
                        ),
                      ],
                    ),
                    if (_draft.customRadius) ...[
                      Slider(
                        min: 0.5,
                        max: 50,
                        divisions: 99,
                        label: '${_customKm.toStringAsFixed(1)} km',
                        value: _customKm,
                        onChanged: (value) => setState(() {
                          _customKm = value;
                          _draft = _draft.copyWith(radiusMeters: value * 1000);
                        }),
                      ),
                    ],
                    _label(context, 'Rating'),
                    Wrap(
                      spacing: 8,
                      children: [
                        _ratingChip(null, 'Any'),
                        _ratingChip(3, '3+'),
                        _ratingChip(4, '4+'),
                        _ratingChip(4.5, '4.5+'),
                      ],
                    ),
                    _label(context, 'Availability'),
                    FilterChip(
                      label: const Text('Open now'),
                      selected: _draft.openNow,
                      onSelected: (value) => setState(
                        () => _draft = _draft.copyWith(openNow: value),
                      ),
                    ),
                    _label(context, 'Category'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Any'),
                          selected: _draft.categoryId == null,
                          onSelected: (_) => setState(() {
                            _draft = _draft.copyWith(
                              clearCategory: true,
                              clearSubcategory: true,
                            );
                          }),
                        ),
                        for (final category in categories)
                          ChoiceChip(
                            label: Text(category.name),
                            selected: _draft.categoryId == category.id,
                            onSelected: (_) => setState(() {
                              _draft = _draft.copyWith(
                                categoryId: category.id,
                                clearSubcategory: true,
                              );
                            }),
                          ),
                      ],
                    ),
                    if (selectedCategory != null) ...[
                      _label(context, 'Subcategory'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final sub in selectedCategory.subcategories)
                            ChoiceChip(
                              label: Text(sub.name),
                              selected: _draft.subcategoryId == sub.id,
                              onSelected: (_) => setState(() {
                                _draft = _draft.copyWith(
                                  subcategoryId: sub.id,
                                  categoryId: selectedCategory.id,
                                );
                              }),
                            ),
                        ],
                      ),
                    ],
                    _label(context, 'Sort'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final sort in SortOption.values)
                          ChoiceChip(
                            label: Text(_sortLabel(sort)),
                            selected: _draft.sort == sort,
                            onSelected: (_) => setState(
                              () => _draft = _draft.copyWith(sort: sort),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ref.read(filtersProvider.notifier).apply(_draft);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingChip(double? rating, String label) {
    final selected = _draft.minRating == rating;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() {
        _draft = _draft.copyWith(
          minRating: rating,
          clearMinRating: rating == null,
        );
      }),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  String _radiusLabel(double meters) {
    return meters < 1000
        ? '${meters.round()} m'
        : '${(meters / 1000).round()} km';
  }

  String _sortLabel(SortOption sort) {
    return switch (sort) {
      SortOption.nearest => 'Nearest',
      SortOption.highestRated => 'Highest rated',
      SortOption.mostPopular => 'Most popular',
    };
  }
}
