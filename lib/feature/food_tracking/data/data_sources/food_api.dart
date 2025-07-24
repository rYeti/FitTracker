import '../../../../core/network/api_client.dart';
import '../models/food_item_model.dart';

class FoodApi {
  final ApiClient apiClient;

  FoodApi(this.apiClient);

  Future<FoodItemModel> fetchFoodByBarcode(String barcode) async {
    final response = await apiClient.get(
      'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch food item');
    }
    final product = response.data['product'];
    return FoodItemModel(
      id: product['id'] ?? 0,
      name: product['product_name'] ?? product['brands'] ?? 'Unknown',
      calories: (product['nutriments']?['energy-kcal'] as num?)?.toInt() ?? 0,
      protein: (product['nutriments']?['proteins_100g'] as num?)?.round() ?? 0,
      carbs:
          (product['nutriments']?['carbohydrates_100g'] as num?)?.round() ?? 0,
      fat: (product['nutriments']?['fat_100g'] as num?)?.round() ?? 0,
      gramm: 100, // Default to 100g if not present
    );
  }
}
