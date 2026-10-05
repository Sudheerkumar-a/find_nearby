/// Picks the best Google Places [types] entry for display — specific beats generic.
abstract final class GooglePlaceTypePriority {
  /// Lower number = higher priority (shown first).
  static const Map<String, int> priority = {
    'restaurant': 1,
    'cafe': 2,
    'bakery': 3,
    'fast_food_restaurant': 3,
    'ice_cream_shop': 3,
    'food_court': 3,
    'meal_takeaway': 3,
    'hospital': 4,
    'doctor': 5,
    'dentist': 5,
    'pharmacy': 6,
    'bank': 7,
    'atm': 8,
    'gas_station': 9,
    'supermarket': 10,
    'grocery_store': 10,
    'shopping_mall': 11,
    'department_store': 11,
    'store': 12,
    'clothing_store': 12,
    'electronics_store': 12,
    'school': 13,
    'university': 14,
    'library': 14,
    'hotel': 15,
    'lodging': 15,
    'car_repair': 16,
    'car_wash': 16,
    'beauty_salon': 17,
    'hair_salon': 17,
    'spa': 17,
    'gym': 18,
    'laundry': 19,
    'real_estate_agency': 20,
    'lawyer': 21,
    'accounting': 22,
    'insurance_agency': 23,
    'travel_agency': 24,
    'car_rental': 24,
    'airport': 25,
    'bus_station': 25,
    'train_station': 25,
    'post_office': 25,
    'movie_theater': 30,
    'museum': 30,
    'park': 30,
    'tourist_attraction': 30,
    'amusement_center': 30,
    'performing_arts_theater': 30,
    'finance': 45,
    'government_office': 45,
    'local_government_office': 45,
    'city_hall': 45,
    'service': 50,
    'point_of_interest': 90,
    'establishment': 100,
  };

  /// App category group labels keyed by Google type.
  static const Map<String, String> groups = {
    'restaurant': 'Food',
    'cafe': 'Food',
    'bakery': 'Food',
    'fast_food_restaurant': 'Food',
    'ice_cream_shop': 'Food',
    'food_court': 'Food',
    'meal_takeaway': 'Food',
    'hospital': 'Health',
    'doctor': 'Health',
    'dentist': 'Health',
    'pharmacy': 'Health',
    'bank': 'Services',
    'atm': 'Services',
    'gas_station': 'Services',
    'car_repair': 'Services',
    'car_wash': 'Services',
    'beauty_salon': 'Services',
    'hair_salon': 'Services',
    'spa': 'Services',
    'laundry': 'Services',
    'post_office': 'Services',
    'real_estate_agency': 'Services',
    'lawyer': 'Services',
    'accounting': 'Services',
    'insurance_agency': 'Services',
    'supermarket': 'Shopping',
    'grocery_store': 'Shopping',
    'shopping_mall': 'Shopping',
    'department_store': 'Shopping',
    'store': 'Shopping',
    'clothing_store': 'Shopping',
    'electronics_store': 'Shopping',
    'school': 'Education',
    'university': 'Education',
    'library': 'Education',
    'hotel': 'Travel',
    'lodging': 'Travel',
    'travel_agency': 'Travel',
    'car_rental': 'Travel',
    'airport': 'Travel',
    'bus_station': 'Travel',
    'train_station': 'Travel',
    'tourist_attraction': 'Travel',
    'movie_theater': 'Entertainment',
    'museum': 'Entertainment',
    'park': 'Entertainment',
    'amusement_center': 'Entertainment',
    'performing_arts_theater': 'Entertainment',
    'gym': 'Entertainment',
    'government_office': 'Services',
    'local_government_office': 'Services',
    'city_hall': 'Services',
    'finance': 'Services',
  };

  /// Generic Google types — only used when nothing more specific exists.
  static const genericTypes = {
    'point_of_interest',
    'establishment',
    'service',
  };

  static bool isGeneric(String type) => genericTypes.contains(type);

  static String getPrimaryCategory(List<dynamic>? types) {
    final type = primaryType(types);
    if (type == null) return '';
    return formatTypeDisplayName(type);
  }

  static String? primaryType(List<dynamic>? types) {
    if (types == null || types.isEmpty) return null;

    final normalized = types
        .whereType<String>()
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (normalized.isEmpty) return null;

    final specific = normalized.where((t) => !isGeneric(t)).toList();
    final candidates = specific.isNotEmpty ? specific : normalized;

    String? bestKnown;
    var bestRank = 1 << 30;
    for (final type in candidates) {
      final rank = priority[type];
      if (rank != null && rank < bestRank) {
        bestRank = rank;
        bestKnown = type;
      }
    }
    return bestKnown ?? candidates.first;
  }

  static String formatTypeDisplayName(String type) {
    return type
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }

  /// Returns `(group, primaryDisplay)` for [Place.category] / [Place.subcategory].
  static (String? group, String? display) resolve(List<String> types) {
    final primary = primaryType(types);
    if (primary == null) return (null, null);
    return (groups[primary], formatTypeDisplayName(primary));
  }
}
