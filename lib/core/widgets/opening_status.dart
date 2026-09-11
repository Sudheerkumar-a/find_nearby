import 'package:flutter/material.dart';

class OpeningStatus extends StatelessWidget {
  const OpeningStatus({super.key, required this.isOpen});

  final bool? isOpen;

  @override
  Widget build(BuildContext context) {
    if (isOpen == null) {
      return Text(
        'Hours unavailable',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    final open = isOpen!;
    final color = open
        ? const Color(0xFF15803D)
        : Theme.of(context).colorScheme.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: color,
          semanticLabel: open ? 'Open now' : 'Closed',
        ),
        const SizedBox(width: 6),
        Text(
          open ? 'Open now' : 'Closed',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
