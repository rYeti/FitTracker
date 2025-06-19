import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [FoodItem], daos: [FoodItemDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  if (kIsWeb) {
    // Use IndexedDB for web
    return LazyDatabase(() async {
      return WebDatabase('fittracker');
    });
  } else if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isWindows) {
    // Use NativeDatabase for other platforms
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'fittracker.sqlite'));
      return NativeDatabase(file);
    });
  } else {
    throw UnsupportedError('Unsupported platform');
  }
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
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);
}
