import 'package:flutter/material.dart';

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
      label: Text('$activeCount'),
      child: Semantics(
        button: true,
        label: label,
        child: IconButton.filledTonal(
          tooltip: label,
          onPressed: onPressed,
          icon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}
