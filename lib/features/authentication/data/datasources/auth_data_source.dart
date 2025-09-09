import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_manager.dart';
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
  final ApiManager _apiManager;
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';

  AuthDataSourceImpl(this._apiManager, this.sharedPreferences);

  @override
  Future<String> login(String username, String password) async {
    final loginResponse = await _apiManager.post<LoginResponseModel>(
      ApiUrls.login,
      data: {
        'username': username,
        'password': password,
      },
      fromJson: (data) => LoginResponseModel.fromJson(data),
    );
    return loginResponse.token;
  }

  @override
  Future<UserModel> getUserDetails(int userId) async {
    return _apiManager.get<UserModel>(
      '${ApiUrls.user}/$userId',
      fromJson: (data) => UserModel.fromJson(data),
    );
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