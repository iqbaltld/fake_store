import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../product/data/models/product_model.dart';
import '../../../product/domain/entities/product.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource cartLocalDataSource;

  CartRepositoryImpl(this.cartLocalDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await cartLocalDataSource.getCartItems();
      return Right(cartItems);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(Product product, int quantity) async {
    try {
      final currentItems = await cartLocalDataSource.getCartItems();
      
      // Check if product already exists in cart
      final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);
      
      if (existingIndex != -1) {
        // Update quantity if product exists
        currentItems[existingIndex] = CartItemModel(
          product: currentItems[existingIndex].product,
          quantity: currentItems[existingIndex].quantity + quantity,
        );
      } else {
        // Add new item if product doesn't exist
        currentItems.add(CartItemModel(
          product: product as ProductModel,
          quantity: quantity,
        ));
      }

      await cartLocalDataSource.saveCartItems(currentItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity) async {
    try {
      final currentItems = await cartLocalDataSource.getCartItems();
      final index = currentItems.indexWhere((item) => item.product.id == productId);
      
      if (index != -1) {
        if (quantity <= 0) {
          currentItems.removeAt(index);
        } else {
          currentItems[index] = CartItemModel(
            product: currentItems[index].product,
            quantity: quantity,
          );
        }
        
        await cartLocalDataSource.saveCartItems(currentItems);
      }
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      final currentItems = await cartLocalDataSource.getCartItems();
      currentItems.removeWhere((item) => item.product.id == productId);
      
      await cartLocalDataSource.saveCartItems(currentItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await cartLocalDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, int>> getCartItemCount() async {
    try {
      final cartItems = await cartLocalDataSource.getCartItems();
      final totalCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
      return Right(totalCount);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }

  @override
  Future<Either<Failure, double>> getCartTotal() async {
    try {
      final cartItems = await cartLocalDataSource.getCartItems();
      final total = cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unknown error occurred'));
    }
  }
}