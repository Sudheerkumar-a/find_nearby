import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../mappers/geoapify_category_mapper.dart';
import '../mappers/geoapify_place_mapper.dart';

/// Geoapify Places + Place Details.
/// Docs: https://apidocs.geoapify.com/docs/places/
///       https://apidocs.geoapify.com/docs/place-details/
final class GeoapifyPlaceRepository implements PlaceRepository {
  GeoapifyPlaceRepository({Dio? dio, String? apiKey})
    : _dio =
          dio ?? createGeoapifyDio(apiKey: apiKey ?? AppConfig.geoapifyApiKey);

  final Dio _dio;
  CancelToken? _nearbyToken;
  CancelToken? _textToken;

  final _memory = <String, (DateTime, PlacePage)>{};

  /// Broad POI set for home "nearby" when no category chip is selected.
  static const _defaultNearbyCategories =
      'catering,commercial,healthcare,service,accommodation,entertainment,education,tourism,leisure';

  @override
  Future<PlacePage> searchNearby(NearbyQuery query) async {
    final mapped = query.placeCategory != null
        ? GeoapifyCategoryMapper.categoryOf(query.placeCategory!)
        : query.categoryGroup != null
        ? GeoapifyCategoryMapper.categoryForGroup(query.categoryGroup!)
        : null;
    assert(
      mapped == null || GeoapifyCategoryMapper.isValidGeoapifyCategory(mapped),
      'Invalid Geoapify category: $mapped',
    );
    final nameFilter = (query.textQuery ?? '').trim();
    final category =
        mapped ?? (nameFilter.isEmpty ? _defaultNearbyCategories : null);

    final key =
        'g-n:${query.origin.latitude.toStringAsFixed(3)},${query.origin.longitude.toStringAsFixed(3)}:'
        '${query.radiusMeters}:$category:$nameFilter:${query.openNow}';
    final cached = _cached(key);
    if (cached != null) return cached;

    // Geoapify does not expose a reliable "open now" filter in Places search —
    // leave openNow handling to the client filter engine (unknowns stay).
    _nearbyToken?.cancel();
    _nearbyToken = CancelToken();

    try {
      final started = DateTime.now();
      final response = await _dio.get<Map<String, dynamic>>(
        '/v2/places',
        queryParameters: {
          'categories': ?category,
          if (nameFilter.isNotEmpty) 'name': nameFilter,
          'filter':
              'circle:${query.origin.longitude},${query.origin.latitude},${query.radiusMeters.round()}',
          'bias':
              'proximity:${query.origin.longitude},${query.origin.latitude}',
          'limit': 20,
        },
        cancelToken: _nearbyToken,
      );
      var places = GeoapifyPlaceMapper.fromResponse(response.data);
      // openNow: Geoapify list responses usually lack hours — leave isOpen null;
      // PlaceFilterEngine keeps nulls and only drops explicit closed.
      final page = PlacePage(places: places);
      _memory[key] = (DateTime.now(), page);
      if (kDebugMode) {
        debugPrint(
          '[Places] Geoapify nearby: ${places.length} results, '
          '${DateTime.now().difference(started).inMilliseconds}ms',
        );
      }
      return page;
    } catch (error) {
      if (error is DioException && error.type == DioExceptionType.cancel) {
        return const PlacePage(places: []);
      }
      throw mapDioError(error);
    }
  }

  @override
  Future<PlacePage> searchByText(TextSearchQuery query) async {
    final needle = query.query.trim();
    if (needle.isEmpty) return const PlacePage(places: []);

    final key =
        'g-t:$needle:${query.origin.latitude.toStringAsFixed(3)},'
        '${query.origin.longitude.toStringAsFixed(3)}:${query.radiusMeters}:${query.openNow}';
    final cached = _cached(key);
    if (cached != null) return cached;

    _textToken?.cancel();
    _textToken = CancelToken();

    try {
      final started = DateTime.now();
      // Places API supports optional `name` with spatial filter/bias.
      final response = await _dio.get<Map<String, dynamic>>(
        '/v2/places',
        queryParameters: {
          'name': needle,
          // Broad commercial+catering+service umbrella via multiple categories.
          'categories':
              'catering,commercial,healthcare,service,accommodation,entertainment,education,tourism',
          'filter':
              'circle:${query.origin.longitude},${query.origin.latitude},${query.radiusMeters.round()}',
          'bias':
              'proximity:${query.origin.longitude},${query.origin.latitude}',
          'limit': 20,
        },
        cancelToken: _textToken,
      );
      var places = GeoapifyPlaceMapper.fromResponse(response.data);
      final page = PlacePage(places: places);
      _memory[key] = (DateTime.now(), page);
      if (kDebugMode) {
        debugPrint(
          '[Places] Geoapify text: ${places.length} results, '
          '${DateTime.now().difference(started).inMilliseconds}ms',
        );
      }
      return page;
    } catch (error) {
      if (error is DioException && error.type == DioExceptionType.cancel) {
        return const PlacePage(places: []);
      }
      throw mapDioError(error);
    }
  }

  @override
  Future<Place?> getPlaceDetails(String placeId) async {
    final providerId = placeId.contains(':')
        ? placeId.split(':').last
        : placeId;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v2/place-details',
        queryParameters: {'id': providerId, 'features': 'details'},
      );
      final features = response.data?['features'] as List? ?? const [];
      if (features.isEmpty) throw const PlaceNotFoundException();
      final first = features.first;
      if (first is! Map) throw const PlaceNotFoundException();
      return GeoapifyPlaceMapper.fromFeature(Map<String, dynamic>.from(first));
    } on AppException {
      rethrow;
    } catch (error) {
      final mapped = mapDioError(error);
      if (mapped is ApiException && mapped.statusCode == 404) {
        throw const PlaceNotFoundException();
      }
      throw mapped;
    }
  }

  @override
  Future<List<String>> getPlacePhotos(String placeId) async {
    final place = await getPlaceDetails(placeId);
    return place?.photos ?? const [];
  }

  PlacePage? _cached(String key) {
    final entry = _memory[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.$1) > const Duration(minutes: 2)) {
      _memory.remove(key);
      return null;
    }
    return entry.$2;
  }
}
