import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';

import '../../../core/utils/icon_map.dart';
import '../../../domain/entities/app_category.dart';
import '../../categories/application/category_providers.dart';
import '../../filters/application/filters_controller.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(enabledCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryBlock(
            category: category,
            onSubcategory: (sub) {
              ref
                  .read(filtersProvider.notifier)
                  .setCategory(categoryId: category.id, subcategoryId: sub.id);
              context.go(AppRoutes.home);
            },
          );
        },
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
