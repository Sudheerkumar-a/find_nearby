import 'package:flutter/material.dart';

import '../utils/distance.dart';

class DistanceWidget extends StatelessWidget {
  const DistanceWidget({super.key, this.meters, this.address});

  final double? meters;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final parts = [Distance.format(meters), ?_locality(address)];
    return Row(
      children: [
        Icon(
          Icons.place_outlined,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            parts.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
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
