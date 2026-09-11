import 'package:flutter/foundation.dart';

import '../../core/utils/distance.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/services/place_deduplication_service.dart';
import '../../domain/services/place_ranking_service.dart';

/// Runs Google + Geoapify in parallel, then normalize → dedupe → rank.
final class HybridPlaceRepository implements PlaceRepository {
  HybridPlaceRepository({required this.google, required this.geoapify});

  final PlaceRepository google;
  final PlaceRepository geoapify;

  @override
  Future<PlacePage> searchNearby(NearbyQuery query) {
    return _combine(
      () => google.searchNearby(query),
      () => geoapify.searchNearby(query),
      origin: query.origin,
    );
  }

  @override
  Future<PlacePage> searchByText(TextSearchQuery query) {
    return _combine(
      () => google.searchByText(query),
      () => geoapify.searchByText(query),
      origin: query.origin,
    );
  }

  @override
  Future<Place?> getPlaceDetails(String placeId) async {
    if (placeId.startsWith('${PlaceSource.geoapify.name}:')) {
      return geoapify.getPlaceDetails(placeId);
    }
    if (placeId.startsWith('${PlaceSource.googlePlaces.name}:') ||
        placeId.startsWith('${PlaceSource.mock.name}:')) {
      return google.getPlaceDetails(placeId);
    }
    // Unknown prefix — try Google then Geoapify.
    try {
      return await google.getPlaceDetails(placeId);
    } catch (_) {
      return geoapify.getPlaceDetails(placeId);
    }
  }

  @override
  Future<List<String>> getPlacePhotos(String placeId) async {
    final place = await getPlaceDetails(placeId);
    return place?.photos ?? const [];
  }

  Future<PlacePage> _combine(
    Future<PlacePage> Function() left,
    Future<PlacePage> Function() right, {
    required GeoPoint origin,
  }) async {
    final results = await Future.wait([_guard(left), _guard(right)]);
    final googlePage = results[0];
    final geoPage = results[1];

    if (googlePage.error != null && geoPage.error != null) {
      throw googlePage.error!;
    }

    final merged = <Place>[
      ...?googlePage.page?.places,
      ...?geoPage.page?.places,
    ];
    final withDistance = merged.map((place) {
      return place.copyWith(
        distanceMeters:
            place.distanceMeters ??
            Distance.metersBetween(
              fromLat: origin.latitude,
              fromLng: origin.longitude,
              toLat: place.latitude,
              toLng: place.longitude,
            ),
      );
    }).toList();

    final unique = PlaceDeduplicationService.dedupe(withDistance);
    final ranked = PlaceRankingService.rank(unique, sort: SortOption.nearest);

    if (kDebugMode) {
      debugPrint(
        '[Places] Google nearby/text: ${googlePage.page?.places.length ?? 0}'
        '${googlePage.error != null ? ' (failed)' : ''}',
      );
      debugPrint(
        '[Places] Geoapify nearby/text: ${geoPage.page?.places.length ?? 0}'
        '${geoPage.error != null ? ' (failed)' : ''}',
      );
      debugPrint('[Places] Combined: ${ranked.length} unique results');
    }

    return PlacePage(places: ranked);
  }

  Future<_Attempt> _guard(Future<PlacePage> Function() run) async {
    try {
      return _Attempt(page: await run());
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[Places] provider failed: $error');
      }
      return _Attempt(error: error);
    }
  }
}

final class _Attempt {
  const _Attempt({this.page, this.error});

  final PlacePage? page;
  final Object? error;
}
