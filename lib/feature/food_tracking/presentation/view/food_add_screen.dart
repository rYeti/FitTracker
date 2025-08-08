// lib/feature/presentation/view/food_add_screen.dart
import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // remove, repo handles Dio internally
import 'dart:async';
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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _repository = NutritionRepository(db); // fix: pass only db
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce user input
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _performSearch);
  }

  // ---------- Fuzzy ranking helpers ----------
  String _norm(String s) => s.toLowerCase().trim();

  bool _isSubsequence(String q, String s) {
    var i = 0, j = 0;
    while (i < q.length && j < s.length) {
      if (q.codeUnitAt(i) == s.codeUnitAt(j)) i++;
      j++;
    }
    return i == q.length;
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final m = a.length, n = b.length;
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) dp[i][0] = i;
    for (var j = 0; j <= n; j++) dp[0][j] = j;
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1, // deletion
          dp[i][j - 1] + 1, // insertion
          dp[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[m][n];
  }

  int _nameScore(String query, String name) {
    final q = _norm(query);
    final n = _norm(name);
    if (n.isEmpty || q.isEmpty) return 1 << 20;

    if (n == q) return 0; // exact match
    if (n.startsWith(q)) return 1; // prefix
    if (n.contains(q)) return 2; // substring
    if (_isSubsequence(q, n)) return 3; // subsequence
    return 10 + _levenshtein(n, q); // fallback
  }

  String _itemName(dynamic item) {
    // Try common keys when results are Maps from an API, else drift row
    if (item is Map) {
      for (final k in ['name', 'product_name', 'title', 'label']) {
        final v = item[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return '';
    }
    // If using Drift data class:
    // if (item is FoodItemData) return item.name;
    try {
      // last-resort reflection-like access
      // ignore: avoid_dynamic_calls
      final v = item.name;
      return v?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    try {
      final results = await _repository.searchFoods(query); // now exists

      // Rank by fuzzy score, then by shorter name
      results.sort((a, b) {
        final sa = _nameScore(query, _itemName(a));
        final sb = _nameScore(query, _itemName(b));
        if (sa != sb) return sa - sb;
        return _itemName(a).length.compareTo(_itemName(b).length);
      });

      setState(() {
        _searchResults = results.take(30).toList(); // limit to top-N
      });
    } catch (e) {
      // Optional: show an error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
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

  Future<void> _loadFoodItems() async {
    // No-op: kept for future use if needed
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
    // final db = AppDatabase(); // remove extra instance
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
                  // REMOVE the SizedBox(height: 400)
                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // parent scrolls
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        title: Text(result['product_name'] ?? 'Unknown'),
                        subtitle: Text(result['brands'] ?? 'Generic'),
                        onTap: () => _selectFoodItem(result),
                      );
                    },
                  );
                } else {
                  // REMOVE the SizedBox(height: 400)
                  return StreamBuilder<List<FoodItemData>>(
                    stream: db.foodItemDao.watchAllFoodItems(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final foodItems = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // parent scrolls
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
                              onPressed: () {
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
