import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, this.rating, this.reviewCount});

  final double? rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    if (rating == null || rating! <= 0) {
      return Text(
        'No ratings yet',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    final count = reviewCount;
    final countLabel = count == null
        ? null
        : NumberFormat.decimalPattern().format(count);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 18,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (countLabel != null) ...[
          const SizedBox(width: 4),
          Text(
            '($countLabel)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
