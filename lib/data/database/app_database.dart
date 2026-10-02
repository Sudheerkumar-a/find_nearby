import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class FavoritePlaces extends Table {
  TextColumn get id => text()();
  TextColumn get provider => text()();
  TextColumn get providerPlaceId => text()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get subcategory => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get website => text().nullable()();
  RealColumn get rating => real().nullable()();
  IntColumn get reviewCount => integer().nullable()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SearchHistoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get searchedAt => dateTime()();
}

class CategoryPreferences extends Table {
  TextColumn get categoryId => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  TextColumn get customName => text().nullable()();
  TextColumn get customQuery => text().nullable()();
  TextColumn get customIcon => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {categoryId};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Google place cache keyed by [googlePlaceId] (provider place id).
class CachedPlaces extends Table {
  TextColumn get googlePlaceId => text()();
  TextColumn get provider => text()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get website => text().nullable()();
  RealColumn get rating => real().nullable()();
  IntColumn get reviewCount => integer().nullable()();
  BoolColumn get isOpen => boolean().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get openingHours => text().nullable()();
  TextColumn get photos => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
  DateTimeColumn get detailsUpdated => dateTime().nullable()();
  DateTimeColumn get ratingUpdated => dateTime().nullable()();
  DateTimeColumn get openingStatusUpdated => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {googlePlaceId};
}

@DriftDatabase(
  tables: [
    FavoritePlaces,
    SearchHistoryEntries,
    CategoryPreferences,
    AppSettings,
    CachedPlaces,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cachedPlaces);
      }
      if (from < 3) {
        await m.addColumn(cachedPlaces, cachedPlaces.ratingUpdated);
        await m.addColumn(cachedPlaces, cachedPlaces.openingStatusUpdated);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'find_nearby');
  }
}
