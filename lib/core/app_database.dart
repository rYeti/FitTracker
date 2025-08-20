import 'package:drift/drift.dart';
import 'app_database_connection.dart'
    if (dart.library.io) 'app_database_connection_native.dart'
    if (dart.library.html) 'app_database_connection_web.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [FoodItem, UserSettings, MealTable, MealFoodTable, SearchCacheTable],
  daos: [FoodItemDao, UserSettingsDao, MealDao, SearchCacheDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(userSettings, userSettings.themeMode);
      }
      if (from < 3) {
        await m.createTable(searchCacheTable);
      }
      if (from < 4) {
        // Add newly introduced profile columns to userSettings
        await m.addColumn(userSettings, userSettings.age);
        await m.addColumn(userSettings, userSettings.heightCm);
        await m.addColumn(userSettings, userSettings.sex);
        await m.addColumn(userSettings, userSettings.activityLevel);
        await m.addColumn(userSettings, userSettings.goalType);
      }
    },
  );
}

class FoodItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get calories => integer()();
  IntColumn get protein => integer()();
  IntColumn get carbs => integer()();
  IntColumn get fat => integer()();
  IntColumn get gramm => integer().withDefault(const Constant(100))();
}

class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyCalorieGoal =>
      integer().withDefault(const Constant(2000))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  // Profile fields
  IntColumn get age => integer().withDefault(const Constant(30))();
  IntColumn get heightCm => integer().withDefault(const Constant(170))();
  TextColumn get sex => text().withDefault(const Constant('male'))();
  IntColumn get activityLevel => integer().withDefault(const Constant(1))();
  IntColumn get goalType => integer().withDefault(const Constant(1))();
}

class MealTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text()();
  IntColumn get foodItemId => integer()();
}

class MealFoodTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(MealTable, #id)();
  IntColumn get foodEntryId => integer().references(FoodItem, #id)();
}

// Persistent search cache table
class SearchCacheTable extends Table {
  TextColumn get query => text()();
  TextColumn get json => text()(); // raw json array of products
  IntColumn get ts => integer()(); // epoch millis
  @override
  Set<Column> get primaryKey => {query};
}

@DriftAccessor(tables: [FoodItem])
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  /// Stream the most recent food items, ordered by id descending, limited by [limit].
  Stream<List<FoodItemData>> watchRecentFoodItems(int limit) {
    return (select(foodItem)
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Stream<List<FoodItemData>> watchAllFoodItems() => select(foodItem).watch();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);

  Future<FoodItemData?> getFoodItemById(int id) async {
    return (select(foodItem)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}

@DriftAccessor(tables: [UserSettings])
class UserSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(AppDatabase db) : super(db);

  Future<UserSetting?> getSettings() => select(userSettings).getSingleOrNull();

  Future<int> setCalorieGoal(int goal) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(
        userSettings,
      ).insert(UserSettingsCompanion.insert(dailyCalorieGoal: Value(goal)));
    } else {
      final success = await update(
        userSettings,
      ).replace(settings.copyWith(dailyCalorieGoal: goal));
      return success ? 1 : 0;
    }
  }

  // Update profile fields (age, heightCm, sex, activityLevel, goalType)
  Future<int> updateProfile({
    int? age,
    int? heightCm,
    String? sex,
    int? activityLevel,
    int? goalType,
  }) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(userSettings).insert(
        UserSettingsCompanion.insert(
          dailyCalorieGoal: const Value(2000),
          age: Value(age ?? 30),
          heightCm: Value(heightCm ?? 170),
          sex: Value(sex ?? 'male'),
          activityLevel: Value(activityLevel ?? 1),
          goalType: Value(goalType ?? 1),
        ),
      );
    } else {
      final updated = settings.copyWith(
        age: age ?? settings.age,
        heightCm: heightCm ?? settings.heightCm,
        sex: sex ?? settings.sex,
        activityLevel: activityLevel ?? settings.activityLevel,
        goalType: goalType ?? settings.goalType,
      );
      final success = await update(userSettings).replace(updated);
      return success ? 1 : 0;
    }
  }

  Future<void> updateThemeMode(String mode) async {
    final settings = await getSettings();
    if (settings == null) {
      await into(
        userSettings,
      ).insert(UserSettingsCompanion.insert(themeMode: Value(mode)));
    } else {
      await (update(userSettings)..where(
        (tbl) => tbl.id.equals(settings.id),
      )).write(settings.copyWith(themeMode: mode));
    }
  }
}

@DriftAccessor(tables: [MealTable, MealFoodTable, FoodItem])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(AppDatabase db) : super(db);

  Future<List<MealTableData>> getMealsForDate(DateTime date) {
    return (select(mealTable)..where((tbl) => tbl.date.equals(date))).get();
  }

  Future<MealTableData?> getMealById(int id) {
    return (select(mealTable)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMeal(Insertable<MealTableData> meal) {
    return into(mealTable).insert(meal);
  }

  Future<int> deleteMeal(Insertable<MealTableData> meal) {
    return delete(mealTable).delete(meal);
  }

  Future<int> addFoodToMeal(int foodId, int mealId) {
    return into(mealFoodTable).insert(
      MealFoodTableCompanion.insert(mealId: mealId, foodEntryId: foodId),
    );
  }

  Future<List<MealFoodTableData>> getFoodItemsForMeal(int mealId) {
    return (select(mealFoodTable)
      ..where((tbl) => tbl.mealId.equals(mealId))).get();
  }

  Future<int> deleteFoodFromMeal(int foodId, int mealId) {
    return (delete(mealFoodTable)..where(
      (tbl) => tbl.mealId.equals(mealId) & tbl.foodEntryId.equals(foodId),
    )).go();
  }
}

@DriftAccessor(tables: [SearchCacheTable])
class SearchCacheDao extends DatabaseAccessor<AppDatabase>
    with _$SearchCacheDaoMixin {
  SearchCacheDao(AppDatabase db) : super(db);

  Future<void> upsert(String q, String jsonData, int ts) async {
    await into(searchCacheTable).insertOnConflictUpdate(
      SearchCacheTableCompanion(
        query: Value(q),
        json: Value(jsonData),
        ts: Value(ts),
      ),
    );
  }

  Future<List<SearchCacheTableData>> getAll() => select(searchCacheTable).get();

  Future<void> deleteByQuery(String q) async {
    await (delete(searchCacheTable)..where((tbl) => tbl.query.equals(q))).go();
  }

  Future<void> deleteOlderThan(int cutoffTs) async {
    await (delete(searchCacheTable)
      ..where((tbl) => tbl.ts.isSmallerThanValue(cutoffTs))).go();
  }
}
