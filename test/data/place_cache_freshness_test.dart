import 'package:drift/native.dart';
import 'package:find_nearby/core/constants/cache_config.dart';
import 'package:find_nearby/data/database/app_database.dart';
import 'package:find_nearby/data/repositories/drift_place_cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final repo = DriftPlaceCacheRepository(
    AppDatabase(NativeDatabase.memory()),
  );

  CachedPlace row({
    DateTime? detailsUpdated,
    DateTime? ratingUpdated,
    DateTime? openingStatusUpdated,
  }) {
    return CachedPlace(
      googlePlaceId: 'abc',
      provider: 'googlePlaces',
      name: 'Test',
      latitude: 0,
      longitude: 0,
      address: null,
      phoneNumber: '+1',
      website: null,
      rating: 4.5,
      reviewCount: 10,
      isOpen: true,
      category: null,
      subcategory: null,
      openingHours: '["Mon 9-5"]',
      photos: null,
      description: null,
      lastUpdated: DateTime.now(),
      detailsUpdated: detailsUpdated,
      ratingUpdated: ratingUpdated,
      openingStatusUpdated: openingStatusUpdated,
    );
  }

  test('basic fresh within 15 days', () {
    final cached = row(
      detailsUpdated: DateTime.now().subtract(const Duration(days: 10)),
      ratingUpdated: DateTime.now(),
      openingStatusUpdated: DateTime.now(),
    );
    expect(repo.isBasicFresh(cached), isTrue);
  });

  test('basic stale after 15 days', () {
    final cached = row(
      detailsUpdated: DateTime.now().subtract(
        CacheConfig.placeBasicTtl + const Duration(hours: 1),
      ),
      ratingUpdated: DateTime.now(),
      openingStatusUpdated: DateTime.now(),
    );
    expect(repo.isBasicFresh(cached), isFalse);
    expect(repo.needsGoogleRefresh(cached), isTrue);
  });

  test('all groups stale after 15 days', () {
    final stale = DateTime.now().subtract(
      CacheConfig.placeCacheTtl + const Duration(hours: 1),
    );
    final cached = row(
      detailsUpdated: stale,
      ratingUpdated: stale,
      openingStatusUpdated: stale,
    );
    expect(repo.isFullyFresh(cached), isFalse);
    expect(repo.needsGoogleRefresh(cached), isTrue);
  });

  test('fully fresh when all timestamps within TTL', () {
    final now = DateTime.now();
    final cached = row(
      detailsUpdated: now,
      ratingUpdated: now,
      openingStatusUpdated: now,
    );
    expect(repo.isFullyFresh(cached), isTrue);
    expect(repo.needsGoogleRefresh(cached), isFalse);
  });
}
