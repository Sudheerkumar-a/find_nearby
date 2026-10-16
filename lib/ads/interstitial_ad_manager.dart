import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ad_service.dart';

/// One preloaded interstitial, shown only after place details is closed.
class InterstitialAdManager {
  InterstitialAdManager._();

  static final instance = InterstitialAdManager._();

  InterstitialAd? _ad;
  var _loading = false;
  var _showing = false;
  var _exitCount = 0;
  var _attempts = 0;
  DateTime? _lastShown;
  Timer? _retry;

  Future<void> preload() async {
    if (!AdService.instance.canRequestAds) return;
    if (_ad != null || _loading || _showing) return;
    final unitId = AdConfig.interstitialAdUnitId();
    if (unitId.isEmpty) return;
    _loading = true;
    try {
      await InterstitialAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _loading = false;
            _attempts = 0;
            _ad = ad;
          },
          onAdFailedToLoad: (error) {
            _loading = false;
            if (kDebugMode) {
              debugPrint('Interstitial failed (${error.code})');
            }
            _scheduleRetry();
          },
        ),
      );
    } catch (_) {
      _loading = false;
      _scheduleRetry();
    }
  }

  /// Navigation has already completed. If no ad is ready, nothing is shown.
  void onDetailsClosed() {
    if (!AdService.instance.canRequestAds) return;
    final decision = InterstitialPolicy.onDetailsClosed(
      exitCount: _exitCount,
      lastShown: _lastShown,
      adLoaded: _ad != null,
      alreadyShowing: _showing,
      now: DateTime.now(),
    );
    _exitCount = decision.exitCount;
    if (!decision.show) {
      if (_ad == null) preload();
      return;
    }
    final ad = _ad;
    if (ad == null) return;
    _ad = null;
    _showing = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _showing = false;
        _lastShown = DateTime.now();
        preload();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          debugPrint('Interstitial show failed (${error.code})');
        }
        ad.dispose();
        _showing = false;
        preload();
      },
    );
    ad.show();
  }

  void _scheduleRetry() {
    // ponytail: one retry after 30s; a backoff queue is the upgrade if fill stays low
    if (_attempts >= 1) return;
    _attempts++;
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 30), preload);
  }
}
