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
    PlaceCategory.bar: 'catering.bar',
    PlaceCategory.mealDelivery: 'catering.restaurant',
    PlaceCategory.mealTakeaway: 'catering.restaurant',
    PlaceCategory.seafood: 'catering.restaurant.seafood',

    PlaceCategory.hotel: 'accommodation.hotel',
    PlaceCategory.touristAttraction: 'tourism.attraction',
    PlaceCategory.airport: 'airport',
    PlaceCategory.busStation: 'public_transport.bus',
    PlaceCategory.trainStation: 'public_transport.train',
    PlaceCategory.travelAgency: 'service.travel_agency',
    PlaceCategory.carRental: 'rental.car',
    PlaceCategory.evCharging: 'service.vehicle.charging_station',
    PlaceCategory.campground: 'camping.camp_site',
    PlaceCategory.parking: 'parking.cars',
    PlaceCategory.rvPark: 'camping.caravan_site',
    PlaceCategory.subwayStation: 'public_transport.subway',
    PlaceCategory.taxiStand: 'service.taxi',
    PlaceCategory.transitStation: 'public_transport.platform',

    PlaceCategory.school: 'education.school',
    PlaceCategory.college: 'education.college',
    PlaceCategory.university: 'education.university',
    PlaceCategory.trainingCenter: 'education.driving_school',
    PlaceCategory.library: 'education.library',
    PlaceCategory.coachingCenter: 'education.language_school',
    PlaceCategory.preschool: 'childcare.kindergarten',

    PlaceCategory.hospital: 'healthcare.hospital',
    PlaceCategory.clinic: 'healthcare.clinic_or_praxis',
    PlaceCategory.pharmacy: 'healthcare.pharmacy',
    PlaceCategory.dentalClinic: 'healthcare.dentist',
    PlaceCategory.medicalCenter: 'healthcare',
    // ponytail: no physiotherapy key; clinic is the parent until Geoapify adds one.
    PlaceCategory.physiotherapist: 'healthcare.clinic_or_praxis',
    PlaceCategory.veterinaryCare: 'pet.veterinary',

    PlaceCategory.shoppingMall: 'commercial.shopping_mall',
    PlaceCategory.supermarket: 'commercial.supermarket',
    PlaceCategory.grocery: 'commercial.convenience',
    PlaceCategory.clothing: 'commercial.clothing',
    // Geoapify documents this spelling (with a "k").
    PlaceCategory.electronics: 'commercial.elektronics',
    PlaceCategory.departmentStore: 'commercial.department_store',
    PlaceCategory.bicycleStore: 'commercial.outdoor_and_sport.bicycle',
    PlaceCategory.bookStore: 'commercial.books',
    PlaceCategory.florist: 'commercial.florist',
    PlaceCategory.furnitureStore: 'commercial.furniture_and_interior',
    PlaceCategory.hardwareStore:
        'commercial.houseware_and_hardware.hardware_and_tools',
    PlaceCategory.homeGoodsStore: 'commercial.houseware_and_hardware',
    PlaceCategory.jewelryStore: 'commercial.jewelry',
    PlaceCategory.liquorStore: 'commercial.food_and_drink.drinks',
    PlaceCategory.petStore: 'commercial.pet',
    PlaceCategory.shoeStore: 'commercial.clothing.shoes',
    PlaceCategory.generalStore: 'commercial',

    PlaceCategory.bank: 'service.financial.bank',
    PlaceCategory.atm: 'service.financial.atm',
    PlaceCategory.salon: 'service.beauty',
    PlaceCategory.carService: 'service.vehicle.repair.car',
    PlaceCategory.repairShop: 'service.vehicle.repair',
    PlaceCategory.laundry: 'service.cleaning.laundry',
    PlaceCategory.postOffice: 'service.post.office',
    PlaceCategory.gasStation: 'service.vehicle.fuel',
    PlaceCategory.accounting: 'office.accountant',
    PlaceCategory.carDealer: 'commercial.vehicle',
    PlaceCategory.carWash: 'service.vehicle.car_wash',
    PlaceCategory.electrician: 'service.electrician',
    PlaceCategory.insuranceAgency: 'office.insurance',
    PlaceCategory.lawyer: 'office.lawyer',
    PlaceCategory.locksmith: 'service.locksmith',
    PlaceCategory.movingCompany: 'office.logistics',
    PlaceCategory.realEstateAgency: 'office.estate_agent',
    PlaceCategory.storage: 'rental.storage',
    PlaceCategory.spa: 'service.beauty.spa',
    PlaceCategory.cemetery: 'memorial.cemetery',
    PlaceCategory.church: 'tourism.sights.place_of_worship.church',
    PlaceCategory.cityHall: 'tourism.sights.city_hall',
    PlaceCategory.courthouse: 'office.government.legislative',
    PlaceCategory.embassy: 'office.government.embassy',
    PlaceCategory.fireStation: 'service.fire_station',
    PlaceCategory.funeralHome: 'service.funeral_directors',
    PlaceCategory.hinduTemple: 'tourism.sights.place_of_worship.temple',
    PlaceCategory.governmentOffice: 'office.government',
    PlaceCategory.mosque: 'tourism.sights.place_of_worship.mosque',
    PlaceCategory.police: 'service.police',
    PlaceCategory.synagogue: 'tourism.sights.place_of_worship.synagogue',

    PlaceCategory.cinema: 'entertainment.cinema',
    PlaceCategory.park: 'leisure.park',
    PlaceCategory.museum: 'entertainment.museum',
    PlaceCategory.gaming: 'entertainment.amusement_arcade',
    PlaceCategory.sportsCenter: 'sport.sports_centre',
    PlaceCategory.theatre: 'entertainment.culture.theatre',
    PlaceCategory.amusementPark: 'entertainment.theme_park',
    PlaceCategory.aquarium: 'entertainment.aquarium',
    PlaceCategory.artGallery: 'entertainment.culture.gallery',
    PlaceCategory.bowlingAlley: 'entertainment.bowling_alley',
    PlaceCategory.casino: 'adult.casino',
    PlaceCategory.movieRental: 'commercial.video_and_music',
    PlaceCategory.nightClub: 'adult.nightclub',
    PlaceCategory.stadium: 'sport.stadium',
    PlaceCategory.zoo: 'entertainment.zoo',
    PlaceCategory.nationalPark: 'leisure.park.nature_reserve',
    PlaceCategory.swimmingPool: 'sport.swimming_pool',
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
