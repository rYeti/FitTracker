// lib/feature/presentation/view/food_detail_view.dart
import 'package:flutter/material.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'package:fittnes_tracker/core/app_database.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItemModel foodItem;
  final String category;

  const FoodDetailsScreen({
    super.key,
    required this.foodItem,
    required this.category,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late final AppDatabase db;
  late final NutritionRepository _repository;
  final TextEditingController _quantityController = TextEditingController(
    text: "100",
  );
  double _quantity = 100.0;

  // Calculated nutrition values
  double _calculatedCalories = 0;
  double _calculatedProtein = 0;
  double _calculatedCarbs = 0;
  double _calculatedFat = 0;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _repository = NutritionRepository(db);
    _calculateNutrition();
  }

  void _calculateNutrition() {
    setState(() {
      _calculatedCalories = widget.foodItem.calories * (_quantity / 100);
      _calculatedProtein = widget.foodItem.protein * (_quantity / 100);
      _calculatedCarbs = widget.foodItem.carbs * (_quantity / 100);
      _calculatedFat = widget.foodItem.fat * (_quantity / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Food Details')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Name
                Text(
                  widget.foodItem.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Original Nutrition Card
                _buildNutritionCard(),
                const SizedBox(height: 16),

                // Portion Size and Calculated Values Card
                _buildPortionMarcroCalc(),
                const SizedBox(height: 16),

                // Add to Meal Section
                _buildAddToMealSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildNutrientRow(
              'Calories',
              '$_calculatedCalories kcal',
              Colors.orange,
            ),
            _buildNutrientRow('Protein', '$_calculatedProtein g', Colors.red),
            _buildNutrientRow('Carbs', '$_calculatedCarbs g', Colors.blue),
            _buildNutrientRow('Fat', '$_calculatedFat g', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, Color color) {
    // Extract numeric value from the string, removing units
    final numericValue = double.parse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
    final String unit = label.contains("Calories") ? "kcal" : "g";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: numericValue),
            duration: const Duration(milliseconds: 200),
            builder: (context, value, child) {
              return Text(
                '${value.toStringAsFixed(1)} $unit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortionMarcroCalc() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Portion Size",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity (g)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Strip non-numeric characters
                final numericValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
                setState(() {
                  _quantity = double.tryParse(numericValue) ?? 100.0;
                });
                _calculateNutrition();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToMealSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Add to today\'s log:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Show the selected category
        Text(
          'Meal Category: ${widget.category}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            // You should fetch the FoodItemData from the DB, not create a new one with only macros
            // If you want to add a custom portion, you should store the grams and macros in a separate table or as part of the meal entry
            // For now, just add the food item by its ID and let the repository handle the macros
            // If FoodItemModel does not have an id, you need to fetch the FoodItemData from the DB by name
            // For now, assume id is present. If not, you must update FoodItemModel to include id
            await _repository.addFoodToMeal(
              widget.category,
              FoodItemData(
                id: widget.foodItem.id ?? 0,
                name: widget.foodItem.name,
                calories: _calculatedCalories.round(),
                protein: _calculatedProtein.round(),
                carbs: _calculatedCarbs.round(),
                fat: _calculatedFat.round(),
                gramm: _quantity.round(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added ${widget.foodItem.name} (${_quantity.round()}g) to ${widget.category}',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Add to Log', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
