import 'package:flutter/material.dart';
import '../../feature/food_tracking/data/repositories/nutrition_repository.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'enums.dart';

class UserGoalsProvider with ChangeNotifier {
  // Backing fields (defaults used until DB loads)
  int _calorieGoal = 2000;
  double _goalWeight = 80.0;
  double _startingWeight = 90.0;
  double _currentWeight = 85.0;

  int get calorieGoal => _calorieGoal;
  double get dailyCalorieGoal => _calorieGoal.toDouble();
  double get goalWeight => _goalWeight;
  double get startingWeight => _startingWeight;
  double get currentWeight => _currentWeight;

  final AppDatabase db;
  late final NutritionRepository repo;
  bool _loadedFromDb = false;

  UserGoalsProvider(this.db) {
    repo = NutritionRepository(db);
    _init();
  }

  Future<void> _init() async {
    await loadCalorieGoal();
  }

  // Loads the persisted calorie goal (if any) from the DB
  Future<void> loadCalorieGoal() async {
    try {
      final settings = await db.userSettingsDao.getSettings();
      if (settings != null) {
        _calorieGoal = settings.dailyCalorieGoal; // Drift data class field
      }
      _loadedFromDb = true;
    } catch (_) {
      // swallow errors; keep defaults
    }
    notifyListeners();
  }

  Future<void> saveCalorieGoal(int goal) async {
    _calorieGoal = goal;
    await repo.setCalorieGoal(goal); // persists via UserSettingsDao
    notifyListeners();
  }

  Future<void> setDailyCalorieGoal(int goal) async {
    // Update only in memory (UI) – call saveCalorieGoal to persist
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

  bool get isLoaded => _loadedFromDb;

  // Progress calculations
  double getWeightProgress() {
    if (startingWeight == goalWeight) return 1.0;
    final totalChange = (goalWeight - startingWeight).abs();
    final currentChange = (currentWeight - startingWeight).abs();
    final progress = currentChange / (totalChange == 0 ? 1 : totalChange);
    return progress.clamp(0.0, 1.0);
  }

  int calculateCalorieTarget({
    required Sex sex,
    required int age,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activity,
    required GoalType goal,
  }) {
    final bmr =
        (10 * weightKg) +
        (6.25 * heightCm) -
        (5 * age) +
        (sex == Sex.male ? 5 : -161);
    double activityFactor;
    switch (activity) {
      case ActivityLevel.sedentary:
        activityFactor = 1.2;
        break;
      case ActivityLevel.lightlyActive:
        activityFactor = 1.375;
        break;
      case ActivityLevel.moderatelyActive:
        activityFactor = 1.55;
        break;
      case ActivityLevel.veryActive:
        activityFactor = 1.725;
        break;
      case ActivityLevel.extremelyActive:
        activityFactor = 1.9;
        break;
    }
    var tdee = bmr * activityFactor;
    double multiplier;
    switch (goal) {
      case GoalType.weightLoss:
        multiplier = 0.85;
        break; // -15%
      case GoalType.maintenance:
        multiplier = 1.0;
        break;
      case GoalType.muscleGain:
        multiplier = 1.10;
        break; // +10%
    }
    final target = (tdee * multiplier).round();
    return target < 1200 ? 1200 : target;
  }

  Future<void> autoSetCalorieGoal({
    required Sex sex,
    required int age,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activity,
    required GoalType goal,
  }) async {
    if (!isLoaded) return;

    final newGoal = calculateCalorieTarget(
      sex: sex,
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
      activity: activity,
      goal: goal,
    );

    await setDailyCalorieGoal(newGoal);
  }
}
