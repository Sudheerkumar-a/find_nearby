import 'package:flutter/material.dart';

import '../entities/place_search_mode.dart';

abstract class SettingsRepository {
  Stream<ThemeMode> watchThemeMode();

  Future<ThemeMode> getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  Future<double> getSearchRadiusMeters();

  Future<void> setSearchRadiusMeters(double meters);

  Future<bool> getNotificationsEnabled();

  Future<void> setNotificationsEnabled(bool enabled);

  Stream<PlaceSearchMode> watchPlaceSearchMode();

  Future<PlaceSearchMode> getPlaceSearchMode();

  Future<void> setPlaceSearchMode(PlaceSearchMode mode);
}
