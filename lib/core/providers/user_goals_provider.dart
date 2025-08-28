import 'package:flutter/material.dart';
import '../../feature/food_tracking/data/repositories/nutrition_repository.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import '../../feature/weight_tracking/data/repositories/weight_repository.dart';
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
  late final WeightRepository weightRepo;
  bool _loadedFromDb = false;

  UserGoalsProvider(this.db) {
    repo = NutritionRepository(db);
    weightRepo = WeightRepository(db);
    _init();
  }

  Future<void> _init() async {
    await loadCalorieGoal();
    await loadLatestWeight();
    await loadWeightGoals();
  }

  // Loads the latest weight record from the database
  Future<void> loadLatestWeight() async {
    try {
      final latestWeight = await weightRepo.getLatestWeightRecord();
      if (latestWeight != null) {
        _currentWeight = latestWeight.weight;
        notifyListeners();
      }
    } catch (e) {
      // If there's an error, keep the default weight
      debugPrint('Error loading latest weight: $e');
    }
  }

  // Load weight goals from user settings
  Future<void> loadWeightGoals() async {
    try {
      final settings = await db.userSettingsDao.getSettings();
      if (settings != null) {
        // These fields will exist after we regenerate the database code
        _startingWeight = settings.startingWeight;
        _goalWeight = settings.goalWeight;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading weight goals: $e');
    }
  }

  Future<void> loadCalorieGoal() async {
    try {
      final settings = await db.userSettingsDao.getSettings();
      if (settings != null) {
        _calorieGoal = settings.dailyCalorieGoal;
      }
      _loadedFromDb = true;
    } catch (_) {
      // swallow errors; keep defaults
    }
    notifyListeners();
  }

  Future<void> saveCalorieGoal(int goal) async {
    _calorieGoal = goal;
    await repo.setCalorieGoal(goal);
    notifyListeners();
  }

  Future<void> setDailyCalorieGoal(int goal) async {
    _calorieGoal = goal;
    notifyListeners();
  }

  Future<void> setGoalWeight(double weight) async {
    _goalWeight = weight;
    notifyListeners();

    try {
      await db.userSettingsDao.updateProfile(goalWeight: weight);
    } catch (e) {
      debugPrint('Error saving goal weight: $e');
    }
  }

  Future<void> setStartingWeight(double weight) async {
    _startingWeight = weight;
    notifyListeners();

    try {
      await db.userSettingsDao.updateProfile(startingWeight: weight);
    } catch (e) {
      debugPrint('Error saving starting weight: $e');
    }
  }

  Future<void> setCurrentWeight(double weight) async {
    _currentWeight = weight;
    notifyListeners();

    // Current weight is tracked through weight records, not user settings
    try {
      await weightRepo.addWeightRecord(date: DateTime.now(), weight: weight);
    } catch (e) {
      debugPrint('Error saving current weight: $e');
    }
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

  Future<void> updateCurrentWeightValue(double weight) async {
    _currentWeight = weight;
    notifyListeners();
  }
}
