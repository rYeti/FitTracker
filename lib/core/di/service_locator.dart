import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../feature/food_tracking/data/data_sources/food_api.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(
    () => ApiClient(baseUrl: 'https://world.openfoodfacts.org/api/v2/'),
  );
  sl.registerLazySingleton(() => FoodApi(sl<ApiClient>()));
}
