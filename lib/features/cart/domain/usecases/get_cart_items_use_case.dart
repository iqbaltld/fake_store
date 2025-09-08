import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

@LazySingleton()
class GetCartItemsUseCase {
  final CartRepository cartRepository;

  GetCartItemsUseCase(this.cartRepository);

  Future<Either<Failure, List<CartItem>>> call() async {
    return await cartRepository.getCartItems();
  }
}