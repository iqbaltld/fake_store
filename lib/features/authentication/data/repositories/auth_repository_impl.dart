import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({
    required this.authDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, String>> login(String username, String password) async {
    final result = await handleApiCall<String>(
      call: () => authDataSource.login(username, password),
      onSuccess: (token) => token as String,
      context: 'login',
    );

    return result.fold(
      (failure) => Left(failure),
      (token) async {
        try {
          await authDataSource.saveToken(token);
          return Right(token);
        } on CacheException catch (e) {
          return Left(CacheFailure(e.message));
        } catch (e) {
          return Left(UnknownFailure('Failed to save token: ${e.toString()}'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, User>> getUserDetails(int userId) async {
    return handleApiCall<User>(
      call: () => authDataSource.getUserDetails(userId),
      onSuccess: (user) => user as User,
      context: 'get user details',
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDataSource.clearToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to clear token: ${e.toString()}'));
    }
  }

  @override
  Future<String?> getStoredToken() async {
    try {
      return await authDataSource.getToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await authDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}