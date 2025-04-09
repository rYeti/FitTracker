import '../models/food_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodPreferences {
  static Future<void> saveFoodItem(
    String category,
    FoodItemModel foodItem,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current list of food items for this category
    List<String>? foodList = prefs.getStringList(category);

    // If no list exists, create an empty list
    foodList ??= [];

    // Add the new food item to the list (serialize it into a JSON string)
    foodList.add(jsonEncode(foodItem.toJson()));
    // Save the updated list back to SharedPreferences
    await prefs.setStringList(category, foodList);
  }
}
