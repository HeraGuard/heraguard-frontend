import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        //baseUrl: 'https://heraguard-backend.onrender.com',
        baseUrl:
            'https://heraguard-hahfe0h7h5bcg0dh.canadacentral-01.azurewebsites.net',
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
      print('Error en POST API: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(
        path,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      print('Error en PUT API: $e');
      rethrow;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      print('Error en GET API: $e');
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(
        path,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      print('Error en DELETE API: $e');
      rethrow;
    }
  }
}
