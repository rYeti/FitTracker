import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'food_add_screen.dart';

class FoodTrackingScreen extends StatefulWidget {
  const FoodTrackingScreen({super.key});

  @override
  _FoodTrackingScreenState createState() => _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends State<FoodTrackingScreen> {
  // All the meal data will go here (same logic as before)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Tracker")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _macroChart(),
            _buildMealCategory(context, "Breakfast"),
            _buildMealCategory(context, "Lunch"),
            _buildMealCategory(context, "Dinner"),
            _buildMealCategory(context, "Snacks"),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCategory(BuildContext context, String category) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListTile(
          title: Text(
            category,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodAddScreen(category: category),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _macroChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.start,
          barGroups: [
            BarChartGroupData(
              x: 0,
              groupVertically: true, // Makes bars horizontal
              barRods: [
                BarChartRodData(
                  fromY: 0, // Start point
                  toY: 4000, // End point (value)
                  color: Colors.blue,
                  width: 10, // Thickness of the bar
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              groupVertically: true,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 100,
                  color: Colors.red,
                  width: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              groupVertically: true,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 200,
                  color: Colors.green,
                  width: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Calories");
                    case 1:
                      return const Text("Protein");
                    case 2:
                      return const Text("Carbs");
                    default:
                      return const Text("");
                  }
                },
                reservedSize: 50,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }
}
