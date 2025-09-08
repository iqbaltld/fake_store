import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<String> login(String username, String password);
  Future<UserModel> getUserDetails(int userId);
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';

  AuthDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        ApiUrls.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginResponse = LoginResponseModel.fromJson(response.data);
        return loginResponse.token;
      } else {
        throw ServerException(message: 'Login failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: 'Network timeout');
      } else if (e.response?.statusCode == 401) {
        throw ServerException(message: 'Invalid username or password');
      } else {
        throw ServerException(
          message: e.response?.data?['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      throw ServerException(message: 'Unknown error occurred');
    }
  }

  @override
  Future<UserModel> getUserDetails(int userId) async {
    try {
      final response = await dio.get('${ApiUrls.user}/$userId');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed to get user details');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(message: 'Network timeout');
      } else {
        throw ServerException(
          message: e.response?.data?['message'] ?? 'Failed to get user details',
        );
      }
    } catch (e) {
      throw ServerException(message: 'Unknown error occurred');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await sharedPreferences.setString(_tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(_tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear token');
    }
  }
}