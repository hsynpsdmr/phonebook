import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:phonebook/core/constants/api_constant.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();

  factory DioManager() {
    return _instance;
  }

  DioManager._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      headers: {
        'Accept': 'text/plain',
        'ApiKey': ApiConstant.apiKey,
      },
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 30000),
    ),
  );

  void addInterceptors(List<Interceptor> interceptors) {
    _dio.interceptors.addAll(interceptors);
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(url, data: data, options: Options(headers: headers));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> put(String url, {dynamic data, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(url, data: data, options: Options(headers: headers));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(url, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode! == 200) {
      final responseData = response.data;
      if (responseData is Map) {
        return responseData;
      } else if (responseData is String) {
        try {
          return jsonDecode(responseData);
        } on FormatException {
          log('Dio error: FormatException - $responseData');
        }
      } else {
        return responseData;
      }
    } else {
      log('Dio error: ${response.statusCode} - ${response.statusMessage}');
    }
  }

  dynamic _handleError(DioException error) {
    log('Dio error: ${error.message}', error: error.error, stackTrace: error.stackTrace);
    return error;
  }
}
