import 'package:flutter/material.dart';
import '../../food_tracking/data/models/food_item_model.dart';

class FoodDetailsScreen extends StatelessWidget {
  final FoodItemModel foodItem;

  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' ${foodItem.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(" ${foodItem.calories} calories"),
            Text(" ${foodItem.protein}g protein"),
            Text(" ${foodItem.carbs}g carbs"),
            Text(" ${foodItem.fat}g fat"),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
