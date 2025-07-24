import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/data_sources/food_api.dart';
import '../../data/models/food_item_model.dart';
import '../../../../core/network/api_client.dart';
import 'food_detail_view.dart';
import 'dart:io' show Platform; // put inside a conditional import if needed

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

/// This widget is responsible for scanning barcodes using the mobile camera.
class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  bool _isHandlingBarcode = false;

  final MobileScannerController scannerController = MobileScannerController();
  final FoodApi foodApi = FoodApi(
    ApiClient(baseUrl: 'https://world.openfoodfacts.org/api/v2/'),
  );

  void _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isHandlingBarcode) return; // Prevent multiple triggers
    _isHandlingBarcode = true;

    final barcode = capture.barcodes.first.rawValue;

    if (barcode != null) {
      if (kDebugMode) {
        print('✅ Scanned barcode: $barcode');
      }

      try {
        FoodItemModel foodItem = await foodApi.fetchFoodByBarcode(barcode);
        String category = 'Breakfast';

        if (kDebugMode) {
          print('Food item fetched: ${foodItem.name}');
        }

        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) =>
                    FoodDetailsScreen(foodItem: foodItem, category: category),
          ),
        );

        // ✅ Allow scanning again once user returns
        _isHandlingBarcode = false;
      } catch (error) {
        if (kDebugMode) {
          print('❌ Error fetching food data: $error');
        }
        _isHandlingBarcode = false; // Allow re-scan on error
      }
    } else {
      _isHandlingBarcode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Barcode')),
        body: const Center(
          child: Text('Barcode scanning is only supported on mobile devices.'),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan Barcode')),
        body: MobileScanner(
          controller: scannerController,
          onDetect: _onBarcodeDetected,
        ),
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}
