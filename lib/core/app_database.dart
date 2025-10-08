import 'package:drift/drift.dart';
import 'app_database_connection.dart'
    if (dart.library.io) 'app_database_connection_native.dart'
    if (dart.library.html) 'app_database_connection_web.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FoodItem,
    UserSettings,
    MealTable,
    MealFoodTable,
    SearchCacheTable,
    WeightRecord,
  ],
  daos: [
    FoodItemDao,
    UserSettingsDao,
    MealDao,
    SearchCacheDao,
    WeightRecordDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 7;

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
      if (from < 5) {
        // Create weight records table
        await m.createTable(weightRecord);
      }
      if (from < 6) {
        // For schema version 6, we add the new weight tracking columns
        // First create the table without attempting to copy data
        await m.addColumn(userSettings, userSettings.startingWeight);
        await m.addColumn(userSettings, userSettings.goalWeight);
      }
      if (from < 7) {
        // For schema version 7, we removed MealTemplates and MealTemplateItems tables
        // These are now handled via SharedPreferences
        try {
          await customStatement('DROP TABLE IF EXISTS meal_template_items');
          await customStatement('DROP TABLE IF EXISTS meal_templates');
          print('Successfully removed meal template tables');
        } catch (e) {
          print('Error removing meal template tables: $e');
          // Continue with migration even if this fails
        }
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
  // Weight tracking fields
  RealColumn get startingWeight => real().withDefault(const Constant(80.0))();
  RealColumn get goalWeight => real().withDefault(const Constant(70.0))();
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

// Note: Meal templates are now handled via SharedPreferences instead of database tables

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
    double? startingWeight,
    double? goalWeight,
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
          startingWeight: Value(startingWeight ?? 80.0),
          goalWeight: Value(goalWeight ?? 70.0),
        ),
      );
    } else {
      final updated = settings.copyWith(
        age: age ?? settings.age,
        heightCm: heightCm ?? settings.heightCm,
        sex: sex ?? settings.sex,
        activityLevel: activityLevel ?? settings.activityLevel,
        goalType: goalType ?? settings.goalType,
        startingWeight: startingWeight ?? settings.startingWeight,
        goalWeight: goalWeight ?? settings.goalWeight,
      );
      final success = await update(userSettings).replace(updated);
      return success ? 1 : 0;
    }
  }

  // Update weight goals specifically
  Future<int> updateWeightGoals({
    required double startingWeight,
    required double goalWeight,
  }) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(userSettings).insert(
        UserSettingsCompanion.insert(
          dailyCalorieGoal: const Value(2000),
          startingWeight: Value(startingWeight),
          goalWeight: Value(goalWeight),
        ),
      );
    } else {
      final updated = settings.copyWith(
        startingWeight: startingWeight,
        goalWeight: goalWeight,
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

// Weight tracking table definition
class WeightRecord extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weight => real()();
  TextColumn get note => text().nullable()();
}

// Weight tracking DAO
@DriftAccessor(tables: [WeightRecord])
class WeightRecordDao extends DatabaseAccessor<AppDatabase>
    with _$WeightRecordDaoMixin {
  WeightRecordDao(AppDatabase db) : super(db);

  // Get all weight records ordered by date
  Future<List<WeightRecordData>> getAllWeightRecords() =>
      (select(weightRecord)..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ])).get();

  // Watch all weight records (reactive stream)
  Stream<List<WeightRecordData>> watchAllWeightRecords() =>
      (select(weightRecord)..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ])).watch();

  // Get the most recent weight record
  Future<WeightRecordData?> getLatestWeightRecord() =>
      (select(weightRecord)
            ..orderBy([
              (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
            ])
            ..limit(1))
          .getSingleOrNull();

  // Add a new weight record
  Future<int> addWeightRecord(Insertable<WeightRecordData> record) =>
      into(weightRecord).insert(record);

  // Update an existing weight record
  Future<bool> updateWeightRecord(Insertable<WeightRecordData> record) =>
      update(weightRecord).replace(record);

  // Delete a weight record
  Future<int> deleteWeightRecord(int id) =>
      (delete(weightRecord)..where((tbl) => tbl.id.equals(id))).go();
}
