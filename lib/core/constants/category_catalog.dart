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
      ],
    ),
    AppCategory(
      id: 'travel',
      name: 'Travel',
      icon: 'flight',
      sortOrder: 1,
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
      ],
    ),
    AppCategory(
      id: 'education',
      name: 'Education',
      icon: 'school',
      sortOrder: 2,
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
      ],
    ),
    AppCategory(
      id: 'health',
      name: 'Health',
      icon: 'health_and_safety',
      sortOrder: 3,
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
      ],
    ),
    AppCategory(
      id: 'shopping',
      name: 'Shopping',
      icon: 'shopping_bag',
      sortOrder: 4,
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
      ],
    ),
    AppCategory(
      id: 'services',
      name: 'Services',
      icon: 'handyman',
      sortOrder: 5,
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
      ],
    ),
    AppCategory(
      id: 'entertainment',
      name: 'Entertainment',
      icon: 'movie',
      sortOrder: 6,
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
      ],
    ),
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
      label: 'Food',
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
