import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'params/login_params.dart';

@LazySingleton()
class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, String>> call(LoginParams params) async {
    return await authRepository.login(params.username, params.password);
  }
}