import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String username, String password);
  Future<Either<Failure, User>> getUserDetails(int userId);
  Future<Either<Failure, void>> logout();
  Future<String?> getStoredToken();
  Future<bool> isLoggedIn();
}