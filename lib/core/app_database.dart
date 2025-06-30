import 'package:drift/drift.dart';
import 'app_database_connection.dart'
    if (dart.library.io) 'app_database_connection_native.dart'
    if (dart.library.html) 'app_database_connection_web.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [FoodItem], daos: [FoodItemDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 1;
}

class FoodItem extends Table {
  TextColumn get name => text()();
  IntColumn get calories => integer()();
  IntColumn get protein => integer()();
  IntColumn get carbs => integer()();
  IntColumn get fat => integer()();

  @overridex
  Set<Column> get primaryKey => {name};
}

@DriftAccessor(tables: [FoodItem])
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);
}
