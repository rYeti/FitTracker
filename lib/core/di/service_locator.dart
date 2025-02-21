import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../../feature/food_tracking/data/data_sources/food_api.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => ApiClient(Dio()));
  sl.registerLazySingleton(() => FoodApi(sl<ApiClient>()));
}
