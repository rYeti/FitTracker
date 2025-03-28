// lib/feature/food_tracking/data/models/daily_nutrition.dart
class DailyNutrition {
  final DateTime date;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final Map<String, List<String>>
  meals; // Category -> List of serialized food items

  DailyNutrition({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.meals,
  });

  factory DailyNutrition.empty(DateTime date) {
    return DailyNutrition(
      date: date,
      totalCalories: 0,
      totalProtein: 0,
      totalCarbs: 0,
      totalFat: 0,
      meals: {'Breakfast': [], 'Lunch': [], 'Dinner': [], 'Snacks': []},
    );
  }

  // Create a copy with updated values
  DailyNutrition copyWith({
    DateTime? date,
    int? totalCalories,
    int? totalProtein,
    int? totalCarbs,
    int? totalFat,
    Map<String, List<String>>? meals,
  }) {
    return DailyNutrition(
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      meals: meals ?? this.meals,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'meals': meals,
    };
  }

  // Create from JSON
  factory DailyNutrition.fromJson(Map<String, dynamic> json) {
    return DailyNutrition(
      date: DateTime.parse(json['date']),
      totalCalories: json['totalCalories'],
      totalProtein: json['totalProtein'],
      totalCarbs: json['totalCarbs'],
      totalFat: json['totalFat'],
      meals: (json['meals'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }
}
