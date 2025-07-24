import 'package:flutter/material.dart';

class UserGoalsProvider with ChangeNotifier {
  // Default values
  int _calorieGoal = 2000;
  double _goalWeight = 80.0;
  double _startingWeight = 90.0;
  double _currentWeight = 85.0;

  int get calorieGoal => _calorieGoal;
  double get dailyCalorieGoal => _calorieGoal.toDouble();
  double get goalWeight => _goalWeight;
  double get startingWeight => _startingWeight;
  double get currentWeight => _currentWeight;

  UserGoalsProvider();

  // Setters
  Future<void> setDailyCalorieGoal(int goal) async {
    _calorieGoal = goal;
    notifyListeners();
  }

  Future<void> loadCalorieGoal() async {
    // No-op for now
    notifyListeners();
  }

  Future<void> saveCalorieGoal(int goal) async {
    _calorieGoal = goal;
    notifyListeners();
  }

  Future<void> setGoalWeight(double weight) async {
    _goalWeight = weight;
    notifyListeners();
  }

  Future<void> setStartingWeight(double weight) async {
    _startingWeight = weight;
    notifyListeners();
  }

  Future<void> setCurrentWeight(double weight) async {
    _currentWeight = weight;
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
