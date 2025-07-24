import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_nutrition_model.dart';
import '../../data/repositories/nutrition_repository.dart';

class NutritionProgressDashboard extends StatefulWidget {
  const NutritionProgressDashboard({super.key});

  @override
  _NutritionProgressDashboardState createState() =>
      _NutritionProgressDashboardState();
}

class _NutritionProgressDashboardState
    extends State<NutritionProgressDashboard> {
  final NutritionRepository _repository = NutritionRepository();
  List<DailyNutrition> _nutritionHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNutritionHistory();
  }

  Future<void> _loadNutritionHistory() async {
    setState(() => _isLoading = true);

    // Get last 7 days of data
    final history = await _repository.getNutritionHistory();

    setState(() {
      // Sort from oldest to newest for graphs
      _nutritionHistory = List.from(history)
        ..sort((a, b) => a.date.compareTo(b.date));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Nutrition Progress')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCaloriesChart(),
              const SizedBox(height: 24),
              _buildMacronutrientChart(),
              const SizedBox(height: 24),
              _buildMacroPercentageComparison(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaloriesChart() {
    // If no data, show placeholder
    if (_nutritionHistory.isEmpty) {
      return _buildEmptyPlaceholder('No nutrition data available');
    }

    // Prepare data
    final spots =
        _nutritionHistory
            .asMap()
            .entries
            .map(
              (entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.totalCalories.toDouble(),
              ),
            )
            .toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calories Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Get date for this point
                          final index = value.toInt();
                          if (index < 0 || index >= _nutritionHistory.length) {
                            return const Text('');
                          }

                          // Format date as day of week
                          final date = _nutritionHistory[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('E').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 0,
                  maxX: _nutritionHistory.length - 1.0,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: Colors.blue),
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

  Widget _buildMacronutrientChart() {
    // If no data, show placeholder
    if (_nutritionHistory.isEmpty) {
      return _buildEmptyPlaceholder('No nutrition data available');
    }

    // Prepare data for each macronutrient
    final proteinSpots =
        _nutritionHistory
            .asMap()
            .entries
            .map(
              (entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.totalProtein.toDouble(),
              ),
            )
            .toList();

    final carbsSpots =
        _nutritionHistory
            .asMap()
            .entries
            .map(
              (entry) => FlSpot(
                entry.key.toDouble(),
                entry.value.totalCarbs.toDouble(),
              ),
            )
            .toList();

    final fatSpots =
        _nutritionHistory
            .asMap()
            .entries
            .map(
              (entry) =>
                  FlSpot(entry.key.toDouble(), entry.value.totalFat.toDouble()),
            )
            .toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Macronutrient Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Get date for this point
                          final index = value.toInt();
                          if (index < 0 || index >= _nutritionHistory.length) {
                            return const Text('');
                          }

                          // Format date as day of week
                          final date = _nutritionHistory[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('E').format(date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 0,
                  maxX: _nutritionHistory.length - 1.0,
                  minY: 0,
                  lineBarsData: [
                    // Protein line
                    LineChartBarData(
                      spots: proteinSpots,
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                    ),
                    // Carbs line
                    LineChartBarData(
                      spots: carbsSpots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                    ),
                    // Fat line
                    LineChartBarData(
                      spots: fatSpots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
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

  Widget _buildMacroPercentageComparison() {
    // If no data, show placeholder
    if (_nutritionHistory.isEmpty) {
      return _buildEmptyPlaceholder('No nutrition data available');
    }

    // Calculate the average macro percentages
    double avgProteinPerc = 0;
    double avgCarbsPerc = 0;
    double avgFatPerc = 0;

    for (final day in _nutritionHistory) {
      // Calculate calories from each macro
      final proteinCal = day.totalProtein * 4;
      final carbsCal = day.totalCarbs * 4;
      final fatCal = day.totalFat * 9;

      final total = proteinCal + carbsCal + fatCal;
      if (total > 0) {
        avgProteinPerc += (proteinCal / total) * 100;
        avgCarbsPerc += (carbsCal / total) * 100;
        avgFatPerc += (fatCal / total) * 100;
      }
    }

    // Get average
    if (_nutritionHistory.isNotEmpty) {
      avgProteinPerc /= _nutritionHistory.length;
      avgCarbsPerc /= _nutritionHistory.length;
      avgFatPerc /= _nutritionHistory.length;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Average Macronutrient Distribution',
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
                      value: avgProteinPerc,
                      title: '${avgProteinPerc.toStringAsFixed(1)}%',
                      color: Colors.red,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: avgCarbsPerc,
                      title: '${avgCarbsPerc.toStringAsFixed(1)}%',
                      color: Colors.blue,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: avgFatPerc,
                      title: '${avgFatPerc.toStringAsFixed(1)}%',
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

  Widget _buildEmptyPlaceholder(String message) {
    return Card(
      elevation: 4,
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(message, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
