// lib/feature/presentation/view/food_tracking_screen.dart
import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/core/providers/user_goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'food_add_screen.dart';

// Create a global key to access the FoodTrackingScreen state
final globalFoodTrackingKey = GlobalKey<_FoodTrackingScreenState>();

class FoodTrackingScreen extends StatefulWidget {
  const FoodTrackingScreen({Key? key}) : super(key: key);

  @override
  State<FoodTrackingScreen> createState() => _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends State<FoodTrackingScreen> {
  late final AppDatabase db;
  late final NutritionRepository _repository;
  Map<String, List<FoodItemData>> _mealFoods = {};
  bool _isLoading = true;
  double _dailyCalorieGoal = 2000;

  // Map stored category keys to AppLocalizations getters so we can present
  // translated labels without changing storage or DB values.
  final Map<String, String Function(AppLocalizations)> _mealLabelGetters = {
    'Breakfast': (loc) => loc.mealBreakfast,
    'Lunch': (loc) => loc.mealLunch,
    'Dinner': (loc) => loc.mealDinner,
    'Snacks': (loc) => loc.mealSnacks,
  };

  String _localizedMealLabel(String category, BuildContext ctx) {
    final loc = AppLocalizations.of(ctx)!;
    final getter = _mealLabelGetters[category];
    return getter?.call(loc) ?? category;
  }

  @override
  void initState() {
    super.initState();
    // Get the database instance from Provider instead of creating a new one
    db = Provider.of<AppDatabase>(context, listen: false);
    _repository = NutritionRepository(db);
    loadNutritionData();
  }

  // Making this method public so it can be called from outside
  Future<void> loadNutritionData() async {
    setState(() => _isLoading = true);
    try {
      final userSettings = await _repository.getUserSettings();
      final mealCategories = [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Snacks',
      ]; // Hardcoded categories
      final mealFoods = <String, List<FoodItemData>>{};

      for (final category in mealCategories) {
        mealFoods[category] = await _repository.getFoodItemsForCategory(
          category,
        );
      }

      setState(() {
        _dailyCalorieGoal = (userSettings?.dailyCalorieGoal ?? 2000).toDouble();
        _mealFoods = mealFoods;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToLoadData(e)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.foodTracker),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            tooltip: 'Meal Templates',
            onPressed: () {
              Navigator.pushNamed(context, '/meal-templates');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadNutritionData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadNutritionData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDailySummary(),
                const SizedBox(height: 24),
                // _buildWeeklyProgress(),
                const SizedBox(height: 24),
                _buildMealsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('EEEE, MMMM d', locale);
    final calorieGoal = Provider.of<UserGoalsProvider>(context).calorieGoal;
    // Calculate daily totals from _mealFoods
    int totalCalories = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;
    _mealFoods.forEach((_, foods) {
      for (final food in foods) {
        totalCalories += food.calories;
        totalProtein += food.protein;
        totalCarbs += food.carbs;
        totalFat += food.fat;
      }
    });
    final progress = calorieGoal > 0 ? totalCalories / calorieGoal : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$totalCalories / $calorieGoal kcal',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 1 ? Colors.red : Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientSummary(
                  AppLocalizations.of(context)!.proteinLabel,
                  '${totalProtein}g',
                  Colors.red,
                  calorieGoal > 0
                      ? '${(totalProtein * 4 / calorieGoal * 100).toStringAsFixed(1)}%'
                      : '0%',
                ),
                _buildNutrientSummary(
                  AppLocalizations.of(context)!.carbsLabel,
                  '${totalCarbs}g',
                  Colors.blue,
                  calorieGoal > 0
                      ? '${(totalCarbs * 4 / calorieGoal * 100).toStringAsFixed(1)}%'
                      : '0%',
                ),
                _buildNutrientSummary(
                  AppLocalizations.of(context)!.fatLabel,
                  '${totalFat}g',
                  Colors.green,
                  calorieGoal > 0
                      ? '${(totalFat * 9 / calorieGoal * 100).toStringAsFixed(1)}%'
                      : '0%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientSummary(
    String label,
    String value,
    Color color,
    String percentage,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
          percentage,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.food,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._mealFoods.entries.map((entry) {
          return _buildMealCard(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildMealCard(String category, List<FoodItemData> foods) {
    final totalCalories = foods.fold(0, (sum, food) => sum + food.calories);

    return Builder(
      builder:
          (localContext) => Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Meal Name and Calories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _localizedMealLabel(category, localContext),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$totalCalories kcal',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0.5),

                  // Buttons Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              localContext,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        FoodAddScreen(category: category),
                              ),
                            );
                            loadNutritionData();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              const Icon(Icons.add, size: 22),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Meal Items
                  if (foods.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        AppLocalizations.of(context)!.noFoodAdded,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children:
                          foods.map((food) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(food.name),
                              subtitle: Text(
                                '${food.calories} kcal · P: ${food.protein}g · C: ${food.carbs}g · F: ${food.fat}g',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  await _repository.removeFoodFromMeal(
                                    category,
                                    food,
                                  );
                                  loadNutritionData();
                                },
                              ),
                            );
                          }).toList(),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  // Widget _buildWeeklyProgress() {
  //   // For now, keep the static data for previous days, but use today's totalCalories for the last bar
  //   int todayCalories = 0;
  //   _mealFoods.forEach((_, foods) {
  //     for (final food in foods) {
  //       todayCalories += food.calories;
  //     }
  //   });
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Weekly Progress',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 16),
  //           SizedBox(
  //             height: 200,
  //             child: BarChart(
  //               BarChartData(
  //                 alignment: BarChartAlignment.spaceAround,
  //                 maxY: _dailyCalorieGoal * 1.2,
  //                 titlesData: FlTitlesData(
  //                   leftTitles: const AxisTitles(
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   rightTitles: const AxisTitles(
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   topTitles: const AxisTitles(
  //                     sideTitles: SideTitles(showTitles: false),
  //                   ),
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget: (value, meta) {
  //                         const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  //                         return Text(days[value.toInt() % 7]);
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 borderData: FlBorderData(show: false),
  //                 barGroups: [
  //                   _createBarGroup(0, 1800),
  //                   _createBarGroup(1, 1650),
  //                   _createBarGroup(2, 2100),
  //                   _createBarGroup(3, 1950),
  //                   _createBarGroup(4, 1850),
  //                   _createBarGroup(5, 2300),
  //                   _createBarGroup(6, todayCalories.toDouble()),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // BarChartGroupData _createBarGroup(int x, double y) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: y,
  //         color: y > _dailyCalorieGoal ? Colors.red : Colors.blue,
  //         width: 20,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //     ],
  //   );
  // }
}
