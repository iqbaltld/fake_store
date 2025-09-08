import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

@LazySingleton()
class RemoveFromCartUseCase {
  final CartRepository cartRepository;

  RemoveFromCartUseCase(this.cartRepository);

  Future<Either<Failure, void>> call(int productId) async {
    return await cartRepository.removeFromCart(productId);
  }
}