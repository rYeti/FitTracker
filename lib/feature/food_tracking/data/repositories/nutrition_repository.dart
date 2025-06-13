// lib/feature/food_tracking/data/repositories/nutrition_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_nutrition_model.dart';
import '../models/food_item_model.dart';
import '../models/user_settings_model.dart';

class NutritionRepository {
  static const String _dailyNutritionKey = 'daily_nutrition';

  // Get today's nutrition data
  Future<DailyNutrition> getTodayNutrition() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = _formatDate(DateTime.now());
    final String? nutritionJson = prefs.getString('$_dailyNutritionKey:$today');

    if (nutritionJson == null) {
      return DailyNutrition.empty(DateTime.now());
    }

    return DailyNutrition.fromJson(jsonDecode(nutritionJson));
  }

  // Save today's nutrition data
  Future<void> saveTodayNutrition(DailyNutrition nutrition) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = _formatDate(nutrition.date);
    await prefs.setString(
      '$_dailyNutritionKey:$today',
      jsonEncode(nutrition.toJson()),
    );
  }

  // Add a food item to a specific meal category
  Future<void> addFoodToMeal(String category, FoodItemModel foodItem) async {
    final nutrition = await getTodayNutrition();

    // Get current meals
    final meals = Map<String, List<String>>.from(nutrition.meals);

    // Make sure category exists
    if (!meals.containsKey(category)) {
      meals[category] = [];
    }

    // Add food item
    meals[category]!.add(jsonEncode(foodItem.toJson()));

    // Update totals
    final updatedNutrition = nutrition.copyWith(
      totalCalories: nutrition.totalCalories + foodItem.calories,
      totalProtein: nutrition.totalProtein + foodItem.protein,
      totalCarbs: nutrition.totalCarbs + foodItem.carbs,
      totalFat: nutrition.totalFat + foodItem.fat,
      meals: meals,
    );

    // Save updated nutrition
    await saveTodayNutrition(updatedNutrition);
  }

  // Get all food items for a meal category
  Future<List<FoodItemModel>> getFoodItemsForCategory(String category) async {
    final nutrition = await getTodayNutrition();

    if (!nutrition.meals.containsKey(category)) {
      return [];
    }

    return nutrition.meals[category]!
        .map((item) => FoodItemModel.fromJson(jsonDecode(item)))
        .toList();
  }

  // Get nutrition history for past days
  Future<List<DailyNutrition>> getNutritionHistory(int days) async {
    final prefs = await SharedPreferences.getInstance();
    final List<DailyNutrition> history = [];

    final now = DateTime.now();
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = _formatDate(date);
      final String? nutritionJson = prefs.getString(
        '$_dailyNutritionKey:$dateStr',
      );

      if (nutritionJson != null) {
        history.add(DailyNutrition.fromJson(jsonDecode(nutritionJson)));
      }
    }

    return history;
  }

  // Format date as YYYY-MM-DD for storage keys
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> removeFoodFromMeal(String category, FoodItemModel food) async {
    final nutrition = await getTodayNutrition();

    // Get current meals
    final meals = Map<String, List<String>>.from(nutrition.meals);

    // Check if category exists and has items
    if (!meals.containsKey(category) || meals[category]!.isEmpty) {
      return;
    }

    // Find and remove the food item
    final foodJson = jsonEncode(food.toJson());
    meals[category]!.remove(foodJson);

    // Update totals
    final updatedNutrition = nutrition.copyWith(
      totalCalories: nutrition.totalCalories - food.calories,
      totalProtein: nutrition.totalProtein - food.protein,
      totalCarbs: nutrition.totalCarbs - food.carbs,
      totalFat: nutrition.totalFat - food.fat,
      meals: meals,
    );

    // Save updated nutrition
    await saveTodayNutrition(updatedNutrition);
  }

  Future<UserSettings> getUserSettings() async {
    // Simulate fetching user settings from a backend or local storage
    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
    return UserSettings(dailyCalorieGoal: 2200); // Example dynamic value
  }
}
