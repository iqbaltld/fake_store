import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

@LazySingleton()
class UpdateCartItemUseCase {
  final CartRepository cartRepository;

  UpdateCartItemUseCase(this.cartRepository);

  Future<Either<Failure, void>> call(int productId, int quantity) async {
    return await cartRepository.updateCartItem(productId, quantity);
  }
}