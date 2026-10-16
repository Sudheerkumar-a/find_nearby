import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/icon_map.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../domain/entities/app_category.dart';
import '../../filters/application/filters_controller.dart';

/// Case-insensitive name match. Empty query returns [items] unchanged.
List<AppSubcategory> matchingSubcategories(
  List<AppSubcategory> items,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return items;
  return [
    for (final item in items)
      if (item.name.toLowerCase().contains(q)) item,
  ];
}

Future<void> showSubcategorySheet(BuildContext context, AppCategory category) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SubcategorySheet(category: category),
  );
}

class SubcategorySheet extends ConsumerStatefulWidget {
  const SubcategorySheet({super.key, required this.category});

  final AppCategory category;

  @override
  ConsumerState<SubcategorySheet> createState() => _SubcategorySheetState();
}

class _SubcategorySheetState extends ConsumerState<SubcategorySheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _choose({String? subcategoryId}) {
    ref
        .read(filtersProvider.notifier)
        .setCategory(
          categoryId: widget.category.id,
          subcategoryId: subcategoryId,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(filtersProvider).subcategoryId;
    final matches = matchingSubcategories(
      widget.category.subcategories,
      _query,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.category.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(filtersProvider.notifier).setCategory();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppSearchBar(
                  hint: 'Search subcategories',
                  controller: _search,
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                  children: [
                    ListTile(
                      title: Text('All ${widget.category.name}'),
                      selected: selectedId == null,
                      trailing: selectedId == null
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.teal,
                            )
                          : null,
                      onTap: () => _choose(),
                    ),
                    if (matches.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No matches', textAlign: TextAlign.center),
                      )
                    else
                      for (final sub in matches)
                        ListTile(
                          leading: Icon(
                            iconFromName(sub.icon ?? widget.category.icon),
                            color: AppColors.teal,
                          ),
                          title: Text(sub.name),
                          selected: selectedId == sub.id,
                          trailing: selectedId == sub.id
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: AppColors.teal,
                                )
                              : null,
                          onTap: () => _choose(subcategoryId: sub.id),
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
}
