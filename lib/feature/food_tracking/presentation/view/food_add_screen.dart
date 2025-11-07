// lib/feature/presentation/view/food_add_screen.dart
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'barcode_scanner_view.dart';
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

  // Reuse the same meal localization approach as food_tracking_screen
  final Map<String, String Function(AppLocalizations)> _mealLabelGetters = {
    'Breakfast': (loc) => loc.mealBreakfast,
    'Lunch': (loc) => loc.mealLunch,
    'Dinner': (loc) => loc.mealDinner,
    'Snacks': (loc) => loc.mealSnacks,
  };

  String _localizedMealLabel(String category, BuildContext ctx) {
    final loc = AppLocalizations.of(ctx)!;
    final getter = _mealLabelGetters[category];
    return getter?.call(loc) ?? category;
  }

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
    _debounce = Timer(const Duration(milliseconds: 30), _performSearch);
  }

  // ---------- Fuzzy ranking helpers ----------
  String _norm(String s) => s.toLowerCase().trim();

  // Lightweight diacritic removal (extend as needed)
  String strip(String s) => s
      .replaceAll('ä', 'a')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u')
      .replaceAll('ß', 'ss');

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
    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }
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
    final qRaw = _norm(query);
    final nRaw = _norm(name);
    if (qRaw.isEmpty || nRaw.isEmpty) return 1 << 20;

    final q = strip(qRaw);
    final n = strip(nRaw);

    // Basic German stemming / synonym expansion
    String stem(String w) {
      if (w == 'eier') return 'ei';
      if (w.endsWith('en') && w.length > 4) return w.substring(0, w.length - 2);
      if (w.endsWith('er') && w.length > 4) return w.substring(0, w.length - 2);
      return w;
    }

    final tokens =
        n
            .split(RegExp(r'[^a-z0-9äöüß]+'))
            .where((t) => t.isNotEmpty)
            .map(stem)
            .toList();
    final sq = stem(q);

    // 0: exact token match or synonym
    if (tokens.contains(sq)) return 0;

    // 1: full name exact
    if (n == q) return 1;

    // Helper: Levenshtein distance (inline for fewer calls when needed)
    int lev(String a, String b) => _levenshtein(a, b);

    final bool veryShort = sq.length <= 2;

    // 2: first token prefix (boost first word relevance)
    final firstToken = tokens.isNotEmpty ? tokens.first : '';
    if (firstToken.startsWith(sq)) {
      int penalty = 2 + (firstToken.length - sq.length);
      if (veryShort && firstToken.length - sq.length >= 1) penalty += 2;
      return penalty;
    }

    // 3: any token prefix
    int bestPrefix = 9999;
    for (final t in tokens.skip(1)) {
      if (t.startsWith(sq)) {
        int penalty = 4 + (t.length - sq.length);
        if (veryShort) penalty += 3; // discourage ambiguous short prefixes
        if (penalty < bestPrefix) bestPrefix = penalty;
      }
    }
    if (bestPrefix != 9999) return bestPrefix;

    // 4: fuzzy token (small edit distance) for longer queries
    if (sq.length >= 3) {
      int bestFuzzy = 9999;
      for (final t in tokens) {
        final d = lev(t, sq);
        if (d <= 2) {
          // near match
          final fuzzyScore = 8 + d + (t.length - sq.length).abs();
          if (fuzzyScore < bestFuzzy) bestFuzzy = fuzzyScore;
        }
      }
      if (bestFuzzy != 9999) return bestFuzzy;
    }

    // 5: substring inside any token
    int bestSubstring = 9999;
    for (final t in tokens) {
      if (t.contains(sq)) {
        int penalty = 15 + (t.length - sq.length);
        if (penalty < bestSubstring) bestSubstring = penalty;
      }
    }
    if (bestSubstring != 9999) return bestSubstring;

    // 6: subsequence of whole name
    if (_isSubsequence(sq, n)) return 30;

    // 7: fallback global distance (ratio-based)
    final dist = lev(n, sq);
    final ratio = dist / n.length.clamp(1, 100);
    return 40 + (ratio * 100).round();
  }

  String _itemName(dynamic item) {
    if (item is Map) {
      for (final k in ['name', 'product_name', 'title', 'label']) {
        final v = item[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return '';
    }
    try {
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
      final results = await _repository.searchFoods(query);

      // Precompute scores to avoid recomputing in sort comparator
      final scoreCache = <dynamic, int>{};
      for (final r in results) {
        scoreCache[r] = _nameScore(query, _itemName(r));
      }

      results.sort((a, b) {
        final sa = scoreCache[a] ?? 1 << 20;
        final sb = scoreCache[b] ?? 1 << 20;
        if (sa != sb) return sa - sb;
        return _itemName(a).length.compareTo(_itemName(b).length);
      });

      setState(() {
        _searchResults = results.take(30).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.searchFailed(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // Helper to derive a display name from a scanned result (Map / FoodItemModel / DB row)
  String _displayNameFromScanned(dynamic scanned) {
    if (scanned == null) return 'Unknown';
    if (scanned is String) return scanned;
    if (scanned is Map) {
      return scanned['product_name']?.toString() ??
          scanned['name']?.toString() ??
          scanned['brands']?.toString() ??
          'Unknown';
    }
    try {
      // try common fields
      final name =
          (scanned.name ?? scanned.productName ?? scanned.product_name);
      if (name != null) return name.toString();
    } catch (_) {}
    return scanned.toString();
  }

  Future<void> _scanBarcode() async {
    // Accept any returned value from the BarcodeScannerView and handle safely.
    final dynamic scanned = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BarcodeScannerView(
              category: widget.category,
              isTemplate:
                  false, // Explicitly set to false for normal meal tracking
            ),
      ),
    );

    if (scanned == null) return;

    try {
      // Pass the scanned item to repository. Using dynamic here avoids a hard compile-time type assumption.
      await _repository.addFoodToMeal(widget.category, scanned);
      await _loadFoodItems();
      final name = _displayNameFromScanned(scanned);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${name} ${AppLocalizations.of(context)!.addedSuccessfully}',
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error adding scanned food to meal: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.addFailed}: ${e.toString()}',
          ),
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
          title: Text(AppLocalizations.of(context)!.addCustomFood),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.foodName,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterAName;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: caloriesController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.calories,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterCalories;
                      }
                      if (int.tryParse(value) == null) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: proteinController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.protein,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterAName;
                      }
                      if (int.tryParse(value) == null) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: carbsController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.carbs,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterAName;
                      }
                      if (int.tryParse(value) == null) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: fatController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.fat,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.pleaseEnterAName;
                      }
                      if (int.tryParse(value) == null) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterValidNumber;
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
              child: Text(AppLocalizations.of(context)!.cancel),
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
                        '${nameController.text} ${AppLocalizations.of(context)!.addedSuccessfully}',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            context,
          )!.addFood(_localizedMealLabel(widget.category, context)),
        ),
      ),
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
                        labelText: AppLocalizations.of(context)!.searchForFood,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt_rounded),
                          onPressed: _scanBarcode,
                          tooltip: AppLocalizations.of(context)!.scanBarcode,
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
                    AppLocalizations.of(context)!.recentlyAdded,
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
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
                            const NeverScrollableScrollPhysics(),
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
