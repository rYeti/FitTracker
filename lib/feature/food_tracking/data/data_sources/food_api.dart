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
    return FoodItemModel.fromJson(response.data['product']);
  }
  
}
