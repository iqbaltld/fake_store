import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@LazySingleton()
class CheckAuthStatusUseCase {
  final AuthRepository authRepository;

  CheckAuthStatusUseCase(this.authRepository);

  Future<bool> call() async {
    return await authRepository.isLoggedIn();
  }
}