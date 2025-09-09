import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_store/core/constants/storage_keys.dart';
import 'package:fake_store/core/services/navigation_service/navigation_service.dart';
import 'package:fake_store/features/authentication/presentation/screens/login_screen.dart';

class CustomInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  final NavigationService _navigationService;

  CustomInterceptor(
    this._prefs,
    this._navigationService,
  );

  /// List of endpoints that don't require authentication
  final _publicEndpoints = [
    '/auth/login',
  ];

  /// Maximum number of retries for network failures
  static const int _maxRetries = 3;
  
  /// Delay between retries (in milliseconds)
  static const List<int> _retryDelays = [1000, 2000, 4000];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token check for public endpoints
    if (!_isPublicEndpoint(options.path)) {
      final token = _prefs.getString(StorageKeys.token);
      
      if (token == null || token.isEmpty) {
        _handleUnauthenticated();
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'No authentication token found',
          ),
        );
      }

      // Add authorization header
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response: ${response.statusCode} - ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    log('Error: ${err.response?.statusCode} - ${err.requestOptions.path}');

    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      _handleUnauthenticated();
      return handler.next(err);
    }

    // Handle network failures with retry logic
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < _maxRetries) {
        log('Retrying request (attempt ${retryCount + 1}/$_maxRetries): ${err.requestOptions.path}');
        
        try {
          final response = await _retryRequest(err.requestOptions, retryCount);
          return handler.resolve(response);
        } catch (retryError) {
          // If retry also fails, continue with original error handling
          log('Retry failed: $retryError');
        }
      } else {
        log('Max retries exceeded for: ${err.requestOptions.path}');
      }
    }
    
    // Pass through other errors
    return handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    return _publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  bool _shouldRetry(DioException err) {
    // Retry on network errors, timeouts, and 5xx server errors
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           err.error is SocketException ||
           (err.response?.statusCode != null && 
            err.response!.statusCode! >= 500);
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions, 
    int retryCount,
  ) async {
    // Wait before retrying
    if (retryCount < _retryDelays.length) {
      await Future.delayed(Duration(milliseconds: _retryDelays[retryCount]));
    }

    // Update retry count
    final newOptions = requestOptions.copyWith();
    newOptions.extra['retryCount'] = retryCount + 1;

    // Create a separate Dio instance for retry to avoid circular dependency
    final retryDio = Dio(BaseOptions(
      baseUrl: requestOptions.baseUrl,
      connectTimeout: requestOptions.connectTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    ));

    // Retry the request
    return retryDio.request<dynamic>(
      newOptions.path,
      data: newOptions.data,
      queryParameters: newOptions.queryParameters,
      options: Options(
        method: newOptions.method,
        headers: newOptions.headers,
        responseType: newOptions.responseType,
        contentType: newOptions.contentType,
        receiveTimeout: newOptions.receiveTimeout,
        sendTimeout: newOptions.sendTimeout,
        extra: newOptions.extra,
      ),
    );
  }

  void _handleUnauthenticated() async {
    // Clear tokens
    await _prefs.remove(StorageKeys.token);
    
    // Get current route and login route
    final currentRoute = _navigationService.currentRoute;
    final loginRoute = LoginScreen.routeName.replaceAll('/', '');
    
    // Log the current state for debugging
    log('Current Route: $currentRoute');
    log('Login Screen Route: $loginRoute');
    
    // If we're not on the login screen, navigate to login
    if (currentRoute == null || !currentRoute.endsWith(loginRoute)) {
      log('Navigating to login screen');
      // Use a small delay to ensure any ongoing navigation completes
      await Future.delayed(const Duration(milliseconds: 100));
      _navigationService.navigateAndClearStack(LoginScreen.routeName);
    }
  }
}