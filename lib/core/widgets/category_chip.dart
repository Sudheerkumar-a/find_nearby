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
    this.compact = false,
  });

  final AppCategory category;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _GxPill(
      selected: selected,
      onTap: onTap,
      compact: compact,
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
    this.compact = false,
  });

  final AppSubcategory subcategory;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _GxPill(
      selected: selected,
      onTap: onTap,
      compact: compact,
      label: subcategory.name,
    );
  }
}

class _GxPill extends StatelessWidget {
  const _GxPill({
    required this.selected,
    required this.onTap,
    required this.label,
    this.icon,
    this.compact = false,
  });

  final bool selected;
  final VoidCallback onTap;
  final String label;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hPad = compact ? (icon == null ? 10.0 : 8.0) : (icon == null ? 14.0 : 10.0);
    final vPad = compact ? 6.0 : 10.0;
    final iconSize = compact ? 16.0 : 18.0;

    return Material(
      color: selected ? AppColors.coral : Colors.white,
      elevation: selected ? 0 : 1,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(compact ? 20 : 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 20 : 24),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, vPad, hPad + 2, vPad),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: iconSize,
                  color: selected ? AppColors.onCoral : AppColors.teal,
                ),
                SizedBox(width: compact ? 4 : 6),
              ],
              Text(
                label,
                style: (compact
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.labelLarge)
                    ?.copyWith(
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
