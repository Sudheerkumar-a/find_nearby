import '../../domain/entities/place_category.dart';

/// Maps internal [PlaceCategory] → Geoapify Places `categories` values.
/// Docs: https://apidocs.geoapify.com/docs/places/
///
/// Never send UI labels like `restaurants` — only hierarchical keys.
abstract final class GeoapifyCategoryMapper {
  static const Map<PlaceCategory, String> categories = {
    PlaceCategory.restaurant: 'catering.restaurant',
    PlaceCategory.cafe: 'catering.cafe',
    PlaceCategory.fastFood: 'catering.fast_food',
    PlaceCategory.bakery: 'commercial.food_and_drink.bakery',
    PlaceCategory.dessert: 'catering.cafe.dessert',
    PlaceCategory.foodCourt: 'catering.food_court',

    PlaceCategory.hotel: 'accommodation.hotel',
    PlaceCategory.touristAttraction: 'tourism.attraction',
    PlaceCategory.airport: 'airport',
    PlaceCategory.busStation: 'public_transport.bus',
    PlaceCategory.trainStation: 'public_transport.train',
    PlaceCategory.travelAgency: 'service.travel_agency',
    PlaceCategory.carRental: 'rental.car',

    PlaceCategory.school: 'education.school',
    PlaceCategory.college: 'education.college',
    PlaceCategory.university: 'education.university',
    PlaceCategory.trainingCenter: 'education.driving_school',
    PlaceCategory.library: 'education.library',
    PlaceCategory.coachingCenter: 'education.language_school',

    PlaceCategory.hospital: 'healthcare.hospital',
    PlaceCategory.clinic: 'healthcare.clinic_or_praxis',
    PlaceCategory.pharmacy: 'healthcare.pharmacy',
    PlaceCategory.dentalClinic: 'healthcare.dentist',
    PlaceCategory.medicalCenter: 'healthcare',

    PlaceCategory.shoppingMall: 'commercial.shopping_mall',
    PlaceCategory.supermarket: 'commercial.supermarket',
    PlaceCategory.grocery: 'commercial.convenience',
    PlaceCategory.clothing: 'commercial.clothing',
    // Geoapify documents this spelling (with a "k").
    PlaceCategory.electronics: 'commercial.elektronics',
    PlaceCategory.departmentStore: 'commercial.department_store',

    PlaceCategory.bank: 'service.financial.bank',
    PlaceCategory.atm: 'service.financial.atm',
    PlaceCategory.salon: 'service.beauty',
    PlaceCategory.carService: 'service.vehicle.repair.car',
    PlaceCategory.repairShop: 'service.vehicle.repair',
    PlaceCategory.laundry: 'service.cleaning.laundry',
    PlaceCategory.postOffice: 'service.post.office',
    PlaceCategory.gasStation: 'service.vehicle.fuel',

    PlaceCategory.cinema: 'entertainment.cinema',
    PlaceCategory.park: 'leisure.park',
    PlaceCategory.museum: 'entertainment.museum',
    PlaceCategory.gaming: 'entertainment.amusement_arcade',
    PlaceCategory.sportsCenter: 'sport.sports_centre',
    PlaceCategory.theatre: 'entertainment.culture.theatre',
  };

  static const Map<PlaceCategoryGroup, String> groupCategories = {
    PlaceCategoryGroup.food: 'catering',
    PlaceCategoryGroup.travel: 'tourism',
    PlaceCategoryGroup.education: 'education',
    PlaceCategoryGroup.health: 'healthcare',
    PlaceCategoryGroup.shopping: 'commercial',
    PlaceCategoryGroup.services: 'service',
    PlaceCategoryGroup.entertainment: 'entertainment',
  };

  static String? categoryOf(PlaceCategory category) => categories[category];

  static String? categoryForGroup(PlaceCategoryGroup group) =>
      groupCategories[group];

  /// True only for hierarchical Geoapify keys (must contain a dot, or known roots).
  static bool isValidGeoapifyCategory(String? value) {
    if (value == null || value.isEmpty) return false;
    if (value == 'restaurants' || value == 'restaurant') return false;
    if (categories.containsValue(value)) return true;
    if (groupCategories.containsValue(value)) return true;
    // Roots used in docs without a subcategory.
    const roots = {
      'airport',
      'healthcare',
      'sport',
      'tourism',
      'catering',
      'commercial',
      'service',
      'education',
      'entertainment',
    };
    return value.contains('.') || roots.contains(value);
  }
}
