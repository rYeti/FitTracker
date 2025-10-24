// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get sedentary => 'Sedentary';

  @override
  String get lightlyActive => 'Lightly Active';

  @override
  String get moderatelyActive => 'Moderately Active';

  @override
  String get veryActive => 'Very Active';

  @override
  String get extremelyActive => 'Extremely Active';

  @override
  String get weightLoss => 'Weight Loss';

  @override
  String get muscleGain => 'Muscle Gain';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get food => 'Food';

  @override
  String get gym => 'Gym';

  @override
  String get progress => 'Progress';

  @override
  String get settings => 'Settings';

  @override
  String get age => 'Age';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get dailyCalorieGoal => 'Daily Calorie Goal';

  @override
  String get save => 'Save';

  @override
  String get saveCalorieGoal => 'Calorie goal saved';

  @override
  String addFood(Object category) {
    return '$category';
  }

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get nutritionProgress => 'Nutrition Progress';

  @override
  String get foodDetails => 'Food Details';

  @override
  String searchFailed(Object error) {
    return 'Search failed: $error';
  }

  @override
  String get pleaseEnterValidAgeAndHeight =>
      'Please enter valid age and height';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get calculatedAndSavedCalorieGoal =>
      'Calculated and saved calorie goal';

  @override
  String failedToSaveProfile(Object error) {
    return 'Failed to save profile: $error';
  }

  @override
  String failedToUpdateCalorieGoal(Object error) {
    return 'Failed to update calorie goal: $error';
  }

  @override
  String failedToLoadData(Object error) {
    return 'Failed to load data: $error';
  }

  @override
  String get sex => 'Sex';

  @override
  String get activity => 'Activity';

  @override
  String get goal => 'Goal';

  @override
  String get cancel => 'Cancel';

  @override
  String get addCustomFood => 'Add Custom Food';

  @override
  String get foodName => 'Food Name';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein (g)';

  @override
  String get carbs => 'Carbs (g)';

  @override
  String get fat => 'Fat (g)';

  @override
  String get addedSuccessfully => 'added successfully!';

  @override
  String get pleaseEnterAName => 'Please enter a name';

  @override
  String get pleaseEnterCalories => 'Please enter calories';

  @override
  String get foodTracker => 'Tracker';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get carbsLabel => 'Carbs';

  @override
  String get fatLabel => 'Fat';

  @override
  String get ok => 'OK';

  @override
  String get addFailed => 'Failed to add';

  @override
  String get nutritionInformation => 'Nutrition Information';

  @override
  String get portionSize => 'Portion size';

  @override
  String get quantityInGrams => 'Quantity in grams';

  @override
  String get addToTodayLog => 'Add to today\'s log';

  @override
  String get mealCategory => 'Meal category';

  @override
  String get addToLog => 'Add to log';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnacks => 'Snacks';

  @override
  String get searchForFood => 'Search for food';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String addedToRecentFoods(Object name) {
    return '$name added to recent foods';
  }

  @override
  String get noFoodAdded => 'No foods added yet';

  @override
  String get calculateAndSave => 'Calculated and saved calorie goal';
}
