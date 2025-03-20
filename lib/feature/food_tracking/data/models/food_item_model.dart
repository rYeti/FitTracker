import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodItemModel {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodItemModel({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    // Check if it's the first type (simpler JSON)
    if (json.containsKey('name') && json.containsKey('calories')) {
      return FoodItemModel(
        name: json['name'] ?? 'Unknown',
        calories: json['calories'] ?? 0,
        protein: json['protein']?.toDouble() ?? 0.0,
        carbs: json['carbs']?.toDouble() ?? 0.0,
        fat: json['fat']?.toDouble() ?? 0.0,
      );
    }

    // If it's the second type (nested "nutriments")
    return FoodItemModel(
      name: json['product_name'] ?? json['brands'] ?? 'Unknown',
      calories: json['nutriments']?['energy-kcal']?.toInt() ?? 0,
      protein: json['nutriments']?['proteins']?.toDouble() ?? 0.0,
      carbs: json['nutriments']?['carbohydrates']?.toDouble() ?? 0.0,
      fat: json['nutriments']?['fat']?.toDouble() ?? 0.0,
    );
  }
}

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
