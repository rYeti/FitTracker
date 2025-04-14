// lib/feature/presentation/view/food_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_nutrition_model.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'barcode_scanner_view.dart';
import 'food_add_screen.dart';

class FoodTrackingScreen extends StatefulWidget {
  const FoodTrackingScreen({super.key});

  @override
  _FoodTrackingScreenState createState() => _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends State<FoodTrackingScreen> {
  final NutritionRepository _repository = NutritionRepository();
  DailyNutrition? _todayNutrition;
  Map<String, List<FoodItemModel>> _mealFoods = {};
  bool _isLoading = true;
  final double _dailyCalorieGoal = 2000; // This should come from user settings

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  Future<void> _loadNutritionData() async {
    setState(() => _isLoading = true);
    final nutrition = await _repository.getTodayNutrition();
    final mealFoods = <String, List<FoodItemModel>>{};

    for (final category in ['Breakfast', 'Lunch', 'Dinner', 'Snacks']) {
      mealFoods[category] = await _repository.getFoodItemsForCategory(category);
    }

    setState(() {
      _todayNutrition = nutrition;
      _mealFoods = mealFoods;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNutritionData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNutritionData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDailySummary(),
                const SizedBox(height: 24),
                _buildMacroChart(),
                const SizedBox(height: 24),
                _buildMealsList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'quick_add',
            mini: true,
            onPressed: () {
              // TODO: Show quick add menu
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerView(),
                ),
              );
              _loadNutritionData();
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummary() {
    final dateFormat = DateFormat('EEEE, MMMM d');
    final progress = _todayNutrition!.totalCalories / _dailyCalorieGoal;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(_todayNutrition!.date),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    '${_todayNutrition!.totalCalories} / $_dailyCalorieGoal kcal',
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
              value: progress,
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
                  'Protein',
                  '${_todayNutrition!.totalProtein}g',
                  Colors.red,
                  '${(_todayNutrition!.totalProtein * 4 / _dailyCalorieGoal * 100).toStringAsFixed(1)}%',
                ),
                _buildNutrientSummary(
                  'Carbs',
                  '${_todayNutrition!.totalCarbs}g',
                  Colors.blue,
                  '${(_todayNutrition!.totalCarbs * 4 / _dailyCalorieGoal * 100).toStringAsFixed(1)}%',
                ),
                _buildNutrientSummary(
                  'Fat',
                  '${_todayNutrition!.totalFat}g',
                  Colors.green,
                  '${(_todayNutrition!.totalFat * 9 / _dailyCalorieGoal * 100).toStringAsFixed(1)}%',
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

  Widget _buildMacroChart() {
    if (_todayNutrition!.totalCalories == 0 &&
        _todayNutrition!.totalProtein == 0 &&
        _todayNutrition!.totalCarbs == 0 &&
        _todayNutrition!.totalFat == 0) {
      return Container();
    }

    final proteinCal = _todayNutrition!.totalProtein * 4;
    final carbsCal = _todayNutrition!.totalCarbs * 4;
    final fatCal = _todayNutrition!.totalFat * 9;
    final total = proteinCal + carbsCal + fatCal;

    final proteinPerc = total > 0 ? proteinCal / total : 0.0;
    final carbsPerc = total > 0 ? carbsCal / total : 0.0;
    final fatPerc = total > 0 ? fatCal / total : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Macronutrient Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 3,
                  sections: [
                    PieChartSectionData(
                      value: proteinPerc * 100,
                      title: '${(proteinPerc * 100).toStringAsFixed(1)}%',
                      color: Colors.red,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: carbsPerc * 100,
                      title: '${(carbsPerc * 100).toStringAsFixed(1)}%',
                      color: Colors.blue,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: fatPerc * 100,
                      title: '${(fatPerc * 100).toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Protein', Colors.red),
                _buildLegendItem('Carbs', Colors.blue),
                _buildLegendItem('Fat', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Meals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._mealFoods.entries.map((entry) {
          return _buildMealCard(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildMealCard(String category, List<FoodItemModel> foods) {
    final totalCalories = foods.fold(0, (sum, food) => sum + food.calories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '$totalCalories kcal',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          if (foods.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No foods added yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...foods.map((food) {
              return ListTile(
                title: Text(food.name),
                subtitle: Text(
                  '${food.calories} kcal | P: ${food.protein}g | C: ${food.carbs}g | F: ${food.fat}g',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await _repository.removeFoodFromMeal(category, food);
                    _loadNutritionData();
                  },
                ),
              );
            }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Food'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodAddScreen(category: category),
                  ),
                );
                _loadNutritionData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
