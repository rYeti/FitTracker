// lib/feature/presentation/view/food_search_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../food_tracking/data/models/food_item_model.dart';

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
    return Scaffold(
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
    // Convert to FoodItemModel
    final foodItem = FoodItemModel.fromJson(productData);

    // Return to previous screen with selected food
    Navigator.pop(context, foodItem);
  }
}
