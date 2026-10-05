import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart' as play;

import '../domain/update_gate_result.dart';

/// Google Play In-App Updates (Android only).
final class UpdateService {
  /// Silent check by default; set [performIfAllowed] to launch Play immediate update.
  Future<UpdateGateResult> checkForUpdate({
    bool performIfAllowed = false,
  }) async {
    if (!Platform.isAndroid) {
      return const UpdateGateResult(UpdateGateStatus.upToDate);
    }

    try {
      final info = await play.InAppUpdate.checkForUpdate();
      final storeUrl =
          'https://play.google.com/store/apps/details?id=${info.packageName}';

      final inProgress =
          info.updateAvailability ==
          play.UpdateAvailability.developerTriggeredUpdateInProgress;
      final available =
          info.updateAvailability == play.UpdateAvailability.updateAvailable;

      if (!inProgress && !available) {
        return const UpdateGateResult(UpdateGateStatus.upToDate);
      }

      if (performIfAllowed && info.immediateUpdateAllowed) {
        return _performImmediate(storeUrl);
      }

      return UpdateGateResult(
        UpdateGateStatus.blocked,
        storeUrl: storeUrl,
        message:
            'A new version is available on Google Play. Please update to continue.',
      );
    } on PlatformException catch (e) {
      // ponytail: ERROR_API_NOT_AVAILABLE on debug/sideload builds — allow through
      if (e.code == 'ERROR_API_NOT_AVAILABLE') {
        return const UpdateGateResult(UpdateGateStatus.upToDate);
      }
      return const UpdateGateResult(UpdateGateStatus.upToDate);
    } catch (_) {
      return const UpdateGateResult(UpdateGateStatus.upToDate);
    }
  }

  Future<UpdateGateResult> _performImmediate(String storeUrl) async {
    final result = await play.InAppUpdate.performImmediateUpdate();
    switch (result) {
      case play.AppUpdateResult.success:
        return const UpdateGateResult(UpdateGateStatus.updating);
      case play.AppUpdateResult.userDeniedUpdate:
      case play.AppUpdateResult.inAppUpdateFailed:
        return UpdateGateResult(
          UpdateGateStatus.blocked,
          storeUrl: storeUrl,
          message:
              'Update required. Please install the latest version from Google Play.',
        );
    }
  }
}
