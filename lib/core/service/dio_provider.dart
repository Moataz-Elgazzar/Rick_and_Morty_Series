import 'package:dio/dio.dart';
import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';

class DioProvider {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(baseUrl: DioEndpoint.baseUrl, connectTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 5), sendTimeout: const Duration(seconds: 5), responseType: ResponseType.json, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}));
  }

  static get({required String path, Object? data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    return await dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
