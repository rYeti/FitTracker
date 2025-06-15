// lib/feature/presentation/view/food_add_screen.dart
import 'package:flutter/material.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'barcode_scanner_view.dart';
import 'food_search_screen.dart';
import 'food_detail_view.dart';
import '../../../lib/core/app_database.dart';

class FoodAddScreen extends StatefulWidget {
  final String category;

  const FoodAddScreen({super.key, required this.category});

  @override
  _FoodAddScreenState createState() => _FoodAddScreenState();
}

class _FoodAddScreenState extends State<FoodAddScreen> {
  final NutritionRepository _repository = NutritionRepository();
  List<FoodItemModel> _foodItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    setState(() => _isLoading = true);

    final items = await _repository.getFoodItemsForCategory(widget.category);
    debugPrint('Fetched items: ${items.length}');
    debugPrint('Loaded food add screen for category: ${widget.category}');

    setState(() {
      _foodItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase(); // Initialize the database

    return Scaffold(
      appBar: AppBar(title: const Text('Food Tracker')),
      body: StreamBuilder<List<FoodItemData>>(
        stream: db.foodItemDao.watchAllFoodItems(), // Listen for changes
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final foodItems = snapshot.data!;
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${item.calories} kcal | P: ${item.protein}g | C: ${item.carbs}g | F: ${item.fat}g',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await db.foodItemDao.deleteFoodItem(item); // Delete item
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} deleted!')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _scanBarcode() async {
    final FoodItemModel? scannedFood = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerView()),
    );

    if (scannedFood != null) {
      await _repository.addFoodToMeal(widget.category, scannedFood);
      _loadFoodItems();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${scannedFood.name} added to ${widget.category}'),
        ),
      );
    }
  }

  Future<void> _searchFoods() async {
    final FoodItemModel? selectedFood = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodSearchScreen(category: widget.category),
      ),
    );

    if (selectedFood != null) {
      await _repository.addFoodToMeal(widget.category, selectedFood);
      _loadFoodItems();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedFood.name} added to ${widget.category}'),
        ),
      );
    }
  }

  Future<void> _addCustomFood() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    final FoodItemModel? result = await showDialog<FoodItemModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Custom Food'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Food Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: caloriesController,
                    decoration: const InputDecoration(labelText: 'Calories'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter calories';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: proteinController,
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter protein content';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: carbsController,
                    decoration: const InputDecoration(labelText: 'Carbs (g)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter carbs content';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: fatController,
                    decoration: const InputDecoration(labelText: 'Fat (g)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter fat content';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final food = FoodItemCompanion.insert(
                    name: nameController.text,
                    calories: int.parse(caloriesController.text),
                    protein: int.parse(proteinController.text),
                    carbs: int.parse(carbsController.text),
                    fat: int.parse(fatController.text),
                  );

                  final db = AppDatabase(); // Initialize the database
                  await db.foodItemDao.insertFoodItem(food); // Save the food item

                  Navigator.of(context).pop(); // Close the screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name.value} added successfully!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await _repository.addFoodToMeal(widget.category, result);
      _loadFoodItems();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.name} added to ${widget.category}')),
      );
    }
  }
}
