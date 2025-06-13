import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserGoalsProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _dailyCalorieGoalKey = 'daily_calorie_goal';
  static const String _goalWeightKey = 'goal_weight';
  static const String _startingWeightKey = 'starting_weight';
  static const String _currentWeightKey = 'current_weight';

  // Default values
  int _calorieGoal = 2000;
  static const double _defaultGoalWeight = 80.0;
  static const double _defaultStartingWeight = 90.0;
  static const double _defaultCurrentWeight = 85.0;
  int get calorieGoal => _calorieGoal;

  UserGoalsProvider(this._prefs);

  // Getters with default values
  int get dailyCalorieGoal =>
      _prefs.getInt(_dailyCalorieGoalKey) ?? _calorieGoal;
  double get goalWeight =>
      _prefs.getDouble(_goalWeightKey) ?? _defaultGoalWeight;
  double get startingWeight =>
      _prefs.getDouble(_startingWeightKey) ?? _defaultStartingWeight;
  double get currentWeight =>
      _prefs.getDouble(_currentWeightKey) ?? _defaultCurrentWeight;

  // Setters
  Future<void> setDailyCalorieGoal(int goal) async {
    await _prefs.setInt(_dailyCalorieGoalKey, goal);
    notifyListeners();
  }

  Future<void> loadCalorieGoal() async {
    final prefs = await SharedPreferences.getInstance();
    _calorieGoal = prefs.getInt('dailyCalorieGoal') ?? 2000;
    notifyListeners();
  }

  Future<void> saveCalorieGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyCalorieGoal', goal);
    _calorieGoal = goal;
    notifyListeners();
  }

  Future<void> setGoalWeight(double weight) async {
    await _prefs.setDouble(_goalWeightKey, weight);
    notifyListeners();
  }

  Future<void> setStartingWeight(double weight) async {
    await _prefs.setDouble(_startingWeightKey, weight);
    notifyListeners();
  }

  Future<void> setCurrentWeight(double weight) async {
    await _prefs.setDouble(_currentWeightKey, weight);
    notifyListeners();
  }

  // Progress calculations
  double getWeightProgress() {
    if (startingWeight == goalWeight) return 1.0;

    // Calculate total weight change needed
    final totalChange = (goalWeight - startingWeight).abs();

    // Calculate current progress
    final currentChange = (currentWeight - startingWeight).abs();

    // Calculate progress as a value between 0 and 1
    final progress = currentChange / totalChange;

    // Ensure progress is between 0 and 1
    return progress.clamp(0.0, 1.0);
  }
}
