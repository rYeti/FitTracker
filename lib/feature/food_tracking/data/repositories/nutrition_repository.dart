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
    return await mealDao.getMealsForDate(today);
  }

  // Add a food item to a specific meal category for today
  Future<void> addFoodToMeal(String category, FoodItemData foodItem) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await mealDao.getMealsForDate(today);
    MealTableData? meal = meals.firstWhere(
      (m) => m.category == category,
      orElse: () => throw StateError('No meal found for category $category'),
    );
    if (meal == null) {
      final mealId = await mealDao.insertMeal(
        MealTableCompanion(
          date: Value(today),
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
    final meals = await mealDao.getMealsForDate(today);
    MealTableData? meal;
    try {
      meal = meals.firstWhere((m) => m.category == category);
    } catch (e) {
      meal = null;
    }
    if (meal == null) return [];
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
    final meals = await mealDao.getMealsForDate(today);
    MealTableData? meal = meals.firstWhere(
      (m) => m.category == category,
      orElse: () => throw StateError('No meal found for category $category'),
    );
    // meal will never be null here due to firstWhere with orElse
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
    return await mealDao.getMealsForDate(today);
  }
}
