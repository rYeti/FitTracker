import 'package:fittnes_tracker/feature/food_tracking/data/repositories/shared_prefs_food_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/data_sources/food_api.dart';
import '../../data/models/food_item_model.dart';
import '../../../../core/network/api_client.dart';
import 'food_detail_view.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

/// This widget is responsible for scanning barcodes using the mobile camera.
class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final MobileScannerController scannerController = MobileScannerController();
  final FoodApi foodApi = FoodApi(
    ApiClient(baseUrl: 'https://world.openfoodfacts.org/api/v2/'),
  );

  void _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = capture.barcodes.first.rawValue;

    if (barcode != null) {
      print('✅ Scanned barcode: $barcode');

      try {
        // Fetch food item from API
        FoodItemModel foodItem = await foodApi.fetchFoodByBarcode(barcode);

        final food = await foodItem;

        // Choose the category (for now, you can hardcode it as 'Breakfast')
        String category = 'Breakfast';

        // Save the food item to SharedPreferences
        await FoodPreferences.saveFoodItem(category, food);
        print('Food item saved: ' + food.name);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) =>
                    FoodDetailsScreen(foodItem: foodItem, category: category),
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
