import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

@LazySingleton()
class GetCartTotalUseCase {
  final CartRepository cartRepository;

  GetCartTotalUseCase(this.cartRepository);

  Future<Either<Failure, double>> call() async {
    return await cartRepository.getCartTotal();
  }
}