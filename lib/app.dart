import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads/ad_service.dart';
import 'ads/interstitial_ad_manager.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/application/theme_provider.dart';

class FindNearbyApp extends ConsumerStatefulWidget {
  const FindNearbyApp({super.key});

  @override
  ConsumerState<FindNearbyApp> createState() => _FindNearbyAppState();
}

class _FindNearbyAppState extends ConsumerState<FindNearbyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AdService.instance.initialize();
      await InterstitialAdManager.instance.preload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
