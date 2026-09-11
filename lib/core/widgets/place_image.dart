import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import '../utils/icon_map.dart';

class PlaceImage extends StatelessWidget {
  const PlaceImage({
    super.key,
    required this.place,
    this.height = 160,
    this.fit = BoxFit.cover,
  });

  final Place place;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = place.photos.where((item) => item.isNotEmpty).firstOrNull;
    if (url == null) {
      return _Fallback(place: place, height: height);
    }

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: fit,
      errorBuilder: (context, error, stack) =>
          _Fallback(place: place, height: height),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _Fallback(place: place, height: height);
      },
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.place, required this.height});

  final Place place;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: height,
      width: double.infinity,
      color: colors.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        iconFromName(_iconName(place)),
        size: 48,
        color: colors.onPrimaryContainer,
      ),
    );
  }

  String _iconName(Place place) {
    final sub = place.subcategory?.toLowerCase() ?? '';
    if (sub.contains('hospital')) return 'local_hospital';
    if (sub.contains('pharmac')) return 'local_pharmacy';
    if (sub.contains('cafe')) return 'local_cafe';
    if (sub.contains('hotel')) return 'hotel';
    if (sub.contains('atm')) return 'atm';
    if (sub.contains('park')) return 'park';
    if (sub.contains('cinema')) return 'movie';
    if (place.category?.toLowerCase() == 'food') return 'restaurant';
    if (place.category?.toLowerCase() == 'health') return 'health_and_safety';
    return 'place';
  }
}
