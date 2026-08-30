import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_exception.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ),
);

class BaseHttp {
  static String get baseUrl => dotenv.env['base_url'] ?? '';
  static String get apiKey => dotenv.env['api_key'] ?? '';
  static String get accessToken => (dotenv.env['api_read_access_token'] ?? '').trim();

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final params = <String, dynamic>{...queryParameters ?? {}};
    if (accessToken.isEmpty && apiKey.isNotEmpty) {
      params['api_key'] = apiKey;
    }

    try {
      log('Request URL : ${_buildUrl(path)}');
      log('Request Headers : ${_headers}');
      final response = await dio.get(
        _buildUrl(path),
        queryParameters: params,
        options: Options(headers: _headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _buildUrl(String path) {
    final cleanBase = baseUrl.trim();
    final cleanPath = path.startsWith('/') ? path : '/$path';
    if (cleanBase.isEmpty) {
      return path;
    }
    return '$cleanBase$cleanPath';
  }

  Map<String, dynamic> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
      };

  dynamic _handleResponse(Response response) {
    if (response.statusCode == null) {
      throw const FetchDataException(message: 'No status code received');
    }

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      log('Response Data : ${response.data}');
      return response.data;
    }

    if (response.statusCode == 401) {
      throw const UnAuthorizedException();
    }

    if (response.statusCode! >= 400 && response.statusCode! < 500) {
      throw InvalidRequestException(
        message: response.data?['message'] ?? 'Invalid request',
      );
    }

    throw FetchDataException(
      message: response.data?['message'] ?? 'Server error',
    );
  }

  AppException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const FetchDataException(message: 'Connection timeout');
    }

    if (error.type == DioExceptionType.badResponse) {
      if (error.response?.statusCode == 401) {
        return const UnAuthorizedException();
      }
      return FetchDataException(
        message: error.response?.data?['message'] ?? 'Network error',
      );
    }

    if (error.type == DioExceptionType.cancel) {
      return const FetchDataException(message: 'Request cancelled');
    }

    return FetchDataException(
      message: error.message ?? 'Unknown error occurred',
    );
  }
}