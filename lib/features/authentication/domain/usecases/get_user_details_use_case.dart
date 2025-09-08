import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@LazySingleton()
class GetUserDetailsUseCase {
  final AuthRepository authRepository;

  GetUserDetailsUseCase(this.authRepository);

  Future<Either<Failure, User>> call(int userId) async {
    return await authRepository.getUserDetails(userId);
  }
}