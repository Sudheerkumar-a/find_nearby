import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../domain/entities/place.dart';

final placeDetailsProvider = FutureProvider.family<Place, String>((
  ref,
  placeId,
) async {
  final place = await ref
      .watch(placeRepositoryProvider)
      .getPlaceDetails(placeId);
  if (place == null) {
    throw const PlaceNotFoundException();
  }
  return place;
});
