import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../error/exceptions.dart';

/// Interface for API operations
abstract class ApiManager {
  /// Performs a GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  /// Performs a POST request
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });
}

@LazySingleton(as: ApiManager)
class ApiManagerImpl implements ApiManager {
  final Dio _dio;

  ApiManagerImpl(this._dio);

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _makeRequest<T>(
      () => _dio.get(path, queryParameters: queryParams, options: options),
      fromJson: fromJson,
      debugInfo: 'GET $path',
    );
  }

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _makeRequest<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      ),
      fromJson: fromJson,
      debugInfo: 'POST $path',
    );
  }

  Future<T> _makeRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromJson,
    required String debugInfo,
  }) async {
    try {
      // Log request in debug mode
      if (kDebugMode) {
        print('🟡 API REQUEST: $debugInfo');
      }

      final response = await request();

      // Log successful response in debug mode
      if (kDebugMode) {
        print('🟢 API SUCCESS: $debugInfo - Status: ${response.statusCode}');
      }

      return _handleResponse<T>(response, fromJson: fromJson);
    } on DioException catch (e) {
      // Log error in debug mode
      if (kDebugMode) {
        print('🔴 API ERROR in $debugInfo: ${e.message}');
      }
      _handleDioError(e);
    } catch (e) {
      // Log unexpected errors
      if (kDebugMode) {
        print('🔴 UNEXPECTED ERROR in $debugInfo: $e');
      }
      throw ServerException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  T _handleResponse<T>(Response response, {T Function(dynamic)? fromJson}) {
    if (response.statusCode! < 200 || response.statusCode! >= 300) {
      throw ServerException(
        message: 'Request failed with status: ${response.statusCode}',
      );
    }

    final responseData = response.data;

    // Handle direct type match
    if (responseData is T) return responseData;

    // Use fromJson if provided
    if (fromJson != null) {
      return fromJson(responseData);
    }

    // Direct cast as fallback
    return responseData as T;
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw NetworkException(message: 'Network timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NetworkException(message: 'Connection error');
    } else {
      final message = e.response?.data?['message'] ?? 'Server error occurred';
      throw ServerException(message: message);
    }
  }
}