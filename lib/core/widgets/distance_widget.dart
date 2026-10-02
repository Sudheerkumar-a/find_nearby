import 'package:flutter/material.dart';

import '../utils/distance.dart';

class DistanceWidget extends StatelessWidget {
  const DistanceWidget({
    super.key,
    this.meters,
    this.address,
    this.compact = false,
  });

  final double? meters;
  final String? address;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = scheme.onSurface.withValues(alpha: 0.85);
    final icon = compact ? Icons.directions_walk_rounded : Icons.place_outlined;
    final parts = compact
        ? [Distance.format(meters)]
        : [Distance.format(meters), ?_locality(address)];

    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Icon(icon, size: compact ? 14 : 16, color: color),
        const SizedBox(width: 4),
        if (compact)
          Text(
            parts.join(' · '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          Flexible(
            child: Text(
              parts.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
      ],
    );
  }

  String? _locality(String? address) {
    if (address == null || address.isEmpty) return null;
    final parts = address.split(',').map((part) => part.trim()).toList();
    return parts.length >= 2 ? parts[parts.length - 1] : parts.last;
  }
}
