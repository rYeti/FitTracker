// lib/feature/presentation/view/food_search_screen.dart
import 'package:fittnes_tracker/feature/food_tracking/presentation/view/food_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/models/food_item_model.dart';

class FoodSearchScreen extends StatefulWidget {
  final String category;

  const FoodSearchScreen({super.key, required this.category});

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Add Food to ${widget.category}')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search for food',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _performSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
            _isSearching
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child: ListView.builder(
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
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

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

      setState(() {
        _isSearching = false;
        _searchResults = response.data['products'];
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _selectFoodItem(Map<String, dynamic> productData) {
    final foodItem = FoodItemModel(
      id: productData['id'] ?? 0,
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
      gramm: 100, // Default to 100g if not present
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
}
