import 'package:find_nearby/ads/ad_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('debug ad units are Google samples, not production', () {
    expect(AdConfig.useTestAds(release: false), isTrue);
    expect(
      AdConfig.bannerAdUnitId(release: false),
      'ca-app-pub-3940256099942544/9214589741',
    );
    expect(
      AdConfig.interstitialAdUnitId(release: false),
      'ca-app-pub-3940256099942544/1033173712',
    );
    expect(
      AdConfig.nativeAdUnitId(release: false),
      'ca-app-pub-3940256099942544/2247696110',
    );
    for (final id in [
      AdConfig.bannerAdUnitId(release: false),
      AdConfig.interstitialAdUnitId(release: false),
      AdConfig.nativeAdUnitId(release: false),
    ]) {
      expect(id.contains('2570794718335687'), isFalse);
    }
  });

  test('release ad units are the production ids', () {
    expect(AdConfig.useTestAds(release: true), isFalse);
    expect(
      AdConfig.bannerAdUnitId(release: true),
      AdConfig.productionBannerAdUnitId,
    );
    expect(
      AdConfig.interstitialAdUnitId(release: true),
      AdConfig.productionInterstitialAdUnitId,
    );
    expect(
      AdConfig.nativeAdUnitId(release: true),
      AdConfig.productionNativeAdUnitId,
    );
    expect(AdConfig.appOpenEnabled, isFalse);
    expect(AdConfig.appOpenAdUnitId(release: true), isEmpty);
    expect(AdConfig.productionAppOpenAdUnitId, isNotEmpty);
  });

  test('ads stay off without an Android release configuration', () {
    expect(
      AdConfig.allowAds(
        release: false,
        platform: TargetPlatform.android,
        productionConfigured: true,
      ),
      isTrue,
    );
    expect(
      AdConfig.allowAds(
        release: true,
        platform: TargetPlatform.android,
        productionConfigured: true,
      ),
      isTrue,
    );
    expect(
      AdConfig.allowAds(
        release: true,
        platform: TargetPlatform.android,
        productionConfigured: false,
      ),
      isFalse,
    );
    expect(
      AdConfig.allowAds(
        release: true,
        platform: TargetPlatform.iOS,
        productionConfigured: true,
      ),
      isFalse,
    );
  });

  test('native slots appear after every sixth place and then stop', () {
    expect(
      AdPlacement.slots(5, includeAds: true).where((s) => s.isAd),
      isEmpty,
    );
    final six = AdPlacement.slots(6, includeAds: true);
    expect(six.length, 7);
    expect(six.last.isAd, isTrue);

    final long = AdPlacement.slots(40, includeAds: true);
    expect(long.where((slot) => slot.isAd).length, AdConfig.maxNativeAds);

    final off = AdPlacement.slots(12, includeAds: false);
    expect(off.where((slot) => slot.isAd), isEmpty);
    expect(off.length, 12);
  });

  test('interstitial waits for three detail exits and a gap', () {
    final start = DateTime(2026, 1, 1, 12);
    var count = 0;
    DateTime? last;

    InterstitialDecision step({required bool loaded, DateTime? now}) {
      final decision = InterstitialPolicy.onDetailsClosed(
        exitCount: count,
        lastShown: last,
        adLoaded: loaded,
        alreadyShowing: false,
        now: now ?? start,
      );
      count = decision.exitCount;
      if (decision.show) last = now ?? start;
      return decision;
    }

    expect(step(loaded: true).show, isFalse);
    expect(step(loaded: true).show, isFalse);
    expect(step(loaded: true).show, isTrue);
    expect(count, 0);

    expect(step(loaded: true).show, isFalse);
    expect(step(loaded: true).show, isFalse);
    expect(
      step(loaded: true, now: start.add(const Duration(minutes: 2))).show,
      isFalse,
    );
    expect(
      step(loaded: true, now: start.add(const Duration(minutes: 3))).show,
      isTrue,
    );

    count = 2;
    last = null;
    expect(step(loaded: false).show, isFalse);
    expect(count, 0);

    final blocked = InterstitialPolicy.onDetailsClosed(
      exitCount: 5,
      lastShown: null,
      adLoaded: true,
      alreadyShowing: true,
      now: start,
    );
    expect(blocked.show, isFalse);
    expect(blocked.exitCount, 5);
  });
}
