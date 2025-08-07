// lib/feature/presentation/view/food_add_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'barcode_scanner_view.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'food_detail_view.dart';

class FoodAddScreen extends StatefulWidget {
  final String category;

  const FoodAddScreen({super.key, required this.category});

  @override
  _FoodAddScreenState createState() => _FoodAddScreenState();
}

class _FoodAddScreenState extends State<FoodAddScreen> {
  late final AppDatabase db;
  late final NutritionRepository _repository;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _repository = NutritionRepository(db);
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    // No-op: kept for future use if needed
  }

  Future<void> _scanBarcode() async {
    final FoodItemData? scannedFood = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerView(category: widget.category),
      ),
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

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isSearching = true;
        _searchResults = [];
      });
    }

    try {
      final response = await Dio().get(
        'https://world.openfoodfacts.org/cgi/search.pl',
        queryParameters: {
          'search_terms': query,
          'search_simple': 1,
          'action': 'process',
          'json': 1,
          'page_size': 20,
        },
      );

      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = response.data['products'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _selectFoodItem(Map<String, dynamic> productData) async {
    final foodItem = FoodItemModel(
      id: int.tryParse(productData['id']?.toString() ?? '') ?? 0,
      name: productData['product_name'] ?? productData['brands'] ?? 'Unknown',
      calories:
          (productData['nutriments']?['energy-kcal_100g'] as num?)?.toInt() ??
          0,
      protein:
          (productData['nutriments']?['proteins_100g'] as num?)?.round() ?? 0,
      carbs:
          (productData['nutriments']?['carbohydrates_100g'] as num?)?.round() ??
          0,
      fat: (productData['nutriments']?['fat_100g'] as num?)?.round() ?? 0,
      gramm: 100,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FoodDetailsScreen(
              foodItem: foodItem,
              category: widget.category,
            ),
      ),
    );
  }

  Future<void> _addCustomFood() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    await showDialog(
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
                      if (int.tryParse(value) == null) {
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
                  final db = AppDatabase();
                  await db.foodItemDao.insertFoodItem(food);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${nameController.text} added successfully!',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    return Scaffold(
      appBar: AppBar(title: Text('Add Food - ${widget.category}')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search for food',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt_rounded),
                          onPressed: _scanBarcode,
                          tooltip: 'Scan Barcode',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        _performSearch();
                      },
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                ),
              ],
            ),
            if (_searchController.text.isEmpty && !_isSearching) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recently Added',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            Builder(
              builder: (context) {
                if (_isSearching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!_isSearching && _searchController.text.isNotEmpty) {
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          title: Text(result['product_name'] ?? 'Unknown'),
                          subtitle: Text(result['brands'] ?? 'Generic'),
                          onTap: () {
                            _selectFoodItem(result);
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 400,
                    child: StreamBuilder<List<FoodItemData>>(
                      stream: db.foodItemDao.watchAllFoodItems(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final foodItems = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: foodItems.length,
                          itemBuilder: (context, index) {
                            final item = foodItems[index];
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                '${item.calories} kcal | P: ${item.protein}g | C: ${item.carbs}g | F: ${item.fat}g',
                              ),
                              onTap: () {
                                final foodModel = FoodItemModel(
                                  id: item.id,
                                  name: item.name,
                                  calories: item.calories,
                                  protein: item.protein,
                                  carbs: item.carbs,
                                  fat: item.fat,
                                  gramm: item.gramm,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => FoodDetailsScreen(
                                          foodItem: foodModel,
                                          category: widget.category,
                                        ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${item.name} added to recent foods',
                                      ),
                                    ),
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
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomFood,
        child: const Icon(Icons.add),
      ),
    );
  }
}
