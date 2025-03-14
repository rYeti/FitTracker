import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient(this.dio);

  Future<Response> get(String path) async => await dio.get(path);
}
