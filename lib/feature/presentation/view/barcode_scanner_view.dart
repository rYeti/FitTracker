import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fittnes_tracker/feature/presentation/view/food_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../food_tracking/data/models/food_item_model.dart';
import '../../food_tracking/data/data_sources/food_api.dart';
import '../../../../core/network/api_client.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final MobileScannerController scannerController = MobileScannerController();
  final FoodApi foodApi = FoodApi(ApiClient(Dio()));

  void _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = capture.barcodes.first.rawValue;

    if (barcode != null) {
      print('✅ Scanned barcode: $barcode');

      try {
        // Fetch food item from API
        FoodItemModel foodItem = await foodApi.fetchFoodByBarcode(barcode);

        if (foodItem != null) {
          final food = await foodItem;

          // Choose the category (for now, you can hardcode it as 'Breakfast')
          String category = 'Breakfast';

          // Save the food item to SharedPreferences
          await FoodPreferences.saveFoodItem(category, food);
          print('Food item saved: ' + food.name);
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(foodItem: foodItem),
          ),
        );
      } catch (error) {
        print('❌ Error fetching food data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: scannerController,
        onDetect: _onBarcodeDetected,
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}
