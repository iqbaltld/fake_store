import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';
import '../network/network_info.dart';

abstract class BaseRepository {
  /// Handles network calls with standard error handling
  ///
  /// For methods that return a value, provide both [call] and [onSuccess].
  /// For void methods, you can omit [onSuccess] and it will return Right(unit).
  Future<Either<Failure, T>> handleApiCall<T>({
    required Future<dynamic> Function() call,
    T Function(dynamic)? onSuccess,
    String? context,
  });
}

/// Implementation of [BaseRepository]
@Injectable(as: BaseRepository)
class BaseRepositoryImpl implements BaseRepository {
  final NetworkInfo _networkInfo;

  BaseRepositoryImpl({
    required NetworkInfo networkInfo,
  }) : _networkInfo = networkInfo;

  @override
  Future<Either<Failure, T>> handleApiCall<T>({
    required Future<dynamic> Function() call,
    T Function(dynamic)? onSuccess,
    String? context,
  }) async {
    // Check network connectivity
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await call();

      // Handle success
      if (onSuccess == null) {
        // For void operations, return unit if T is Unit
        if (T.toString() == 'Unit') {
          return Right(unit as T);
        }
        throw Exception('onSuccess callback required for non-void operations');
      }

      return Right(onSuccess(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred: ${e.toString()}'));
    }
  }
}