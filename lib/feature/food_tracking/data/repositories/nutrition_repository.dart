import 'package:drift/drift.dart';
import 'package:fittnes_tracker/core/app_database.dart';

class NutritionRepository {
  final AppDatabase db;
  final MealDao mealDao;
  final FoodItemDao foodItemDao;

  NutritionRepository(this.db)
    : mealDao = MealDao(db),
      foodItemDao = FoodItemDao(db);

  // Get all meals for today
  Future<List<MealTableData>> getMealsForToday() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return await mealDao.getMealsForDate(today.toIso8601String());
  }

  // Add a food item to a specific meal category for today
  Future<void> addFoodToMeal(String category, FoodItemData foodItem) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await mealDao.getMealsForDate(today.toIso8601String());
    MealTableData? meal = meals.firstWhere(
      (m) => m.category == category,
      orElse: () => throw StateError('No meal found for category $category'),
    );
    if (meal == null) {
      final mealId = await mealDao.insertMeal(
        MealTableCompanion(
          date: Value(today.toIso8601String()),
          category: Value(category),
          foodItemId: Value(foodItem.id),
        ),
      );
      meal = await mealDao.getMealById(mealId);
    }
    await mealDao.addFoodToMeal(foodItem.id, meal!.id);
  }

  // Get all food items for a meal category for today
  Future<List<FoodItemData>> getFoodItemsForCategory(String category) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await mealDao.getMealsForDate(today.toIso8601String());
    MealTableData? meal;
    try {
      meal = meals.firstWhere((m) => m.category == category);
    } catch (e) {
      meal = null;
    }
    if (meal == null) return [];
    // Get food items linked to this meal
    // This requires a join between MealFoodTable and FoodItem
    // For simplicity, you can fetch all links and then fetch food items
    // You may want to add a method in MealDao for this
    // ...existing code...
    return [];
  }

  // Get user settings
  Future<UserSetting?> getUserSettings() async {
    return await db.userSettingsDao.getSettings();
  }

  Future<List<FoodItemData>> getNutritionHistory() async {
    return await foodItemDao.getAllFoodItems();
  }

  Future<int> removeFoodFromMeal(String category, FoodItemData foodItem) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await mealDao.getMealsForDate(today.toIso8601String());
    MealTableData? meal = meals.firstWhere(
      (m) => m.category == category,
      orElse: () => throw StateError('No meal found for category $category'),
    );
    if (meal == null) return 0;
    return await mealDao.deleteFoodFromMeal(foodItem.id, meal.id);
  }

  Future<int> setCalorieGoal(int goal) async {
    return await db.userSettingsDao.setCalorieGoal(goal);
  }

  Future getTodayNutrition() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return await mealDao.getMealsForDate(today.toIso8601String());
  }
}
