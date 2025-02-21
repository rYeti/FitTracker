import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'feature/presentation/view/barcode_scanner_view.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final scannedBarcode = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BarcodeScannerView(),
              ),
            );
            print('Scanned barcode: $scannedBarcode');
          },
          child: const Text('Scan Barcode'),
        ),
      ),
    );
  }
}
