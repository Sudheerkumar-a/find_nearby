import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

/// Consent, then a single Mobile Ads start. Ads stay off if this never finishes.
class AdService {
  AdService._();

  static final instance = AdService._();

  final ready = ValueNotifier<bool>(false);
  final privacyOptionsRequired = ValueNotifier<bool>(false);

  Future<void>? _init;

  bool get canRequestAds => ready.value;

  Future<void> initialize() {
    return _init ??= _initialize();
  }

  Future<void> _initialize() async {
    if (!AdConfig.adsEnabled()) return;
    try {
      await _requestConsent();
      final allowed = await ConsentInformation.instance.canRequestAds();
      final privacy = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      privacyOptionsRequired.value =
          privacy == PrivacyOptionsRequirementStatus.required;
      if (!allowed) return;
      await MobileAds.instance.initialize();
      ready.value = true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Ads unavailable (${error.runtimeType})');
      }
    }
  }

  Future<void> _requestConsent() {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null && kDebugMode) {
            debugPrint('Consent form error (${error.errorCode})');
          }
        });
        if (!done.isCompleted) done.complete();
      },
      (error) {
        if (kDebugMode) {
          debugPrint('Consent info error (${error.errorCode})');
        }
        if (!done.isCompleted) done.complete();
      },
    );
    return done.future;
  }

  Future<void> showPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null && kDebugMode) {
        debugPrint('Privacy options error (${error.errorCode})');
      }
    });
  }
}
