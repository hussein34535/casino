import 'package:dio/dio.dart';
import 'package:game_show_app/core/constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final options = Options(headers: _authHeader(token));
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    String? token,
  }) async {
    final options = Options(headers: _authHeader(token));
    return await _dio.post(path, data: data, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    String? token,
  }) async {
    final options = Options(headers: _authHeader(token));
    return await _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(
    String path, {
    String? token,
  }) async {
    final options = Options(headers: _authHeader(token));
    return await _dio.delete(path, options: options);
  }

  Map<String, String>? _authHeader(String? token) {
    if (token == null) return null;
    return {'Authorization': 'Bearer $token'};
  }
}
