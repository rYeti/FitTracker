import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(tables: [Users, FoodItem, Meals, Workouts, ExerciseEntries], daos: [FoodItemDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(): super(_openConnection());
  @override int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) {},
  );
}

class FoodItem extends Table {
  TextColumn get name => text()();
  IntColumn get calories => integer()();
  IntColumn get protein => integer()();
  IntColumn get carbs => integer()();
  IntColumn get fat => integer()();

  @override
  Set<Column> get primaryKey => {name};
}

@DriftAccessor(tables: [FoodItem])
class FoodItemDao extends DatabaseAccessor<AppDatabase> with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);
}

Future<void> saveFoodItem(FoodItemCompanion food) async {
  try {
    final db = AppDatabase();
    await db.foodItemDao.insertFoodItem(food);
  } catch (e) {
    throw Failure('Failed to save food item: ${e.toString()}');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'fittracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
