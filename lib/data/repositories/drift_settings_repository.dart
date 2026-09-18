import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/place_search_mode.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';

final class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<ThemeMode> watchThemeMode() {
    return _watch(SettingKeys.themeMode).map(_parseTheme);
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    return _parseTheme(await _read(SettingKeys.themeMode));
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) {
    return _write(SettingKeys.themeMode, mode.name);
  }

  @override
  Future<double> getSearchRadiusMeters() async {
    final raw = await _read(SettingKeys.searchRadiusMeters);
    final parsed =
        double.tryParse(raw ?? '') ?? AppConstants.defaultRadiusMeters;
    return AppConstants.clampRadiusMeters(parsed);
  }

  @override
  Future<void> setSearchRadiusMeters(double meters) {
    return _write(
      SettingKeys.searchRadiusMeters,
      AppConstants.clampRadiusMeters(meters).toString(),
    );
  }

  @override
  Future<bool> getNotificationsEnabled() async {
    return (await _read(SettingKeys.notificationsEnabled)) == 'true';
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) {
    return _write(SettingKeys.notificationsEnabled, enabled.toString());
  }

  @override
  Stream<PlaceSearchMode> watchPlaceSearchMode() {
    return _watch(SettingKeys.placeSearchMode).map(_parsePlaceMode);
  }

  @override
  Future<PlaceSearchMode> getPlaceSearchMode() async {
    return _parsePlaceMode(await _read(SettingKeys.placeSearchMode));
  }

  @override
  Future<void> setPlaceSearchMode(PlaceSearchMode mode) {
    return _write(SettingKeys.placeSearchMode, mode.name);
  }

  Stream<String?> _watch(String key) {
    return (_db.select(_db.appSettings)..where((tbl) => tbl.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  Future<String?> _read(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> _write(String key, String value) {
    return _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  ThemeMode _parseTheme(String? raw) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  PlaceSearchMode _parsePlaceMode(String? raw) {
    if (raw == null || raw.isEmpty) return AppConfig.defaultPlaceSearchMode;
    return PlaceSearchModeX.parse(
      raw,
      fallback: AppConfig.defaultPlaceSearchMode,
    );
  }
}
