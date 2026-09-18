import 'package:flutter/material.dart';

import 'app_colors.dart';

/// FindNearby theme — GX Inspecta color + shape system.
abstract final class AppTheme {
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.teal,
      onPrimary: AppColors.onTeal,
      primaryContainer: isLight ? AppColors.tintMint : AppColors.tealDeep,
      onPrimaryContainer: isLight ? AppColors.tealDeep : AppColors.onTeal,
      secondary: AppColors.coral,
      onSecondary: AppColors.onCoral,
      secondaryContainer: isLight ? AppColors.tintPeach : AppColors.coralStrong,
      onSecondaryContainer: isLight ? AppColors.coralStrong : AppColors.onCoral,
      tertiary: AppColors.amber,
      onTertiary: AppColors.ink,
      tertiaryContainer: isLight
          ? const Color(0xFFFFF3E0)
          : const Color(0xFF5C4030),
      onTertiaryContainer: isLight ? AppColors.ink : AppColors.onTeal,
      error: const Color(0xFFC62828),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      surface: isLight ? AppColors.scaffold : const Color(0xFF12161E),
      onSurface: isLight ? AppColors.ink : const Color(0xFFE8EAED),
      onSurfaceVariant: isLight ? AppColors.inkMuted : const Color(0xFFADB5BD),
      outline: isLight ? const Color(0xFFD0D5DD) : const Color(0xFF3D4554),
      outlineVariant: isLight
          ? const Color(0xFFE4E7EC)
          : const Color(0xFF2A3344),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: AppColors.navy,
      onInverseSurface: AppColors.onNavy,
      inversePrimary: AppColors.teal,
      surfaceContainerLowest: isLight ? Colors.white : const Color(0xFF0E1218),
      surfaceContainerLow: isLight ? AppColors.card : const Color(0xFF181E28),
      surfaceContainer: isLight
          ? const Color(0xFFEEF1F4)
          : const Color(0xFF1C2434),
      surfaceContainerHigh: isLight
          ? const Color(0xFFE8ECF0)
          : const Color(0xFF242C3A),
      surfaceContainerHighest: isLight
          ? const Color(0xFFE2E7EC)
          : const Color(0xFF2A3344),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      visualDensity: VisualDensity.standard,
    );

    final shapeMd = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    );
    final shapeLg = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLg),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.onTeal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.onTeal),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onTeal,
        ),
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppColors.card : scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: shapeLg,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
        selectedColor: AppColors.coral,
        secondarySelectedColor: AppColors.coral,
        backgroundColor: isLight ? Colors.white : scheme.surfaceContainerHigh,
        labelStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        secondaryLabelStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onCoral,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        side: BorderSide.none,
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? Colors.white : scheme.surfaceContainerHighest,
        hintStyle: base.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navy,
        indicatorColor: AppColors.coral.withValues(alpha: 0.22),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? AppColors.coral
                : AppColors.onNavy.withValues(alpha: 0.78),
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return base.textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? AppColors.coral
                : AppColors.onNavy.withValues(alpha: 0.78),
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.onNavy,
          minimumSize: const Size(48, 48),
          shape: shapeMd,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.onNavy,
          elevation: 0,
          minimumSize: const Size(48, 48),
          shape: shapeMd,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.coral,
          side: const BorderSide(color: AppColors.coral),
          minimumSize: const Size(48, 48),
          shape: shapeMd,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tealDark,
          minimumSize: const Size(48, 48),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.coral,
        foregroundColor: AppColors.onCoral,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        shape: shapeMd,
        iconColor: AppColors.teal,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? AppColors.card : scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navy,
        contentTextStyle: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.onNavy,
        ),
        shape: shapeMd,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
