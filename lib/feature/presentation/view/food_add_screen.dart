// lib/feature/presentation/view/food_add_screen.dart
import 'package:flutter/material.dart';
import '../../food_tracking/data/models/food_item_model.dart';
import '../../food_tracking/data/repositories/nutrition_repository.dart';
import 'barcode_scanner_view.dart';
import 'food_search_screen.dart';
import 'food_detail_view.dart';

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

    setState(() {
      _foodItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Foods")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child:
                        _foodItems.isEmpty
                            ? Center(
                              child: Text(
                                'No foods added to ${widget.category} yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _foodItems.length,
                              itemBuilder: (context, index) {
                                final food = _foodItems[index];
                                return ListTile(
                                  title: Text(food.name),
                                  subtitle: Text("${food.calories} kcal"),
                                  trailing: Text(
                                    "P: ${food.protein}g | C: ${food.carbs}g | F: ${food.fat}g",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FoodDetailsScreen(
                                              foodItem: food,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Scan Barcode"),
                            onPressed: _scanBarcode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text("Search Foods"),
                            onPressed: _searchFoods,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 24.0,
                    ),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Custom Food"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _addCustomFood,
                    ),
                  ),
                ],
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final food = FoodItemModel(
                    name: nameController.text,
                    calories: int.parse(caloriesController.text),
                    protein: double.parse(proteinController.text),
                    carbs: double.parse(carbsController.text),
                    fat: double.parse(fatController.text),
                  );
                  Navigator.of(context).pop(food);
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
