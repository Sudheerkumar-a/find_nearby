import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/utils/icon_map.dart';
import '../../../core/widgets/error_state.dart';
import '../application/category_providers.dart';

class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(categoryRepositoryProvider).resetToDefaults(),
            child: const Text('Reset'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCustom(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Custom'),
      ),
      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState.fromError(
          error,
          onRetry: () => ref.invalidate(categoriesProvider),
        ),
        data: (items) {
          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
            itemCount: items.length,
            onReorderItem: (oldIndex, newIndex) {
              final copy = [...items];
              final item = copy.removeAt(oldIndex);
              copy.insert(newIndex, item);
              ref
                  .read(categoryRepositoryProvider)
                  .reorder(copy.map((c) => c.id).toList());
            },
            itemBuilder: (context, index) {
              final category = items[index];
              return SwitchListTile(
                key: ValueKey(category.id),
                secondary: Icon(iconFromName(category.icon)),
                title: Text(category.name),
                subtitle: Text(
                  category.isCustom
                      ? 'Custom'
                      : '${category.subcategories.length} subcategories',
                ),
                value: category.enabled,
                onChanged: (value) => ref
                    .read(categoryRepositoryProvider)
                    .setEnabled(category.id, value),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addCustom(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    final query = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add custom category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: query,
                decoration: const InputDecoration(labelText: 'Search query'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (added == true &&
        name.text.trim().isNotEmpty &&
        query.text.trim().isNotEmpty) {
      await ref
          .read(categoryRepositoryProvider)
          .addCustom(name: name.text.trim(), query: query.text.trim());
    }
    name.dispose();
    query.dispose();
  }
}
