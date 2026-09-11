import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../mappers/google_category_mapper.dart';
import '../mappers/google_place_mapper.dart';

final class GooglePlacesRepository implements PlaceRepository {
  GooglePlacesRepository({Dio? dio, String? apiKey})
    : _apiKey = apiKey ?? AppConfig.googlePlacesApiKey,
      _dio =
          dio ??
          createPlacesDio(apiKey: apiKey ?? AppConfig.googlePlacesApiKey);

  final Dio _dio;
  final String _apiKey;
  CancelToken? _nearbyToken;
  CancelToken? _textToken;

  final _memory = <String, (DateTime, PlacePage)>{};

  @override
  Future<PlacePage> searchNearby(NearbyQuery query) async {
    final includedType = query.placeCategory == null
        ? null
        : GoogleCategoryMapper.typeOf(query.placeCategory!);
    final groupText = query.categoryGroup == null
        ? null
        : GoogleCategoryMapper.textQueryForGroup(query.categoryGroup!);

    final key =
        'n:${query.origin.latitude.toStringAsFixed(3)},${query.origin.longitude.toStringAsFixed(3)}:${query.radiusMeters}:${query.placeCategory}:${query.categoryGroup}:${query.textQuery}:${query.openNow}';
    final cached = _cached(key);
    if (cached != null) return cached;

    final text = (query.textQuery ?? groupText ?? '').trim();
    if (text.isNotEmpty && includedType == null) {
      return searchByText(
        TextSearchQuery(
          query: text,
          origin: query.origin,
          radiusMeters: query.radiusMeters,
          openNow: query.openNow,
        ),
      );
    }

    _nearbyToken?.cancel();
    _nearbyToken = CancelToken();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/places:searchNearby',
        data: {
          'maxResultCount': 20,
          'rankPreference': 'DISTANCE',
          if (includedType != null) 'includedTypes': [includedType],
          if (query.openNow == true) 'openNow': true,
          'locationRestriction': {
            'circle': {
              'center': {
                'latitude': query.origin.latitude,
                'longitude': query.origin.longitude,
              },
              'radius': query.radiusMeters,
            },
          },
        },
        options: Options(
          headers: {'X-Goog-FieldMask': GooglePlaceMapper.listFieldMask},
        ),
        cancelToken: _nearbyToken,
      );
      final page = _page(response.data);
      _memory[key] = (DateTime.now(), page);
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
    final key =
        't:${query.query}:${query.origin.latitude.toStringAsFixed(3)},${query.origin.longitude.toStringAsFixed(3)}:${query.radiusMeters}:${query.openNow}';
    final cached = _cached(key);
    if (cached != null) return cached;

    _textToken?.cancel();
    _textToken = CancelToken();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/places:searchText',
        data: {
          'textQuery': query.query,
          'pageSize': 20,
          if (query.openNow == true) 'openNow': true,
          'locationBias': {
            'circle': {
              'center': {
                'latitude': query.origin.latitude,
                'longitude': query.origin.longitude,
              },
              'radius': query.radiusMeters,
            },
          },
        },
        options: Options(
          headers: {'X-Goog-FieldMask': GooglePlaceMapper.listFieldMask},
        ),
        cancelToken: _textToken,
      );
      final page = _page(response.data);
      _memory[key] = (DateTime.now(), page);
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
        '/v1/places/$providerId',
        options: Options(
          headers: {'X-Goog-FieldMask': GooglePlaceMapper.detailsFieldMask},
        ),
      );
      final json = response.data;
      if (json == null) throw const PlaceNotFoundException();
      return GooglePlaceMapper.fromJson(json, apiKey: _apiKey);
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

  PlacePage _page(Map<String, dynamic>? data) {
    final raw = data?['places'] as List? ?? const [];
    final places = raw
        .whereType<Map>()
        .map(
          (item) => GooglePlaceMapper.fromJson(
            Map<String, dynamic>.from(item),
            apiKey: _apiKey,
          ),
        )
        .whereType<Place>()
        .toList();
    return PlacePage(
      places: places,
      nextPageToken: data?['nextPageToken'] as String?,
    );
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
