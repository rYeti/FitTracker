// lib/feature/presentation/view/food_detail_view.dart
import 'package:flutter/material.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';

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
  final NutritionRepository _repository = NutritionRepository();
  String _selectedCategory = 'Breakfast';
  final double _quantity = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              '${widget.foodItem.calories} kcal',
              Colors.orange,
            ),
            _buildNutrientRow(
              'Protein',
              '${widget.foodItem.protein}g',
              Colors.red,
            ),
            _buildNutrientRow(
              'Carbs',
              '${widget.foodItem.carbs}g',
              Colors.blue,
            ),
            _buildNutrientRow('Fat', '${widget.foodItem.fat}g', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, Color color) {
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
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPortionMarcroCalc() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Gramm'),
            ),
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
            await _repository.addFoodToMeal(widget.category, widget.foodItem);
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added ${widget.foodItem.name} to ${widget.category}',
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back
            Navigator.pop(context);
          },
          child: const Text('Add to Log', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
