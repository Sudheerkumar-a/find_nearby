/// App-owned place categories. UI and filters use only these values.
enum PlaceCategory {
  restaurant,
  cafe,
  fastFood,
  bakery,
  dessert,
  foodCourt,

  hotel,
  touristAttraction,
  airport,
  busStation,
  trainStation,
  travelAgency,
  carRental,

  school,
  college,
  university,
  trainingCenter,
  library,
  coachingCenter,

  hospital,
  clinic,
  pharmacy,
  dentalClinic,
  medicalCenter,

  shoppingMall,
  supermarket,
  grocery,
  clothing,
  electronics,
  departmentStore,

  bank,
  atm,
  salon,
  carService,
  repairShop,
  laundry,
  postOffice,
  gasStation,

  cinema,
  park,
  museum,
  gaming,
  sportsCenter,
  theatre,
}

/// Top-level groups shown on Home / Explore.
enum PlaceCategoryGroup {
  food,
  travel,
  education,
  health,
  shopping,
  services,
  entertainment,
}

extension PlaceCategoryGroupX on PlaceCategoryGroup {
  String get id => name;

  String get label => switch (this) {
    PlaceCategoryGroup.food => 'Food',
    PlaceCategoryGroup.travel => 'Travel',
    PlaceCategoryGroup.education => 'Education',
    PlaceCategoryGroup.health => 'Health',
    PlaceCategoryGroup.shopping => 'Shopping',
    PlaceCategoryGroup.services => 'Services',
    PlaceCategoryGroup.entertainment => 'Entertainment',
  };

  List<PlaceCategory> get subcategories => switch (this) {
    PlaceCategoryGroup.food => const [
      PlaceCategory.restaurant,
      PlaceCategory.cafe,
      PlaceCategory.fastFood,
      PlaceCategory.bakery,
      PlaceCategory.dessert,
      PlaceCategory.foodCourt,
    ],
    PlaceCategoryGroup.travel => const [
      PlaceCategory.hotel,
      PlaceCategory.touristAttraction,
      PlaceCategory.airport,
      PlaceCategory.busStation,
      PlaceCategory.trainStation,
      PlaceCategory.travelAgency,
      PlaceCategory.carRental,
    ],
    PlaceCategoryGroup.education => const [
      PlaceCategory.school,
      PlaceCategory.college,
      PlaceCategory.university,
      PlaceCategory.trainingCenter,
      PlaceCategory.library,
      PlaceCategory.coachingCenter,
    ],
    PlaceCategoryGroup.health => const [
      PlaceCategory.hospital,
      PlaceCategory.clinic,
      PlaceCategory.pharmacy,
      PlaceCategory.dentalClinic,
      PlaceCategory.medicalCenter,
    ],
    PlaceCategoryGroup.shopping => const [
      PlaceCategory.shoppingMall,
      PlaceCategory.supermarket,
      PlaceCategory.grocery,
      PlaceCategory.clothing,
      PlaceCategory.electronics,
      PlaceCategory.departmentStore,
    ],
    PlaceCategoryGroup.services => const [
      PlaceCategory.bank,
      PlaceCategory.atm,
      PlaceCategory.salon,
      PlaceCategory.carService,
      PlaceCategory.repairShop,
      PlaceCategory.laundry,
      PlaceCategory.postOffice,
      PlaceCategory.gasStation,
    ],
    PlaceCategoryGroup.entertainment => const [
      PlaceCategory.cinema,
      PlaceCategory.park,
      PlaceCategory.museum,
      PlaceCategory.gaming,
      PlaceCategory.sportsCenter,
      PlaceCategory.theatre,
    ],
  };

  static PlaceCategoryGroup? fromId(String? id) {
    if (id == null) return null;
    for (final group in PlaceCategoryGroup.values) {
      if (group.id == id) return group;
    }
    return null;
  }
}

extension PlaceCategoryX on PlaceCategory {
  String get label => switch (this) {
    PlaceCategory.restaurant => 'Restaurants',
    PlaceCategory.cafe => 'Cafes',
    PlaceCategory.fastFood => 'Fast Food',
    PlaceCategory.bakery => 'Bakeries',
    PlaceCategory.dessert => 'Desserts',
    PlaceCategory.foodCourt => 'Food Courts',
    PlaceCategory.hotel => 'Hotels',
    PlaceCategory.touristAttraction => 'Tourist Attractions',
    PlaceCategory.airport => 'Airports',
    PlaceCategory.busStation => 'Bus Stations',
    PlaceCategory.trainStation => 'Train Stations',
    PlaceCategory.travelAgency => 'Travel Agencies',
    PlaceCategory.carRental => 'Car Rentals',
    PlaceCategory.school => 'Schools',
    PlaceCategory.college => 'Colleges',
    PlaceCategory.university => 'Universities',
    PlaceCategory.trainingCenter => 'Training Centers',
    PlaceCategory.library => 'Libraries',
    PlaceCategory.coachingCenter => 'Coaching Centers',
    PlaceCategory.hospital => 'Hospitals',
    PlaceCategory.clinic => 'Clinics',
    PlaceCategory.pharmacy => 'Pharmacies',
    PlaceCategory.dentalClinic => 'Dental Clinics',
    PlaceCategory.medicalCenter => 'Medical Centers',
    PlaceCategory.shoppingMall => 'Shopping Malls',
    PlaceCategory.supermarket => 'Supermarkets',
    PlaceCategory.grocery => 'Grocery',
    PlaceCategory.clothing => 'Clothing',
    PlaceCategory.electronics => 'Electronics',
    PlaceCategory.departmentStore => 'Department Stores',
    PlaceCategory.bank => 'Banks',
    PlaceCategory.atm => 'ATMs',
    PlaceCategory.salon => 'Salons',
    PlaceCategory.carService => 'Car Services',
    PlaceCategory.repairShop => 'Repair Shops',
    PlaceCategory.laundry => 'Laundry',
    PlaceCategory.postOffice => 'Post Offices',
    PlaceCategory.gasStation => 'Gas Station',
    PlaceCategory.cinema => 'Cinemas',
    PlaceCategory.park => 'Parks',
    PlaceCategory.museum => 'Museums',
    PlaceCategory.gaming => 'Gaming',
    PlaceCategory.sportsCenter => 'Sports Centers',
    PlaceCategory.theatre => 'Theatres',
  };

  PlaceCategoryGroup get group => switch (this) {
    PlaceCategory.restaurant ||
    PlaceCategory.cafe ||
    PlaceCategory.fastFood ||
    PlaceCategory.bakery ||
    PlaceCategory.dessert ||
    PlaceCategory.foodCourt => PlaceCategoryGroup.food,
    PlaceCategory.hotel ||
    PlaceCategory.touristAttraction ||
    PlaceCategory.airport ||
    PlaceCategory.busStation ||
    PlaceCategory.trainStation ||
    PlaceCategory.travelAgency ||
    PlaceCategory.carRental => PlaceCategoryGroup.travel,
    PlaceCategory.school ||
    PlaceCategory.college ||
    PlaceCategory.university ||
    PlaceCategory.trainingCenter ||
    PlaceCategory.library ||
    PlaceCategory.coachingCenter => PlaceCategoryGroup.education,
    PlaceCategory.hospital ||
    PlaceCategory.clinic ||
    PlaceCategory.pharmacy ||
    PlaceCategory.dentalClinic ||
    PlaceCategory.medicalCenter => PlaceCategoryGroup.health,
    PlaceCategory.shoppingMall ||
    PlaceCategory.supermarket ||
    PlaceCategory.grocery ||
    PlaceCategory.clothing ||
    PlaceCategory.electronics ||
    PlaceCategory.departmentStore => PlaceCategoryGroup.shopping,
    PlaceCategory.bank ||
    PlaceCategory.atm ||
    PlaceCategory.salon ||
    PlaceCategory.carService ||
    PlaceCategory.repairShop ||
    PlaceCategory.laundry ||
    PlaceCategory.postOffice ||
    PlaceCategory.gasStation => PlaceCategoryGroup.services,
    PlaceCategory.cinema ||
    PlaceCategory.park ||
    PlaceCategory.museum ||
    PlaceCategory.gaming ||
    PlaceCategory.sportsCenter ||
    PlaceCategory.theatre => PlaceCategoryGroup.entertainment,
  };

  static PlaceCategory? fromName(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final value in PlaceCategory.values) {
      if (value.name == raw) return value;
    }
    return null;
  }
}
