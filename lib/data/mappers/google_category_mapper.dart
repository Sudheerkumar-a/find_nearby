import '../../domain/entities/place_category.dart';

/// Maps internal [PlaceCategory] → Google Places API (New) types.
/// Provider strings must stay here — never in UI.
abstract final class GoogleCategoryMapper {
  static const Map<PlaceCategory, String> types = {
    PlaceCategory.restaurant: 'restaurant',
    PlaceCategory.cafe: 'cafe',
    PlaceCategory.fastFood: 'fast_food_restaurant',
    PlaceCategory.bakery: 'bakery',
    PlaceCategory.dessert: 'ice_cream_shop',
    PlaceCategory.foodCourt: 'food_court',

    PlaceCategory.hotel: 'hotel',
    PlaceCategory.touristAttraction: 'tourist_attraction',
    PlaceCategory.airport: 'airport',
    PlaceCategory.busStation: 'bus_station',
    PlaceCategory.trainStation: 'train_station',
    PlaceCategory.travelAgency: 'travel_agency',
    PlaceCategory.carRental: 'car_rental',

    PlaceCategory.school: 'school',
    PlaceCategory.college: 'university',
    PlaceCategory.university: 'university',
    PlaceCategory.trainingCenter: 'school',
    PlaceCategory.library: 'library',
    PlaceCategory.coachingCenter: 'school',

    PlaceCategory.hospital: 'hospital',
    PlaceCategory.clinic: 'doctor',
    PlaceCategory.pharmacy: 'pharmacy',
    PlaceCategory.dentalClinic: 'dentist',
    PlaceCategory.medicalCenter: 'hospital',

    PlaceCategory.shoppingMall: 'shopping_mall',
    PlaceCategory.supermarket: 'supermarket',
    PlaceCategory.grocery: 'grocery_store',
    PlaceCategory.clothing: 'clothing_store',
    PlaceCategory.electronics: 'electronics_store',
    PlaceCategory.departmentStore: 'department_store',

    PlaceCategory.bank: 'bank',
    PlaceCategory.atm: 'atm',
    PlaceCategory.salon: 'hair_salon',
    PlaceCategory.carService: 'car_repair',
    PlaceCategory.repairShop: 'car_repair',
    PlaceCategory.laundry: 'laundry',
    PlaceCategory.postOffice: 'post_office',
    PlaceCategory.gasStation: 'gas_station',

    PlaceCategory.cinema: 'movie_theater',
    PlaceCategory.park: 'park',
    PlaceCategory.museum: 'museum',
    PlaceCategory.gaming: 'amusement_center',
    PlaceCategory.sportsCenter: 'gym',
    PlaceCategory.theatre: 'performing_arts_theater',
  };

  static String? typeOf(PlaceCategory category) => types[category];

  /// Broad group search when only a main category is selected.
  static String textQueryForGroup(PlaceCategoryGroup group) => group.label;

  static bool isValidGoogleType(String? value) {
    if (value == null || value.isEmpty) return false;
    return types.containsValue(value);
  }
}
