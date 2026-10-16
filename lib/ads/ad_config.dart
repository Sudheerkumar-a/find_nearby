import 'package:flutter/foundation.dart';

/// AdMob ids and placement rules.
///
/// Non-release builds always use Google's sample ad units. Release builds use
/// the production units. The Android app id is selected in Gradle
/// (`ADMOB_APP_ID`), not here, so a debug build cannot ship the production app id.
abstract final class AdConfig {
  static const productionAppId = 'ca-app-pub-2570794718335687~9630952083';
  static const productionBannerAdUnitId =
      'ca-app-pub-2570794718335687/3314624041';
  static const productionInterstitialAdUnitId =
      'ca-app-pub-2570794718335687/1734693929';
  static const productionNativeAdUnitId =
      'ca-app-pub-2570794718335687/8815107595';

  /// Stored for a later app-open implementation. Not requested while
  /// [appOpenEnabled] is false.
  static const productionAppOpenAdUnitId =
      'ca-app-pub-2570794718335687/9592082773';

  static const _testBanner = 'ca-app-pub-3940256099942544/9214589741';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';

  static const _productionPublisher = 'ca-app-pub-2570794718335687';

  /// App-open ads stay off until a foreground-only show path exists that
  /// skips the first launch.
  static const appOpenEnabled = false;

  /// Native ads are paused. Place lists stay organic until this is turned on.
  static const nativeAdsEnabled = false;

  /// One native ad after this many place cards, then again.
  static const nativeEvery = 6;

  /// ponytail: cap native ads per list; raise this if long result lists need more fill
  static const maxNativeAds = 3;

  static const interstitialEvery = 3;
  static const interstitialMinInterval = Duration(minutes: 3);

  static bool get productionConfigured =>
      productionAppId.isNotEmpty &&
      productionBannerAdUnitId.isNotEmpty &&
      productionInterstitialAdUnitId.isNotEmpty &&
      productionNativeAdUnitId.isNotEmpty;

  static bool useTestAds({bool? release}) => !(release ?? kReleaseMode);

  static bool adsEnabled({bool? release, TargetPlatform? platform}) {
    return allowAds(
      release: release ?? kReleaseMode,
      platform: platform ?? defaultTargetPlatform,
      productionConfigured: productionConfigured,
    );
  }

  /// Android only. Release with missing production ids serves nothing.
  static bool allowAds({
    required bool release,
    required TargetPlatform platform,
    required bool productionConfigured,
  }) {
    if (platform != TargetPlatform.android) return false;
    if (!release) return true;
    return productionConfigured;
  }

  static String bannerAdUnitId({bool? release}) =>
      _unit(_testBanner, productionBannerAdUnitId, release);

  static String interstitialAdUnitId({bool? release}) =>
      _unit(_testInterstitial, productionInterstitialAdUnitId, release);

  static String nativeAdUnitId({bool? release}) =>
      _unit(_testNative, productionNativeAdUnitId, release);

  static String appOpenAdUnitId({bool? release}) {
    if (!appOpenEnabled) return '';
    return _unit(_testAppOpen, productionAppOpenAdUnitId, release);
  }

  static String _unit(String testId, String productionId, bool? release) {
    if (useTestAds(release: release)) {
      assert(
        !testId.startsWith(_productionPublisher),
        'Test ad units must not use the production publisher id',
      );
      return testId;
    }
    return productionId;
  }
}

/// A row in a place list: either a place or a native ad slot.
class AdListSlot {
  const AdListSlot.place(this.placeIndex) : adIndex = -1;
  const AdListSlot.ad(this.adIndex) : placeIndex = -1;

  final int placeIndex;
  final int adIndex;

  bool get isAd => adIndex >= 0;
}

abstract final class AdPlacement {
  static List<AdListSlot> slots(int placeCount, {required bool includeAds}) {
    if (placeCount <= 0) return const [];
    final rows = <AdListSlot>[];
    var ads = 0;
    for (var i = 0; i < placeCount; i++) {
      rows.add(AdListSlot.place(i));
      final filled = (i + 1) % AdConfig.nativeEvery == 0;
      if (includeAds && filled && ads < AdConfig.maxNativeAds) {
        rows.add(AdListSlot.ad(ads));
        ads++;
      }
    }
    return rows;
  }
}

class InterstitialDecision {
  const InterstitialDecision({required this.show, required this.exitCount});

  final bool show;
  final int exitCount;
}

/// When a place-details visit has ended. Call, directions, and map pushes
/// do not call this.
abstract final class InterstitialPolicy {
  static InterstitialDecision onDetailsClosed({
    required int exitCount,
    required DateTime? lastShown,
    required bool adLoaded,
    required bool alreadyShowing,
    required DateTime now,
  }) {
    if (alreadyShowing) {
      return InterstitialDecision(show: false, exitCount: exitCount);
    }
    final next = exitCount + 1;
    final due = next >= AdConfig.interstitialEvery;
    final waited =
        lastShown == null ||
        now.difference(lastShown) >= AdConfig.interstitialMinInterval;
    if (!due || !waited) {
      return InterstitialDecision(show: false, exitCount: next);
    }
    if (!adLoaded) {
      return const InterstitialDecision(show: false, exitCount: 0);
    }
    return const InterstitialDecision(show: true, exitCount: 0);
  }
}
