import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/icon_map.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../domain/entities/app_category.dart';
import '../../categories/application/category_providers.dart';
import '../../filters/application/filters_controller.dart';

/// Category name match keeps every subcategory. Otherwise only matching names.
List<AppCategory> matchingExploreCategories(
  List<AppCategory> categories,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return categories;
  return [
    for (final category in categories)
      if (category.name.toLowerCase().contains(q))
        category
      else if (category.subcategories.any(
        (sub) => sub.name.toLowerCase().contains(q),
      ))
        category.copyWith(
          subcategories: [
            for (final sub in category.subcategories)
              if (sub.name.toLowerCase().contains(q)) sub,
          ],
        ),
  ];
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(enabledCategoriesProvider);
    final visible = matchingExploreCategories(categories, _query);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: AppSearchBar(
              hint: 'Search categories',
              controller: _search,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? const Center(child: Text('No matches'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final category = visible[index];
                      return _CategoryBlock(
                        category: category,
                        onSubcategory: (sub) {
                          ref
                              .read(filtersProvider.notifier)
                              .setCategory(
                                categoryId: category.id,
                                subcategoryId: sub.id,
                              );
                          context.go(AppRoutes.home);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({required this.category, required this.onSubcategory});

  final AppCategory category;
  final ValueChanged<AppSubcategory> onSubcategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final sub in category.subcategories)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(iconFromName(sub.icon ?? category.icon)),
                ),
                title: Text(sub.name),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => onSubcategory(sub),
              ),
            ),
        ],
      ),
    );
  }
}
