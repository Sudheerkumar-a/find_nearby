import 'package:flutter/material.dart';

import '../../domain/entities/app_category.dart';
import '../theme/app_colors.dart';
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
    return _GxPill(
      selected: selected,
      onTap: onTap,
      icon: iconFromName(category.icon),
      label: category.name,
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
    return _GxPill(selected: selected, onTap: onTap, label: subcategory.name);
  }
}

class _GxPill extends StatelessWidget {
  const _GxPill({
    required this.selected,
    required this.onTap,
    required this.label,
    this.icon,
  });

  final bool selected;
  final VoidCallback onTap;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.coral : Colors.white,
      elevation: selected ? 0 : 1,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: EdgeInsets.fromLTRB(icon == null ? 14 : 10, 10, 14, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppColors.onCoral : AppColors.teal,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.onCoral : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
