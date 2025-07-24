import 'package:drift/drift.dart';
import 'app_database_connection.dart'
    if (dart.library.io) 'app_database_connection_native.dart'
    if (dart.library.html) 'app_database_connection_web.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [FoodItem, UserSettings, MealTable, MealFoodTable],
  daos: [FoodItemDao, UserSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 1;
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

@DriftAccessor(tables: [FoodItem])
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Stream<List<FoodItemData>> watchAllFoodItems() => select(foodItem).watch();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);
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
}

@DriftAccessor(tables: [MealTable, MealFoodTable, FoodItem])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(AppDatabase db) : super(db);

  Future<List<MealTableData>> getMealsForDate(String date) {
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
    return (delete(mealFoodTable)
      ..where((tbl) => tbl.mealId.equals(mealId) & tbl.foodEntryId.equals(foodId)))
        .go();
  }
}