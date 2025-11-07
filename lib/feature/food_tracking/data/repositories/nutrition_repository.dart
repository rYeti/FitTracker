import 'dart:convert';
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/food_tracking/data/models/daily_nutrition_model.dart';
import 'package:ForgeForm/feature/food_tracking/data/models/meal_template.dart';
import 'package:drift/drift.dart';
import 'package:dio/dio.dart';

// Lightweight cached entry for search results
class _CachedSearch {
  final DateTime ts;
  final List<Map<String, dynamic>> data;
  _CachedSearch(this.ts, this.data);
  bool isFresh(Duration ttl) => DateTime.now().difference(ts) < ttl;
}

class NutritionRepository {
  final AppDatabase db;
  final Dio _dio = Dio();
  // In–memory search cache (query -> results)
  final Map<String, _CachedSearch> _searchCache = {};
  static const int _maxCacheEntries = 40;
  static const Duration _cacheTtl = Duration(minutes: 10);
  bool _persistentLoaded = false; // lazy load flag

  NutritionRepository(this.db);

  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    // Lazy load persistent cache once
    if (!_persistentLoaded) {
      await _loadPersistent();
    }

    // 1. Exact cache hit & fresh
    final exact = _searchCache[q];
    if (exact != null && exact.isFresh(_cacheTtl)) {
      return List<Map<String, dynamic>>.from(exact.data);
    }

    // 2. Try prefix refinement (longest cached prefix) for incremental typing
    _CachedSearch? prefixEntry;
    for (final key in _searchCache.keys) {
      if (q.startsWith(key)) {
        if (prefixEntry == null ||
            key.length > _searchCache.keys.first.length) {
          final cand = _searchCache[key];
          if (cand != null && cand.isFresh(_cacheTtl)) {
            prefixEntry = cand;
          }
        }
      }
    }
    if (prefixEntry != null) {
      final filtered =
          prefixEntry.data.where((m) {
            final name =
                (m['product_name'] ?? m['name'] ?? '').toString().toLowerCase();
            final brands = (m['brands'] ?? '').toString().toLowerCase();
            return name.contains(q) || brands.contains(q);
          }).toList();
      // If we have meaningful filtered results (or query length grew), return without network
      if (filtered.isNotEmpty && q.length > 2) {
        _cacheStore(q, filtered); // store refined subset
        return filtered;
      }
    }

    // 3. Network fetch fallback
    try {
      final resp = await _dio.get(
        'https://world.openfoodfacts.org/cgi/search.pl',
        queryParameters: {
          'search_terms': q,
          'search_simple': 1,
          'action': 'process',
          'json': 1,
          'page_size': 50,
          'fields': 'id,product_name,brands,nutriments',
        },
      );
      final data = resp.data;
      final products = (data is Map) ? data['products'] : null;
      final list =
          (products is List)
              ? products.whereType<Map>().cast<Map<String, dynamic>>().toList()
              : <Map<String, dynamic>>[];
      _cacheStore(q, list);
      return List<Map<String, dynamic>>.from(list);
    } catch (_) {
      // On failure, fallback to any stale cache if exists
      if (exact != null) return List<Map<String, dynamic>>.from(exact.data);
      if (prefixEntry != null)
        return List<Map<String, dynamic>>.from(prefixEntry.data);
      return [];
    }
  }

  void _cacheStore(String q, List<Map<String, dynamic>> data) {
    if (data.isEmpty)
      return; // avoid caching empty responses – they may be temporary
    _searchCache[q] = _CachedSearch(DateTime.now(), data);
    if (_searchCache.length > _maxCacheEntries) {
      // Evict oldest
      final oldestKey =
          _searchCache.entries
              .reduce((a, b) => a.value.ts.isBefore(b.value.ts) ? a : b)
              .key;
      _searchCache.remove(oldestKey);
      // Best-effort prune in persistent store (ignore errors)
      try {
        db.searchCacheDao.deleteByQuery(oldestKey);
      } catch (_) {}
    }
    // Persist asynchronously (fire & forget)
    try {
      db.searchCacheDao.upsert(
        q,
        jsonEncode(data),
        DateTime.now().millisecondsSinceEpoch,
      );
      // Periodic pruning of stale rows
      db.searchCacheDao.deleteOlderThan(
        DateTime.now().subtract(_cacheTtl).millisecondsSinceEpoch,
      );
    } catch (_) {}
  }

  Future<void> _loadPersistent() async {
    _persistentLoaded = true; // set first to avoid re-entry on errors
    try {
      final cutoff = DateTime.now().subtract(_cacheTtl).millisecondsSinceEpoch;
      final rows = await db.searchCacheDao.getAll();
      for (final row in rows) {
        if (row.ts < cutoff) continue; // stale
        try {
          final decoded = jsonDecode(row.json);
          if (decoded is List) {
            final list =
                decoded.whereType<Map>().cast<Map<String, dynamic>>().toList();
            _searchCache[row.query] = _CachedSearch(
              DateTime.fromMillisecondsSinceEpoch(row.ts),
              list,
            );
          }
        } catch (_) {
          // ignore malformed rows
        }
      }
    } catch (_) {
      // ignore load errors
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

  // Add a template to a specific meal category
  Future<void> applyTemplateToMeal(
    String category,
    List<MealTemplateItem> templateItems,
  ) async {
    print(
      'Starting to apply template with ${templateItems.length} items to $category',
    );

    for (final item in templateItems) {
      print('Processing item: ${item.foodName}');

      // First, make sure the food item is in the database
      FoodItemData? foodItem = await db.foodItemDao.getFoodItemById(
        item.foodId,
      );

      // If the food doesn't exist, create it first
      if (foodItem == null) {
        print('Food item not found in database, creating new food item');

        try {
          final foodId = await db.foodItemDao.insertFoodItem(
            FoodItemCompanion.insert(
              name: item.foodName,
              calories: item.calories.toInt(),
              protein: item.protein.toInt(),
              carbs: item.carbs.toInt(),
              fat: item.fat.toInt(),
              gramm: Value(item.quantity.toInt()),
            ),
          );

          print('Created new food item with ID: $foodId');
          foodItem = await db.foodItemDao.getFoodItemById(foodId);

          if (foodItem == null) {
            print('Could not retrieve the created food item, skipping');
            continue; // Skip if we couldn't create the food
          }
        } catch (e) {
          print('Error creating food item: $e');
          continue; // Skip if there was an error
        }
      } else {
        print(
          'Found existing food item: ${foodItem.name} (ID: ${foodItem.id})',
        );
      }

      // Add the food to the meal
      try {
        print('Adding food ${foodItem.name} to meal category $category');
        await addFoodToMeal(category, foodItem);
        print('Successfully added food to meal');
      } catch (e) {
        print('Error adding food to meal: $e');
      }
    }

    print('Finished applying template');
  }
}
