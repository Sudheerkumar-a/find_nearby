import '../../domain/entities/app_category.dart';
import '../../domain/entities/place_category.dart';

abstract final class CategoryCatalog {
  static const List<AppCategory> defaults = [
    AppCategory(
      id: 'food',
      name: 'Food',
      icon: 'restaurant',
      sortOrder: 0,
      group: PlaceCategoryGroup.food,
      subcategories: [
        AppSubcategory(
          id: 'restaurants',
          name: 'Restaurants',
          placeCategory: PlaceCategory.restaurant,
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'indian',
          name: 'Indian',
          searchQuery: 'Indian restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'chinese',
          name: 'Chinese',
          searchQuery: 'Chinese restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'arabic',
          name: 'Arabic',
          searchQuery: 'Arabic restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'italian',
          name: 'Italian',
          searchQuery: 'Italian restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'japanese',
          name: 'Japanese',
          searchQuery: 'Japanese restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'thai',
          name: 'Thai',
          searchQuery: 'Thai restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'lebanese',
          name: 'Lebanese',
          searchQuery: 'Lebanese restaurant',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'cafes',
          name: 'Cafes',
          placeCategory: PlaceCategory.cafe,
          icon: 'local_cafe',
        ),
        AppSubcategory(
          id: 'fast_food',
          name: 'Fast Food',
          placeCategory: PlaceCategory.fastFood,
          icon: 'fastfood',
        ),
        AppSubcategory(
          id: 'bakeries',
          name: 'Bakeries',
          placeCategory: PlaceCategory.bakery,
          icon: 'bakery_dining',
        ),
        AppSubcategory(
          id: 'desserts',
          name: 'Desserts',
          placeCategory: PlaceCategory.dessert,
          icon: 'icecream',
        ),
        AppSubcategory(
          id: 'food_courts',
          name: 'Food Courts',
          placeCategory: PlaceCategory.foodCourt,
          icon: 'lunch_dining',
        ),
        AppSubcategory(
          id: 'bar',
          name: 'Bar',
          placeCategory: PlaceCategory.bar,
          icon: 'local_bar',
        ),
        AppSubcategory(
          id: 'meal_delivery',
          name: 'Meal delivery',
          placeCategory: PlaceCategory.mealDelivery,
          icon: 'delivery_dining',
        ),
        AppSubcategory(
          id: 'meal_takeaway',
          name: 'Meal takeaway',
          placeCategory: PlaceCategory.mealTakeaway,
          icon: 'takeout_dining',
        ),
        AppSubcategory(
          id: 'seafood',
          name: 'Sea food',
          placeCategory: PlaceCategory.seafood,
          icon: 'set_meal',
        ),
        AppSubcategory(
          id: 'cloud_kitchen',
          name: 'Cloud Kitchen',
          searchQuery: 'cloud kitchen',
          icon: 'restaurant',
        ),
        AppSubcategory(
          id: 'street_food',
          name: 'Street food',
          searchQuery: 'street food',
          icon: 'ramen_dining',
        ),
      ],
    ),
    AppCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: 'movie',
      sortOrder: 1,
      group: PlaceCategoryGroup.entertainment,
      subcategories: [
        AppSubcategory(
          id: 'cinemas',
          name: 'Cinemas',
          placeCategory: PlaceCategory.cinema,
          icon: 'movie',
        ),
        AppSubcategory(
          id: 'parks',
          name: 'Parks',
          placeCategory: PlaceCategory.park,
          icon: 'park',
        ),
        AppSubcategory(
          id: 'museums',
          name: 'Museums',
          placeCategory: PlaceCategory.museum,
          icon: 'museum',
        ),
        AppSubcategory(
          id: 'gaming',
          name: 'Gaming',
          placeCategory: PlaceCategory.gaming,
          icon: 'sports_esports',
        ),
        AppSubcategory(
          id: 'sports',
          name: 'Sports Centers',
          placeCategory: PlaceCategory.sportsCenter,
          icon: 'sports_soccer',
        ),
        AppSubcategory(
          id: 'theatres',
          name: 'Theatres',
          placeCategory: PlaceCategory.theatre,
          icon: 'theater_comedy',
        ),
        AppSubcategory(
          id: 'amusement_park',
          name: 'Amusement park',
          placeCategory: PlaceCategory.amusementPark,
          icon: 'attractions',
        ),
        AppSubcategory(
          id: 'aquarium',
          name: 'Aquarium',
          placeCategory: PlaceCategory.aquarium,
          icon: 'water',
        ),
        AppSubcategory(
          id: 'art_gallery',
          name: 'Art Gallery',
          placeCategory: PlaceCategory.artGallery,
          icon: 'palette',
        ),
        AppSubcategory(
          id: 'bowling',
          name: 'Bowling alley',
          placeCategory: PlaceCategory.bowlingAlley,
          icon: 'sports_bowling',
        ),
        AppSubcategory(
          id: 'casino',
          name: 'Casino',
          placeCategory: PlaceCategory.casino,
          icon: 'casino',
        ),
        AppSubcategory(
          id: 'movie_rental',
          name: 'Movie rental',
          placeCategory: PlaceCategory.movieRental,
          icon: 'movie',
        ),
        AppSubcategory(
          id: 'night_club',
          name: 'Night club',
          placeCategory: PlaceCategory.nightClub,
          icon: 'nightlife',
        ),
        AppSubcategory(
          id: 'stadium',
          name: 'Stadium',
          placeCategory: PlaceCategory.stadium,
          icon: 'stadium',
        ),
        AppSubcategory(
          id: 'zoo',
          name: 'Zoo',
          placeCategory: PlaceCategory.zoo,
          icon: 'pets',
        ),
        AppSubcategory(
          id: 'national_park',
          name: 'National park',
          placeCategory: PlaceCategory.nationalPark,
          icon: 'park',
        ),
        AppSubcategory(
          id: 'swimming_pool',
          name: 'Swimming pool',
          placeCategory: PlaceCategory.swimmingPool,
          icon: 'pool',
        ),
        AppSubcategory(
          id: 'adventure_park',
          name: 'Adventure Park',
          searchQuery: 'adventure park',
          icon: 'hiking',
        ),
        AppSubcategory(
          id: 'live_show',
          name: 'Live show',
          searchQuery: 'live show',
          icon: 'theater_comedy',
        ),
      ],
    ),
    AppCategory(
      id: 'services',
      name: 'Services',
      icon: 'handyman',
      sortOrder: 2,
      group: PlaceCategoryGroup.services,
      subcategories: [
        AppSubcategory(
          id: 'banks',
          name: 'Banks',
          placeCategory: PlaceCategory.bank,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'atms',
          name: 'ATMs',
          placeCategory: PlaceCategory.atm,
          icon: 'atm',
        ),
        AppSubcategory(
          id: 'salons',
          name: 'Salons',
          placeCategory: PlaceCategory.salon,
          icon: 'content_cut',
        ),
        AppSubcategory(
          id: 'car_services',
          name: 'Car Services',
          placeCategory: PlaceCategory.carService,
          icon: 'car_repair',
        ),
        AppSubcategory(
          id: 'repair',
          name: 'Repair Shops',
          placeCategory: PlaceCategory.repairShop,
          icon: 'build',
        ),
        AppSubcategory(
          id: 'laundry',
          name: 'Laundry',
          placeCategory: PlaceCategory.laundry,
          icon: 'local_laundry_service',
        ),
        AppSubcategory(
          id: 'post_offices',
          name: 'Post Offices',
          placeCategory: PlaceCategory.postOffice,
          icon: 'local_post_office',
        ),
        AppSubcategory(
          id: 'gas',
          name: 'Gas Stations',
          placeCategory: PlaceCategory.gasStation,
          icon: 'local_gas_station',
        ),
        AppSubcategory(
          id: 'accounting',
          name: 'Accounting',
          placeCategory: PlaceCategory.accounting,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'car_dealer',
          name: 'Car dealer',
          placeCategory: PlaceCategory.carDealer,
          icon: 'directions_car',
        ),
        AppSubcategory(
          id: 'car_wash',
          name: 'Car wash',
          placeCategory: PlaceCategory.carWash,
          icon: 'local_car_wash',
        ),
        AppSubcategory(
          id: 'electrician',
          name: 'Electrician',
          placeCategory: PlaceCategory.electrician,
          icon: 'electrical_services',
        ),
        AppSubcategory(
          id: 'insurance',
          name: 'Insurance agency',
          placeCategory: PlaceCategory.insuranceAgency,
          icon: 'health_and_safety',
        ),
        AppSubcategory(
          id: 'lawyer',
          name: 'Lawyer',
          placeCategory: PlaceCategory.lawyer,
          icon: 'gavel',
        ),
        AppSubcategory(
          id: 'locksmith',
          name: 'Locksmith',
          placeCategory: PlaceCategory.locksmith,
          icon: 'lock',
        ),
        AppSubcategory(
          id: 'moving',
          name: 'Moving company',
          placeCategory: PlaceCategory.movingCompany,
          icon: 'local_shipping',
        ),
        AppSubcategory(
          id: 'real_estate',
          name: 'Real estate agency',
          placeCategory: PlaceCategory.realEstateAgency,
          icon: 'apartment',
        ),
        AppSubcategory(
          id: 'storage',
          name: 'Storage',
          placeCategory: PlaceCategory.storage,
          icon: 'warehouse',
        ),
        AppSubcategory(
          id: 'spa',
          name: 'Spa',
          placeCategory: PlaceCategory.spa,
          icon: 'spa',
        ),
        AppSubcategory(
          id: 'cemetery',
          name: 'Cemetery',
          placeCategory: PlaceCategory.cemetery,
          icon: 'church',
        ),
        AppSubcategory(
          id: 'church',
          name: 'Church',
          placeCategory: PlaceCategory.church,
          icon: 'church',
        ),
        AppSubcategory(
          id: 'city_hall',
          name: 'City hall',
          placeCategory: PlaceCategory.cityHall,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'courthouse',
          name: 'Courthouse',
          placeCategory: PlaceCategory.courthouse,
          icon: 'gavel',
        ),
        AppSubcategory(
          id: 'embassy',
          name: 'Embassy',
          placeCategory: PlaceCategory.embassy,
          icon: 'flag',
        ),
        AppSubcategory(
          id: 'fire_station',
          name: 'Fire station',
          placeCategory: PlaceCategory.fireStation,
          icon: 'local_fire_department',
        ),
        AppSubcategory(
          id: 'funeral_home',
          name: 'Funeral home',
          placeCategory: PlaceCategory.funeralHome,
          icon: 'church',
        ),
        AppSubcategory(
          id: 'hindu_temple',
          name: 'Hindu temple',
          placeCategory: PlaceCategory.hinduTemple,
          icon: 'temple_hindu',
        ),
        AppSubcategory(
          id: 'government_office',
          name: 'Local government office',
          placeCategory: PlaceCategory.governmentOffice,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'mosque',
          name: 'Mosque',
          placeCategory: PlaceCategory.mosque,
          icon: 'mosque',
        ),
        AppSubcategory(
          id: 'police',
          name: 'Police',
          placeCategory: PlaceCategory.police,
          icon: 'local_police',
        ),
        AppSubcategory(
          id: 'synagogue',
          name: 'Synagogue',
          placeCategory: PlaceCategory.synagogue,
          icon: 'synagogue',
        ),
        AppSubcategory(
          id: 'plumber',
          name: 'Plumber',
          searchQuery: 'plumber',
          icon: 'plumbing',
        ),
        AppSubcategory(
          id: 'painter',
          name: 'Painter',
          searchQuery: 'painter',
          icon: 'format_paint',
        ),
        AppSubcategory(
          id: 'roofing',
          name: 'Roofing contractor',
          searchQuery: 'roofing contractor',
          icon: 'roofing',
        ),
        AppSubcategory(
          id: 'printing',
          name: 'Printing & Photocopy Shop',
          searchQuery: 'printing photocopy',
          icon: 'print',
        ),
        AppSubcategory(
          id: 'factories',
          name: 'Factories',
          searchQuery: 'factory',
          icon: 'factory',
        ),
        AppSubcategory(
          id: 'it_park',
          name: 'IT Park',
          searchQuery: 'IT park',
          icon: 'computer',
        ),
        AppSubcategory(
          id: 'toilet',
          name: 'Toilet',
          searchQuery: 'public toilet',
          icon: 'wc',
        ),
      ],
    ),
    AppCategory(
      id: 'travel',
      name: 'Travel',
      icon: 'flight',
      sortOrder: 3,
      group: PlaceCategoryGroup.travel,
      subcategories: [
        AppSubcategory(
          id: 'hotels',
          name: 'Hotels',
          placeCategory: PlaceCategory.hotel,
          icon: 'hotel',
        ),
        AppSubcategory(
          id: 'attractions',
          name: 'Tourist Attractions',
          placeCategory: PlaceCategory.touristAttraction,
          icon: 'attractions',
        ),
        AppSubcategory(
          id: 'airports',
          name: 'Airports',
          placeCategory: PlaceCategory.airport,
          icon: 'local_airport',
        ),
        AppSubcategory(
          id: 'bus_stations',
          name: 'Bus Stations',
          placeCategory: PlaceCategory.busStation,
          icon: 'directions_bus',
        ),
        AppSubcategory(
          id: 'train_stations',
          name: 'Train Stations',
          placeCategory: PlaceCategory.trainStation,
          icon: 'train',
        ),
        AppSubcategory(
          id: 'travel_agencies',
          name: 'Travel Agencies',
          placeCategory: PlaceCategory.travelAgency,
          icon: 'card_travel',
        ),
        AppSubcategory(
          id: 'car_rentals',
          name: 'Car Rentals',
          placeCategory: PlaceCategory.carRental,
          icon: 'car_rental',
        ),
        AppSubcategory(
          id: 'ev_charging',
          name: 'EV Charging Station',
          placeCategory: PlaceCategory.evCharging,
          icon: 'ev_station',
        ),
        AppSubcategory(
          id: 'campground',
          name: 'Campground',
          placeCategory: PlaceCategory.campground,
          icon: 'cabin',
        ),
        AppSubcategory(
          id: 'parking',
          name: 'Parking',
          placeCategory: PlaceCategory.parking,
          icon: 'local_parking',
        ),
        AppSubcategory(
          id: 'rv_park',
          name: 'Rv park',
          placeCategory: PlaceCategory.rvPark,
          icon: 'airport_shuttle',
        ),
        AppSubcategory(
          id: 'subway',
          name: 'Subway station',
          placeCategory: PlaceCategory.subwayStation,
          icon: 'subway',
        ),
        AppSubcategory(
          id: 'taxi',
          name: 'Taxi stand',
          placeCategory: PlaceCategory.taxiStand,
          icon: 'local_taxi',
        ),
        AppSubcategory(
          id: 'transit',
          name: 'Transit station',
          placeCategory: PlaceCategory.transitStation,
          icon: 'directions_transit',
        ),
        AppSubcategory(
          id: 'pg',
          name: 'PG',
          searchQuery: 'paying guest',
          icon: 'hotel',
        ),
        AppSubcategory(
          id: 'hill_station',
          name: 'Hill station',
          searchQuery: 'hill station',
          icon: 'landscape',
        ),
        AppSubcategory(
          id: 'fort',
          name: 'Fort',
          searchQuery: 'fort',
          icon: 'castle',
        ),
      ],
    ),
    AppCategory(
      id: 'education',
      name: 'Education',
      icon: 'school',
      sortOrder: 4,
      group: PlaceCategoryGroup.education,
      subcategories: [
        AppSubcategory(
          id: 'schools',
          name: 'Schools',
          placeCategory: PlaceCategory.school,
          icon: 'school',
        ),
        AppSubcategory(
          id: 'colleges',
          name: 'Colleges',
          placeCategory: PlaceCategory.college,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'universities',
          name: 'Universities',
          placeCategory: PlaceCategory.university,
          icon: 'account_balance',
        ),
        AppSubcategory(
          id: 'training',
          name: 'Training Centers',
          placeCategory: PlaceCategory.trainingCenter,
          icon: 'model_training',
        ),
        AppSubcategory(
          id: 'libraries',
          name: 'Libraries',
          placeCategory: PlaceCategory.library,
          icon: 'local_library',
        ),
        AppSubcategory(
          id: 'coaching',
          name: 'Coaching Centers',
          placeCategory: PlaceCategory.coachingCenter,
          icon: 'menu_book',
        ),
        AppSubcategory(
          id: 'playgroup',
          name: 'Play group school',
          placeCategory: PlaceCategory.preschool,
          icon: 'child_care',
        ),
        AppSubcategory(
          id: 'dance_academy',
          name: 'Dance academy',
          searchQuery: 'dance academy',
          icon: 'music_note',
        ),
      ],
    ),
    AppCategory(
      id: 'health',
      name: 'Health',
      icon: 'health_and_safety',
      sortOrder: 5,
      group: PlaceCategoryGroup.health,
      subcategories: [
        AppSubcategory(
          id: 'hospitals',
          name: 'Hospitals',
          placeCategory: PlaceCategory.hospital,
          icon: 'local_hospital',
        ),
        AppSubcategory(
          id: 'clinics',
          name: 'Clinics',
          placeCategory: PlaceCategory.clinic,
          icon: 'medical_services',
        ),
        AppSubcategory(
          id: 'pharmacies',
          name: 'Pharmacies',
          placeCategory: PlaceCategory.pharmacy,
          icon: 'local_pharmacy',
        ),
        AppSubcategory(
          id: 'dental',
          name: 'Dental Clinics',
          placeCategory: PlaceCategory.dentalClinic,
          icon: 'medical_services',
        ),
        AppSubcategory(
          id: 'medical_centers',
          name: 'Medical Centers',
          placeCategory: PlaceCategory.medicalCenter,
          icon: 'local_hospital',
        ),
        AppSubcategory(
          id: 'physiotherapist',
          name: 'Physiotherapist',
          placeCategory: PlaceCategory.physiotherapist,
          icon: 'healing',
        ),
        AppSubcategory(
          id: 'veterinary',
          name: 'Veterinary care',
          placeCategory: PlaceCategory.veterinaryCare,
          icon: 'pets',
        ),
        AppSubcategory(
          id: 'vaccination',
          name: 'Vaccination centres',
          searchQuery: 'vaccination centre',
          icon: 'vaccines',
        ),
      ],
    ),
    AppCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: 'shopping_bag',
      sortOrder: 6,
      group: PlaceCategoryGroup.shopping,
      subcategories: [
        AppSubcategory(
          id: 'malls',
          name: 'Shopping Malls',
          placeCategory: PlaceCategory.shoppingMall,
          icon: 'local_mall',
        ),
        AppSubcategory(
          id: 'supermarkets',
          name: 'Supermarkets',
          placeCategory: PlaceCategory.supermarket,
          icon: 'local_grocery_store',
        ),
        AppSubcategory(
          id: 'grocery',
          name: 'Grocery',
          placeCategory: PlaceCategory.grocery,
          icon: 'shopping_cart',
        ),
        AppSubcategory(
          id: 'clothing',
          name: 'Clothing',
          placeCategory: PlaceCategory.clothing,
          icon: 'checkroom',
        ),
        AppSubcategory(
          id: 'electronics',
          name: 'Electronics',
          placeCategory: PlaceCategory.electronics,
          icon: 'devices',
        ),
        AppSubcategory(
          id: 'department',
          name: 'Department Stores',
          placeCategory: PlaceCategory.departmentStore,
          icon: 'store',
        ),
        AppSubcategory(
          id: 'bicycle_store',
          name: 'Bicycle store',
          placeCategory: PlaceCategory.bicycleStore,
          icon: 'directions_bike',
        ),
        AppSubcategory(
          id: 'book_store',
          name: 'Book store',
          placeCategory: PlaceCategory.bookStore,
          icon: 'menu_book',
        ),
        AppSubcategory(
          id: 'florist',
          name: 'Florist',
          placeCategory: PlaceCategory.florist,
          icon: 'local_florist',
        ),
        AppSubcategory(
          id: 'furniture',
          name: 'Furniture store',
          placeCategory: PlaceCategory.furnitureStore,
          icon: 'chair',
        ),
        AppSubcategory(
          id: 'hardware',
          name: 'Hardware store',
          placeCategory: PlaceCategory.hardwareStore,
          icon: 'hardware',
        ),
        AppSubcategory(
          id: 'home_goods',
          name: 'Home goods store',
          placeCategory: PlaceCategory.homeGoodsStore,
          icon: 'chair',
        ),
        AppSubcategory(
          id: 'jewelry',
          name: 'Jewelry store',
          placeCategory: PlaceCategory.jewelryStore,
          icon: 'diamond',
        ),
        AppSubcategory(
          id: 'liquor',
          name: 'Liquor store',
          placeCategory: PlaceCategory.liquorStore,
          icon: 'liquor',
        ),
        AppSubcategory(
          id: 'pet_store',
          name: 'Pet store',
          placeCategory: PlaceCategory.petStore,
          icon: 'pets',
        ),
        AppSubcategory(
          id: 'shoe_store',
          name: 'Shoe store',
          placeCategory: PlaceCategory.shoeStore,
          icon: 'checkroom',
        ),
        AppSubcategory(
          id: 'store',
          name: 'Store',
          placeCategory: PlaceCategory.generalStore,
          icon: 'store',
        ),
        AppSubcategory(
          id: 'fish_market',
          name: 'Fish market',
          searchQuery: 'fish market',
          icon: 'set_meal',
        ),
      ],
    ),
  ];

  /// Compact row on Home — specific shortcuts, not broad categories.
  static const homeQuickActionIds = [
    'restaurant',
    'gas',
    'bus',
    'hospital',
    'pharmacy',
    'atm',
    'cafe',
  ];

  static List<QuickAction> get homeQuickActions => [
    for (final id in homeQuickActionIds)
      quickActions.firstWhere((action) => action.id == id),
  ];

  static const List<QuickAction> quickActions = [
    QuickAction(
      id: 'hospital',
      label: 'Hospital',
      icon: 'local_hospital',
      placeCategory: PlaceCategory.hospital,
      categoryId: 'health',
      subcategoryId: 'hospitals',
    ),
    QuickAction(
      id: 'pharmacy',
      label: 'Pharmacy',
      icon: 'local_pharmacy',
      placeCategory: PlaceCategory.pharmacy,
      categoryId: 'health',
      subcategoryId: 'pharmacies',
    ),
    QuickAction(
      id: 'restaurant',
      label: 'Restaurant',
      icon: 'restaurant',
      placeCategory: PlaceCategory.restaurant,
      categoryId: 'food',
      subcategoryId: 'restaurants',
    ),
    QuickAction(
      id: 'atm',
      label: 'ATM',
      icon: 'atm',
      placeCategory: PlaceCategory.atm,
      categoryId: 'services',
      subcategoryId: 'atms',
    ),
    QuickAction(
      id: 'cafe',
      label: 'Cafe',
      icon: 'local_cafe',
      placeCategory: PlaceCategory.cafe,
      categoryId: 'food',
      subcategoryId: 'cafes',
    ),
    QuickAction(
      id: 'gas',
      label: 'Gas',
      icon: 'local_gas_station',
      placeCategory: PlaceCategory.gasStation,
      categoryId: 'services',
      subcategoryId: 'gas',
    ),
    QuickAction(
      id: 'bus',
      label: 'Bus',
      icon: 'directions_bus',
      placeCategory: PlaceCategory.busStation,
      categoryId: 'travel',
      subcategoryId: 'bus_stations',
    ),
    QuickAction(
      id: 'hotel',
      label: 'Hotel',
      icon: 'hotel',
      placeCategory: PlaceCategory.hotel,
      categoryId: 'travel',
      subcategoryId: 'hotels',
    ),
    QuickAction(
      id: 'supermarket',
      label: 'Market',
      icon: 'local_grocery_store',
      placeCategory: PlaceCategory.supermarket,
      categoryId: 'shopping',
      subcategoryId: 'supermarkets',
    ),
    QuickAction(
      id: 'car_service',
      label: 'Car Care',
      icon: 'car_repair',
      placeCategory: PlaceCategory.carService,
      categoryId: 'services',
      subcategoryId: 'car_services',
    ),
  ];

  static AppCategory? byId(String id, [List<AppCategory> catalog = defaults]) {
    for (final category in catalog) {
      if (category.id == id) return category;
    }
    return null;
  }

  static AppSubcategory? subcategoryById(
    String id, [
    List<AppCategory> catalog = defaults,
  ]) {
    for (final category in catalog) {
      for (final sub in category.subcategories) {
        if (sub.id == id) return sub;
      }
    }
    return null;
  }

  static List<AppCategory> applyPreferences({
    required List<AppCategory> defaults,
    required Map<String, ({bool enabled, int sortOrder})> prefs,
    required List<AppCategory> custom,
  }) {
    final merged = [
      ...defaults.map((c) {
        final pref = prefs[c.id];
        if (pref == null) return c;
        return c.copyWith(enabled: pref.enabled, sortOrder: pref.sortOrder);
      }),
      ...custom,
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return merged;
  }
}
