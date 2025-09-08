import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../../../product/domain/entities/product.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Product product, int quantity);
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, int>> getCartItemCount();
  Future<Either<Failure, double>> getCartTotal();
}