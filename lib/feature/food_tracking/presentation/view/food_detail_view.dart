import 'package:drift/drift.dart' show Value;
// lib/feature/presentation/view/food_detail_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.foodDetails)),
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
            Text(
              AppLocalizations.of(context)!.nutritionInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildNutrientRow(
              AppLocalizations.of(context)!.calories,
              _calculatedCalories,
              'kcal',
              Colors.orange,
            ),
            _buildNutrientRow(
              AppLocalizations.of(context)!.protein,
              _calculatedProtein,
              'g',
              Colors.red,
            ),
            _buildNutrientRow(
              AppLocalizations.of(context)!.carbs,
              _calculatedCarbs,
              'g',
              Colors.blue,
            ),
            _buildNutrientRow(
              AppLocalizations.of(context)!.fat,
              _calculatedFat,
              'g',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(
    String label,
    double numericValue,
    String unit,
    Color color,
  ) {
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
            duration: const Duration(milliseconds: 250),
            builder: (context, value, child) {
              final formatted =
                  value >= 10
                      ? value.toStringAsFixed(0)
                      : value.toStringAsFixed(1);
              return Text(
                '$formatted $unit',
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
            Text(
              AppLocalizations.of(context)!.portionSize,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.quantityInGrams,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                final numericValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
                setState(() {
                  _quantity = double.tryParse(numericValue) ?? 100.0;
                });
                _calculateNutrition();
              },
            ),
            const SizedBox(height: 16),
            // Show calculated summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.calories}: ${_calculatedCalories.toStringAsFixed(0)} kcal',
                ),
                Text(
                  '${AppLocalizations.of(context)!.protein}: ${_calculatedProtein.toStringAsFixed(0)} g',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.carbs}: ${_calculatedCarbs.toStringAsFixed(0)} g',
                ),
                Text(
                  '${AppLocalizations.of(context)!.fat}: ${_calculatedFat.toStringAsFixed(0)} g',
                ),
              ],
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
        Text(
          AppLocalizations.of(context)!.addToTodayLog,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Show the selected category
        Text(
          '${AppLocalizations.of(context)!.mealCategory}: ${widget.category}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () async {
            final newFoodId = await db.foodItemDao.insertFoodItem(
              FoodItemCompanion.insert(
                name: widget.foodItem.name,
                calories: _calculatedCalories.round(),
                protein: _calculatedProtein.round(),
                carbs: _calculatedCarbs.round(),
                fat: _calculatedFat.round(),
                gramm: Value(_quantity.round()),
              ),
            );
            final newFood = await db.foodItemDao.getFoodItemById(newFoodId);
            if (newFood != null) {
              await _repository.addFoodToMeal(widget.category, newFood);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${widget.foodItem.name} (${_quantity.round()}g) ${AppLocalizations.of(context)!.addedSuccessfully}',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.addToLog,
            style: const TextStyle(fontSize: 16),
          ),
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
