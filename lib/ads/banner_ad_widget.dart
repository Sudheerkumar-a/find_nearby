import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ad_service.dart';

/// Anchored adaptive banner. Occupies no space until an ad loads.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, this.safeBottom = false});

  /// Pad for the system navigation bar. Leave false when a bottom tab bar
  /// already sits under this widget.
  final bool safeBottom;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  final _released = <Ad>{};
  var _loaded = false;
  var _attempts = 0;
  var _generation = 0;
  int? _width;
  Timer? _retry;

  @override
  void initState() {
    super.initState();
    AdService.instance.ready.addListener(_onReady);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _onReady();
  }

  @override
  void dispose() {
    _retry?.cancel();
    AdService.instance.ready.removeListener(_onReady);
    final ad = _ad;
    _ad = null;
    if (ad != null) _discard(ad);
    super.dispose();
  }

  void _discard(Ad ad) {
    if (!_released.add(ad)) return;
    if (_ad == ad) _ad = null;
    ad.dispose();
  }

  void _onReady() {
    if (!mounted || !AdService.instance.canRequestAds) return;
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0 || width == _width) return;
    _width = width;
    _attempts = 0;
    _retry?.cancel();
    final generation = ++_generation;
    _releaseAd();
    _load(width, generation);
  }

  Future<void> _load(int width, int generation) async {
    final unitId = AdConfig.bannerAdUnitId();
    if (unitId.isEmpty) return;
    AnchoredAdaptiveBannerAdSize? size;
    try {
      // ignore: deprecated_member_use
      size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width,
      );
    } catch (_) {
      _scheduleRetry(width, generation);
      return;
    }
    if (!mounted || size == null || generation != _generation) return;
    final ad = BannerAd(
      adUnitId: unitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || generation != _generation || _ad != ad) {
            _discard(ad);
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) debugPrint('Banner failed (${error.code})');
          _discard(ad);
          _scheduleRetry(width, generation);
        },
      ),
    );
    if (generation != _generation) {
      _discard(ad);
      return;
    }
    _ad = ad;
    try {
      await ad.load();
    } catch (_) {
      _discard(ad);
      _scheduleRetry(width, generation);
    }
  }

  void _scheduleRetry(int width, int generation) {
    // ponytail: one retry after 30s; a backoff queue is the upgrade if fill stays low
    if (_attempts >= 1 || !mounted || generation != _generation) return;
    _attempts++;
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 30), () {
      if (mounted && generation == _generation && _ad == null) {
        _load(width, generation);
      }
    });
  }

  void _releaseAd() {
    final ad = _ad;
    _ad = null;
    _loaded = false;
    if (ad == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _discard(ad));
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (keyboardOpen || !_loaded || ad == null) return const SizedBox.shrink();
    final banner = SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
    if (!widget.safeBottom) return banner;
    return SafeArea(top: false, child: banner);
  }
}
