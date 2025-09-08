import 'package:equatable/equatable.dart';
import 'package:fake_store/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/get_cart_items_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/get_cart_total_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';
part 'cart_state.dart';

@LazySingleton()
class CartCubit extends Cubit<CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetCartTotalUseCase getCartTotalUseCase;

  CartCubit(
    this.getCartItemsUseCase,
    this.addToCartUseCase,
    this.updateCartItemUseCase,
    this.removeFromCartUseCase,
    this.getCartTotalUseCase,
  ) : super(CartInitial());

  Future<void> loadCartItems() async {
    emit(CartLoading());
    
    final itemsResult = await getCartItemsUseCase();
    final totalResult = await getCartTotalUseCase();

    itemsResult.fold(
      (failure) => emit(CartError(message: failure.message)),
      (items) {
        totalResult.fold(
          (failure) => emit(CartError(message: failure.message)),
          (total) {
            final itemCount = items.fold<int>(0, (sum, item) => sum + item.quantity);
            emit(CartLoaded(
              items: items,
              total: total,
              itemCount: itemCount,
            ));
          },
        );
      },
    );
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final result = await addToCartUseCase(product, quantity: quantity);
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) => loadCartItems(),
    );
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final result = await updateCartItemUseCase(productId, quantity);
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) => loadCartItems(),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final result = await removeFromCartUseCase(productId);
    result.fold(
      (failure) => emit(CartError(message: failure.message)),
      (_) => loadCartItems(),
    );
  }

  Future<void> incrementQuantity(int productId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.items.firstWhere((item) => item.product.id == productId);
      await updateQuantity(productId, item.quantity + 1);
    }
  }

  Future<void> decrementQuantity(int productId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.items.firstWhere((item) => item.product.id == productId);
      if (item.quantity > 1) {
        await updateQuantity(productId, item.quantity - 1);
      } else {
        await removeFromCart(productId);
      }
    }
  }

  int getCartItemCount() {
    if (state is CartLoaded) {
      return (state as CartLoaded).itemCount;
    }
    return 0;
  }
}