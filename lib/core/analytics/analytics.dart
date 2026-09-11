/// No-op analytics so events can be wired later without UI changes.
abstract class Analytics {
  const Analytics();

  void track(String event, [Map<String, Object?> properties = const {}]);
}

abstract final class AnalyticsEvents {
  static const searchPerformed = 'search_performed';
  static const categorySelected = 'category_selected';
  static const placeOpened = 'place_opened';
  static const callClicked = 'call_clicked';
  static const directionsClicked = 'directions_clicked';
  static const websiteClicked = 'website_clicked';
  static const favoriteAdded = 'favorite_added';
  static const favoriteRemoved = 'favorite_removed';
}

final class NoOpAnalytics implements Analytics {
  const NoOpAnalytics();

  @override
  void track(String event, [Map<String, Object?> properties = const {}]) {}
}
