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
                _buildWeeklyProgress(),
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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerView(),
                ),
              );
              _loadNutritionData();
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

  Widget _buildMealCardold(String category, List<FoodItemModel> foods) {
    final totalCalories = foods.fold(0, (sum, food) => sum + food.calories);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
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

          const Divider(height: 1),
          ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.fastfood),
                  label: const Text('Templates'),
                  onPressed: () => _showMealTemplates(category),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(String category, List<FoodItemModel> foods) {
    final totalCalories = foods.fold(0, (sum, food) => sum + food.calories);

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
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
                  category,
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
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Food'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FoodAddScreen(category: category),
                        ),
                      );
                      _loadNutritionData();
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const Text('Templates'),
                    onPressed: () => _showMealTemplates(category),
                  ),
                ],
              ),
            ),

            // Meal Items
            if (foods.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'No foods added yet',
                  style: TextStyle(color: Colors.grey),
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
                            _loadNutritionData();
                          },
                        ),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _dailyCalorieGoal * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(days[value.toInt() % 7]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _createBarGroup(0, 1800),
                    _createBarGroup(1, 1650),
                    _createBarGroup(2, 2100),
                    _createBarGroup(3, 1950),
                    _createBarGroup(4, 1850),
                    _createBarGroup(5, 2300),
                    _createBarGroup(
                      6,
                      _todayNutrition!.totalCalories.toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > _dailyCalorieGoal ? Colors.red : Colors.blue,
          width: 20,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  void _showMealTemplates(String category) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('$category Templates'),
              subtitle: const Text('Quick add your favorite meals'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.breakfast_dining),
              title: const Text('Oatmeal with Fruit'),
              subtitle: const Text('350 kcal | P: 12g | C: 60g | F: 8g'),
              onTap: () {
                // Add template meal
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lunch_dining),
              title: const Text('Chicken Salad'),
              subtitle: const Text('450 kcal | P: 35g | C: 20g | F: 25g'),
              onTap: () {
                // Add template meal
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
