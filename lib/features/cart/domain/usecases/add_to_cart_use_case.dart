import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../product/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

@LazySingleton()
class AddToCartUseCase {
  final CartRepository cartRepository;

  AddToCartUseCase(this.cartRepository);

  Future<Either<Failure, void>> call(Product product, {int quantity = 1}) async {
    return await cartRepository.addToCart(product, quantity);
  }
}