import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.activeCount,
    required this.onPressed,
  });

  final int activeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = activeCount > 0 ? 'Filters ($activeCount)' : 'Filters';
    return Badge(
      isLabelVisible: activeCount > 0,
      backgroundColor: AppColors.coral,
      label: Text('$activeCount'),
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(16),
          child: IconButton(
            tooltip: label,
            onPressed: onPressed,
            icon: const Icon(Icons.tune_rounded, color: AppColors.tealDark),
          ),
        ),
      ),
    );
  }
}
