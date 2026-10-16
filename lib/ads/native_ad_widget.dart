import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/theme/app_colors.dart';
import 'ad_config.dart';
import 'ad_service.dart';

/// Sponsored native ad. Visually separate from place cards, and empty until loaded.
class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _ad;
  final _released = <Ad>{};
  var _loaded = false;
  var _started = false;
  var _attempts = 0;
  Timer? _retry;

  @override
  void initState() {
    super.initState();
    AdService.instance.ready.addListener(_onReady);
    _onReady();
  }

  @override
  void dispose() {
    _retry?.cancel();
    AdService.instance.ready.removeListener(_onReady);
    final ad = _ad;
    _ad = null;
    if (ad != null) _drop(ad, '');
    super.dispose();
  }

  void _onReady() {
    if (!mounted || _started || !AdConfig.nativeAdsEnabled) return;
    if (!AdService.instance.canRequestAds) return;
    final unitId = AdConfig.nativeAdUnitId();
    if (unitId.isEmpty) return;
    _started = true;
    _load(unitId);
  }

  Future<void> _load(String unitId) async {
    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: AppColors.tintPeach,
        cornerRadius: 12,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.onTeal,
          backgroundColor: AppColors.teal,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.ink,
          size: 16,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.inkMuted,
          size: 12,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            _drop(ad, unitId);
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) debugPrint('Native ad failed (${error.code})');
          _drop(ad, unitId);
        },
      ),
    );
    _ad = ad;
    try {
      await ad.load();
    } catch (_) {
      _drop(ad, unitId);
    }
  }

  void _drop(Ad ad, String unitId) {
    if (!_released.add(ad)) return;
    if (_ad == ad) _ad = null;
    ad.dispose();
    if (unitId.isEmpty || !mounted) return;
    _scheduleRetry(unitId);
  }

  void _scheduleRetry(String unitId) {
    if (_attempts >= 1 || !mounted) return;
    _attempts++;
    _retry = Timer(const Duration(seconds: 30), () {
      if (mounted && _ad == null) _load(unitId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return Material(
      color: AppColors.tintPeach,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.amber, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Ad',
                      style: text.labelSmall?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sponsored',
                    style: text.labelMedium?.copyWith(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 350, child: AdWidget(ad: ad)),
          ],
        ),
      ),
    );
  }
}
