import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/place.dart';

final placeDetailsProvider = FutureProvider.family<Place, String>((
  ref,
  placeId,
) async {
  return ref.watch(placeCacheServiceProvider).getDetails(placeId);
});
