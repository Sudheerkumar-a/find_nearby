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

  bar,
  mealDelivery,
  mealTakeaway,
  seafood,

  bicycleStore,
  bookStore,
  florist,
  furnitureStore,
  hardwareStore,
  homeGoodsStore,
  jewelryStore,
  liquorStore,
  petStore,
  shoeStore,
  generalStore,

  accounting,
  carDealer,
  carWash,
  electrician,
  insuranceAgency,
  lawyer,
  locksmith,
  movingCompany,
  realEstateAgency,
  storage,
  spa,

  physiotherapist,
  veterinaryCare,

  evCharging,
  campground,
  parking,
  rvPark,
  subwayStation,
  taxiStand,
  transitStation,

  amusementPark,
  aquarium,
  artGallery,
  bowlingAlley,
  casino,
  movieRental,
  nightClub,
  stadium,
  zoo,
  nationalPark,
  swimmingPool,

  cemetery,
  church,
  cityHall,
  courthouse,
  embassy,
  fireStation,
  funeralHome,
  hinduTemple,
  governmentOffice,
  mosque,
  police,
  synagogue,

  preschool,
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
      PlaceCategory.bar,
      PlaceCategory.mealDelivery,
      PlaceCategory.mealTakeaway,
      PlaceCategory.seafood,
    ],
    PlaceCategoryGroup.travel => const [
      PlaceCategory.hotel,
      PlaceCategory.touristAttraction,
      PlaceCategory.airport,
      PlaceCategory.busStation,
      PlaceCategory.trainStation,
      PlaceCategory.travelAgency,
      PlaceCategory.carRental,
      PlaceCategory.evCharging,
      PlaceCategory.campground,
      PlaceCategory.parking,
      PlaceCategory.rvPark,
      PlaceCategory.subwayStation,
      PlaceCategory.taxiStand,
      PlaceCategory.transitStation,
    ],
    PlaceCategoryGroup.education => const [
      PlaceCategory.school,
      PlaceCategory.college,
      PlaceCategory.university,
      PlaceCategory.trainingCenter,
      PlaceCategory.library,
      PlaceCategory.coachingCenter,
      PlaceCategory.preschool,
    ],
    PlaceCategoryGroup.health => const [
      PlaceCategory.hospital,
      PlaceCategory.clinic,
      PlaceCategory.pharmacy,
      PlaceCategory.dentalClinic,
      PlaceCategory.medicalCenter,
      PlaceCategory.physiotherapist,
      PlaceCategory.veterinaryCare,
    ],
    PlaceCategoryGroup.shopping => const [
      PlaceCategory.shoppingMall,
      PlaceCategory.supermarket,
      PlaceCategory.grocery,
      PlaceCategory.clothing,
      PlaceCategory.electronics,
      PlaceCategory.departmentStore,
      PlaceCategory.bicycleStore,
      PlaceCategory.bookStore,
      PlaceCategory.florist,
      PlaceCategory.furnitureStore,
      PlaceCategory.hardwareStore,
      PlaceCategory.homeGoodsStore,
      PlaceCategory.jewelryStore,
      PlaceCategory.liquorStore,
      PlaceCategory.petStore,
      PlaceCategory.shoeStore,
      PlaceCategory.generalStore,
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
      PlaceCategory.accounting,
      PlaceCategory.carDealer,
      PlaceCategory.carWash,
      PlaceCategory.electrician,
      PlaceCategory.insuranceAgency,
      PlaceCategory.lawyer,
      PlaceCategory.locksmith,
      PlaceCategory.movingCompany,
      PlaceCategory.realEstateAgency,
      PlaceCategory.storage,
      PlaceCategory.spa,
      PlaceCategory.cemetery,
      PlaceCategory.church,
      PlaceCategory.cityHall,
      PlaceCategory.courthouse,
      PlaceCategory.embassy,
      PlaceCategory.fireStation,
      PlaceCategory.funeralHome,
      PlaceCategory.hinduTemple,
      PlaceCategory.governmentOffice,
      PlaceCategory.mosque,
      PlaceCategory.police,
      PlaceCategory.synagogue,
    ],
    PlaceCategoryGroup.entertainment => const [
      PlaceCategory.cinema,
      PlaceCategory.park,
      PlaceCategory.museum,
      PlaceCategory.gaming,
      PlaceCategory.sportsCenter,
      PlaceCategory.theatre,
      PlaceCategory.amusementPark,
      PlaceCategory.aquarium,
      PlaceCategory.artGallery,
      PlaceCategory.bowlingAlley,
      PlaceCategory.casino,
      PlaceCategory.movieRental,
      PlaceCategory.nightClub,
      PlaceCategory.stadium,
      PlaceCategory.zoo,
      PlaceCategory.nationalPark,
      PlaceCategory.swimmingPool,
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
    PlaceCategory.bar => 'Bar',
    PlaceCategory.mealDelivery => 'Meal delivery',
    PlaceCategory.mealTakeaway => 'Meal takeaway',
    PlaceCategory.seafood => 'Sea food',
    PlaceCategory.bicycleStore => 'Bicycle store',
    PlaceCategory.bookStore => 'Book store',
    PlaceCategory.florist => 'Florist',
    PlaceCategory.furnitureStore => 'Furniture store',
    PlaceCategory.hardwareStore => 'Hardware store',
    PlaceCategory.homeGoodsStore => 'Home goods store',
    PlaceCategory.jewelryStore => 'Jewelry store',
    PlaceCategory.liquorStore => 'Liquor store',
    PlaceCategory.petStore => 'Pet store',
    PlaceCategory.shoeStore => 'Shoe store',
    PlaceCategory.generalStore => 'Store',
    PlaceCategory.accounting => 'Accounting',
    PlaceCategory.carDealer => 'Car dealer',
    PlaceCategory.carWash => 'Car wash',
    PlaceCategory.electrician => 'Electrician',
    PlaceCategory.insuranceAgency => 'Insurance agency',
    PlaceCategory.lawyer => 'Lawyer',
    PlaceCategory.locksmith => 'Locksmith',
    PlaceCategory.movingCompany => 'Moving company',
    PlaceCategory.realEstateAgency => 'Real estate agency',
    PlaceCategory.storage => 'Storage',
    PlaceCategory.spa => 'Spa',
    PlaceCategory.physiotherapist => 'Physiotherapist',
    PlaceCategory.veterinaryCare => 'Veterinary care',
    PlaceCategory.evCharging => 'EV Charging Station',
    PlaceCategory.campground => 'Campground',
    PlaceCategory.parking => 'Parking',
    PlaceCategory.rvPark => 'Rv park',
    PlaceCategory.subwayStation => 'Subway station',
    PlaceCategory.taxiStand => 'Taxi stand',
    PlaceCategory.transitStation => 'Transit station',
    PlaceCategory.amusementPark => 'Amusement park',
    PlaceCategory.aquarium => 'Aquarium',
    PlaceCategory.artGallery => 'Art Gallery',
    PlaceCategory.bowlingAlley => 'Bowling alley',
    PlaceCategory.casino => 'Casino',
    PlaceCategory.movieRental => 'Movie rental',
    PlaceCategory.nightClub => 'Night club',
    PlaceCategory.stadium => 'Stadium',
    PlaceCategory.zoo => 'Zoo',
    PlaceCategory.nationalPark => 'National park',
    PlaceCategory.swimmingPool => 'Swimming pool',
    PlaceCategory.cemetery => 'Cemetery',
    PlaceCategory.church => 'Church',
    PlaceCategory.cityHall => 'City hall',
    PlaceCategory.courthouse => 'Courthouse',
    PlaceCategory.embassy => 'Embassy',
    PlaceCategory.fireStation => 'Fire station',
    PlaceCategory.funeralHome => 'Funeral home',
    PlaceCategory.hinduTemple => 'Hindu temple',
    PlaceCategory.governmentOffice => 'Local government office',
    PlaceCategory.mosque => 'Mosque',
    PlaceCategory.police => 'Police',
    PlaceCategory.synagogue => 'Synagogue',
    PlaceCategory.preschool => 'Play group school',
  };

  PlaceCategoryGroup get group => switch (this) {
    PlaceCategory.restaurant ||
    PlaceCategory.cafe ||
    PlaceCategory.fastFood ||
    PlaceCategory.bakery ||
    PlaceCategory.dessert ||
    PlaceCategory.foodCourt ||
    PlaceCategory.bar ||
    PlaceCategory.mealDelivery ||
    PlaceCategory.mealTakeaway ||
    PlaceCategory.seafood => PlaceCategoryGroup.food,
    PlaceCategory.hotel ||
    PlaceCategory.touristAttraction ||
    PlaceCategory.airport ||
    PlaceCategory.busStation ||
    PlaceCategory.trainStation ||
    PlaceCategory.travelAgency ||
    PlaceCategory.carRental ||
    PlaceCategory.evCharging ||
    PlaceCategory.campground ||
    PlaceCategory.parking ||
    PlaceCategory.rvPark ||
    PlaceCategory.subwayStation ||
    PlaceCategory.taxiStand ||
    PlaceCategory.transitStation => PlaceCategoryGroup.travel,
    PlaceCategory.school ||
    PlaceCategory.college ||
    PlaceCategory.university ||
    PlaceCategory.trainingCenter ||
    PlaceCategory.library ||
    PlaceCategory.coachingCenter ||
    PlaceCategory.preschool => PlaceCategoryGroup.education,
    PlaceCategory.hospital ||
    PlaceCategory.clinic ||
    PlaceCategory.pharmacy ||
    PlaceCategory.dentalClinic ||
    PlaceCategory.medicalCenter ||
    PlaceCategory.physiotherapist ||
    PlaceCategory.veterinaryCare => PlaceCategoryGroup.health,
    PlaceCategory.shoppingMall ||
    PlaceCategory.supermarket ||
    PlaceCategory.grocery ||
    PlaceCategory.clothing ||
    PlaceCategory.electronics ||
    PlaceCategory.departmentStore ||
    PlaceCategory.bicycleStore ||
    PlaceCategory.bookStore ||
    PlaceCategory.florist ||
    PlaceCategory.furnitureStore ||
    PlaceCategory.hardwareStore ||
    PlaceCategory.homeGoodsStore ||
    PlaceCategory.jewelryStore ||
    PlaceCategory.liquorStore ||
    PlaceCategory.petStore ||
    PlaceCategory.shoeStore ||
    PlaceCategory.generalStore => PlaceCategoryGroup.shopping,
    PlaceCategory.bank ||
    PlaceCategory.atm ||
    PlaceCategory.salon ||
    PlaceCategory.carService ||
    PlaceCategory.repairShop ||
    PlaceCategory.laundry ||
    PlaceCategory.postOffice ||
    PlaceCategory.gasStation ||
    PlaceCategory.accounting ||
    PlaceCategory.carDealer ||
    PlaceCategory.carWash ||
    PlaceCategory.electrician ||
    PlaceCategory.insuranceAgency ||
    PlaceCategory.lawyer ||
    PlaceCategory.locksmith ||
    PlaceCategory.movingCompany ||
    PlaceCategory.realEstateAgency ||
    PlaceCategory.storage ||
    PlaceCategory.spa ||
    PlaceCategory.cemetery ||
    PlaceCategory.church ||
    PlaceCategory.cityHall ||
    PlaceCategory.courthouse ||
    PlaceCategory.embassy ||
    PlaceCategory.fireStation ||
    PlaceCategory.funeralHome ||
    PlaceCategory.hinduTemple ||
    PlaceCategory.governmentOffice ||
    PlaceCategory.mosque ||
    PlaceCategory.police ||
    PlaceCategory.synagogue => PlaceCategoryGroup.services,
    PlaceCategory.cinema ||
    PlaceCategory.park ||
    PlaceCategory.museum ||
    PlaceCategory.gaming ||
    PlaceCategory.sportsCenter ||
    PlaceCategory.theatre ||
    PlaceCategory.amusementPark ||
    PlaceCategory.aquarium ||
    PlaceCategory.artGallery ||
    PlaceCategory.bowlingAlley ||
    PlaceCategory.casino ||
    PlaceCategory.movieRental ||
    PlaceCategory.nightClub ||
    PlaceCategory.stadium ||
    PlaceCategory.zoo ||
    PlaceCategory.nationalPark ||
    PlaceCategory.swimmingPool => PlaceCategoryGroup.entertainment,
  };

  static PlaceCategory? fromName(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final value in PlaceCategory.values) {
      if (value.name == raw) return value;
    }
    return null;
  }
}
