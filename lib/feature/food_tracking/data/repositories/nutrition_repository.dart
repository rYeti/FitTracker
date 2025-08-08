import 'package:drift/drift.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/feature/food_tracking/data/models/daily_nutrition_model.dart';
import 'package:dio/dio.dart';

class NutritionRepository {
  final AppDatabase db;
  final Dio _dio = Dio();

  NutritionRepository(this.db);

  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final resp = await _dio.get(
        'https://world.openfoodfacts.org/cgi/search.pl',
        queryParameters: {
          'search_terms': query,
          'search_simple': 1,
          'action': 'process',
          'json': 1,
          'page_size': 50,
          'fields': 'id,product_name,brands,nutriments',
        },
      );
      final data = resp.data;
      final products = (data is Map) ? data['products'] : null;
      if (products is List) {
        return products.whereType<Map>().cast<Map<String, dynamic>>().toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<MealTableData>> getMealsForToday() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return await db.mealDao.getMealsForDate(today); // fix
  }

  Future<void> addFoodToMeal(String category, FoodItemData foodItem) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await db.mealDao.getMealsForDate(today); // fix
    MealTableData? meal;
    try {
      meal = meals.firstWhere((m) => m.category == category);
    } catch (_) {
      meal = null;
    }
    if (meal == null) {
      final mealId = await db.mealDao.insertMeal(
        // fix
        MealTableCompanion(
          date: Value(today),
          category: Value(category),
          foodItemId: Value(foodItem.id),
        ),
      );
      meal = await db.mealDao.getMealById(mealId); // fix
    }
    await db.mealDao.addFoodToMeal(foodItem.id, meal!.id); // fix
  }

  Future<List<FoodItemData>> getFoodItemsForCategory(String category) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await db.mealDao.getMealsForDate(today); // fix
    MealTableData? meal;
    try {
      meal = meals.firstWhere((m) => m.category == category);
    } catch (_) {
      meal = null;
    }
    if (meal == null) return [];
    final mealFoodEntries = await db.mealDao.getFoodItemsForMeal(
      meal.id,
    ); // fix
    if (mealFoodEntries.isEmpty) return [];
    final foodItems = <FoodItemData>[];
    for (final entry in mealFoodEntries) {
      final food = await db.foodItemDao.getFoodItemById(
        entry.foodEntryId,
      ); // fix
      if (food != null) foodItems.add(food);
    }
    return foodItems;
  }

  Future<UserSetting?> getUserSettings() async {
    return await db.userSettingsDao.getSettings();
  }

  Future<List<FoodItemData>> getNutritionHistory() async {
    return await db.foodItemDao.getAllFoodItems(); // fix
  }

  Future<List<DailyNutrition>> getNutritionHistoryForToday() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await db.mealDao.getMealsForDate(today); // fix
    if (meals.isEmpty) return [];
    final dailyNutrition = DailyNutrition.empty(today);
    for (final meal in meals) {
      final foodItems = await db.mealDao.getFoodItemsForMeal(meal.id); // fix
      for (final entry in foodItems) {
        final foodItem = await db.foodItemDao.getFoodItemById(
          entry.foodEntryId,
        ); // fix
        if (foodItem != null) {
          dailyNutrition.totalCalories += foodItem.calories;
          dailyNutrition.totalProtein += foodItem.protein;
          dailyNutrition.totalCarbs += foodItem.carbs;
          dailyNutrition.totalFat += foodItem.fat;
          dailyNutrition.meals[meal.category]?.add(foodItem.name);
        }
      }
    }
    return [dailyNutrition];
  }

  Future<int> removeFoodFromMeal(String category, FoodItemData foodItem) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final meals = await db.mealDao.getMealsForDate(today); // fix
    final meal = meals.firstWhere(
      (m) => m.category == category,
      orElse: () => throw StateError('No meal found for category $category'),
    );
    return await db.mealDao.deleteFoodFromMeal(foodItem.id, meal.id); // fix
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
    return await db.mealDao.getMealsForDate(today); // fix
  }
}
