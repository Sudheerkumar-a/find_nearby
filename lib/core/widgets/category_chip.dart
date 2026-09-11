import 'package:flutter/material.dart';

import '../../domain/entities/app_category.dart';
import '../utils/icon_map.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final AppCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: Icon(iconFromName(category.icon), size: 18),
      label: Text(category.name),
      showCheckmark: false,
    );
  }
}

class SubcategoryChip extends StatelessWidget {
  const SubcategoryChip({
    super.key,
    required this.subcategory,
    required this.selected,
    required this.onTap,
  });

  final AppSubcategory subcategory;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text(subcategory.name),
    );
  }
}
