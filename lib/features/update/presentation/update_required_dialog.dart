import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/device_actions.dart';

/// Modal shown when Play immediate update cannot run (denied / failed).
class UpdateRequiredDialog extends StatelessWidget {
  const UpdateRequiredDialog({
    super.key,
    required this.storeUrl,
    this.message,
    this.onRetry,
  });

  final String storeUrl;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Icon(
                Icons.system_update_alt_rounded,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Update required',
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message ??
                  'A new version of ${AppConstants.appName} is required. Please update from Google Play.',
              style: text.bodyMedium?.copyWith(color: AppColors.inkMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null) ...[
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
              const SizedBox(height: 8),
            ],
            FilledButton.icon(
              onPressed: () => DeviceActions.website(storeUrl),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Update now'),
            ),
          ],
        ),
      ),
    );
  }
}
