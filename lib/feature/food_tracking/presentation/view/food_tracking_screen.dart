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

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  Future<void> _loadNutritionData() async {
    setState(() => _isLoading = true);

    final nutrition = await _repository.getTodayNutrition();
    final mealFoods = <String, List<FoodItemModel>>{};

    // Load all food items for each category
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
        ],
      ),
      body: SingleChildScrollView(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BarcodeScannerView()),
          );
          // Refresh data when returning from scanner
          _loadNutritionData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDailySummary() {
    final dateFormat = DateFormat('EEEE, MMMM d');

    return Card(
      elevation: 4,
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
                Text(
                  '${_todayNutrition!.totalCalories} kcal',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientSummary(
                  'Protein',
                  '${_todayNutrition!.totalProtein}g',
                  Colors.red,
                ),
                _buildNutrientSummary(
                  'Carbs',
                  '${_todayNutrition!.totalCarbs}g',
                  Colors.blue,
                ),
                _buildNutrientSummary(
                  'Fat',
                  '${_todayNutrition!.totalFat}g',
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientSummary(String label, String value, Color color) {
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
      ],
    );
  }

  Widget _buildMacroChart() {
    // Skip building chart if all values are 0
    if (_todayNutrition!.totalCalories == 0 &&
        _todayNutrition!.totalProtein == 0 &&
        _todayNutrition!.totalCarbs == 0 &&
        _todayNutrition!.totalFat == 0) {
      return Container(); // Empty container
    }

    // Calculate macro percentages (from total calories)
    final proteinCal = _todayNutrition!.totalProtein * 4;
    final carbsCal = _todayNutrition!.totalCarbs * 4;
    final fatCal = _todayNutrition!.totalFat * 9;

    final total = proteinCal + carbsCal + fatCal;

    // Avoid division by zero
    final proteinPerc = total > 0 ? proteinCal / total : 0.0;
    final carbsPerc = total > 0 ? carbsCal / total : 0.0;
    final fatPerc = total > 0 ? fatCal / total : 0.0;

    return Card(
      elevation: 4,
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
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
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
        const SizedBox(height: 8),
        _buildMealCategory('Breakfast'),
        _buildMealCategory('Lunch'),
        _buildMealCategory('Dinner'),
        _buildMealCategory('Snacks'),
      ],
    );
  }

  Widget _buildMealCategory(String category) {
    final foods = _mealFoods[category] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (foods.isNotEmpty)
              Text(
                '${foods.fold(0, (sum, food) => sum + food.calories)} kcal',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foods.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == foods.length) {
                // Add button at the end
                return ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Add food'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodAddScreen(category: category),
                      ),
                    );
                    // Refresh data
                    _loadNutritionData();
                  },
                );
              } else {
                // Food item
                final food = foods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text('${food.calories} kcal'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      // TODO: Implement food item removal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Food removal not implemented yet'),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
