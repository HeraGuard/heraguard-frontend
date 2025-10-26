import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        //baseUrl: 'http://5.5.5.39:5181/api',
        baseUrl: 'https://heraguard-backend.onrender.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      print('Error en API: $e');
      rethrow;
    }
  }
}
