import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../food_tracking/data/data_sources/food_api.dart';
import '../../../../core/network/api_client.dart';
import '../../food_tracking/data/models/food_item_model.dart';
import 'barcode_scanner_view.dart';

class FoodAddScreen extends StatefulWidget {
  final String category;

  const FoodAddScreen({super.key, required this.category});

  @override
  _FoodAddScreenState createState() => _FoodAddScreenState();
}

class _FoodAddScreenState extends State<FoodAddScreen> {
  List<FoodItemModel> foodItems = [];

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? foodList = prefs.getStringList(widget.category);

    if (foodList != null) {
      setState(() {
        foodItems =
            foodList
                .map(
                  (item) => FoodItemModel.fromJson(jsonDecode(item)),
                ) // Decode JSON
                .toList();
      });
    }
  }

  Future<void> _saveFoodItem(FoodItemModel foodItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> foodList = prefs.getStringList(widget.category) ?? [];

    // Convert food item to JSON string before saving
    foodList.add(jsonEncode(foodItem.toJson()));

    await prefs.setStringList(widget.category, foodList);

    // Refresh the UI
    _loadFoodItems();
  }

  Future<void> _scanBarcode() async {
    final FoodApi foodApi = FoodApi(ApiClient(Dio()));
    final String? scannedBarcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerView()),
    );

    if (scannedBarcode != null) {
      // Fetch food data from API (make sure this function exists in your BarcodeScannerView)
      FoodItemModel? foodItem = await foodApi.fetchFoodByBarcode(
        scannedBarcode,
      );

      if (foodItem != null) {
        _saveFoodItem(foodItem); // Save the scanned food item
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Food not found.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Food to ${widget.category}")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text("${food.calories} kcal"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              25,
            ), // Add some padding around the button
            child: ElevatedButton(
              onPressed: _scanBarcode,
              child: const Text("Scan Barcode"),
            ),
          ),
        ],
      ),
    );
  }
}
