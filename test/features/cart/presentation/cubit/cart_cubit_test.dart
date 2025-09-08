import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_store/core/error/failures.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  late CartCubit cartCubit;
  late MockGetCartItemsUseCase mockGetCartItemsUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
  late MockUpdateCartItemUseCase mockUpdateCartItemUseCase;
  late MockGetCartTotalUseCase mockGetCartTotalUseCase;

  setUp(() {
    mockGetCartItemsUseCase = MockGetCartItemsUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockRemoveFromCartUseCase = MockRemoveFromCartUseCase();
    mockUpdateCartItemUseCase = MockUpdateCartItemUseCase();
    mockGetCartTotalUseCase = MockGetCartTotalUseCase();
    
    cartCubit = CartCubit(
      mockGetCartItemsUseCase,
      mockAddToCartUseCase,
      mockUpdateCartItemUseCase,
      mockRemoveFromCartUseCase,
      mockGetCartTotalUseCase,
    );
  });

  test('initial state should be CartInitial', () {
    expect(cartCubit.state, CartInitial());
  });

  group('loadCartItems', () {
    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartLoaded] when cart items are loaded successfully',
      build: () {
        when(mockGetCartItemsUseCase.call())
            .thenAnswer((_) async => const Right(testCartItems));
        when(mockGetCartTotalUseCase.call())
            .thenAnswer((_) async => const Right(242.2));
        return cartCubit;
      },
      act: (cubit) => cubit.loadCartItems(),
      expect: () => [
        CartLoading(),
        const CartLoaded(
          items: testCartItems,
          total: 242.2,
          itemCount: 3,
        ),
      ],
      verify: (cubit) {
        verify(mockGetCartItemsUseCase.call());
        verify(mockGetCartTotalUseCase.call());
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartError] when loading cart items fails',
      build: () {
        const failure = CacheFailure('Cache Error');
        when(mockGetCartItemsUseCase.call())
            .thenAnswer((_) async => const Left(failure));
        return cartCubit;
      },
      act: (cubit) => cubit.loadCartItems(),
      expect: () => [
        CartLoading(),
        const CartError(message: 'Cache Error'),
      ],
      verify: (cubit) {
        verify(mockGetCartItemsUseCase.call());
      },
    );
  });

  group('addToCart', () {
    blocTest<CartCubit, CartState>(
      'emits [CartLoaded] when product is added to cart successfully',
      build: () {
        when(mockAddToCartUseCase.call(testProduct, quantity: testQuantity))
            .thenAnswer((_) async => const Right(null));
        when(mockGetCartItemsUseCase.call())
            .thenAnswer((_) async => const Right(testCartItems));
        when(mockGetCartTotalUseCase.call())
            .thenAnswer((_) async => const Right(242.2));
        return cartCubit;
      },
      act: (cubit) => cubit.addToCart(testProduct, quantity: testQuantity),
      expect: () => [
        const CartLoaded(
          items: testCartItems,
          total: 242.2,
          itemCount: 3,
        ),
      ],
      verify: (cubit) {
        verify(mockAddToCartUseCase.call(testProduct, quantity: testQuantity));
        verify(mockGetCartItemsUseCase.call());
        verify(mockGetCartTotalUseCase.call());
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [CartError] when adding to cart fails',
      build: () {
        const failure = CacheFailure('Failed to add to cart');
        when(mockAddToCartUseCase.call(testProduct, quantity: testQuantity))
            .thenAnswer((_) async => const Left(failure));
        return cartCubit;
      },
      act: (cubit) => cubit.addToCart(testProduct, quantity: testQuantity),
      expect: () => [
        const CartError(message: 'Failed to add to cart'),
      ],
      verify: (cubit) {
        verify(mockAddToCartUseCase.call(testProduct, quantity: testQuantity));
      },
    );
  });

  tearDown(() {
    cartCubit.close();
  });
}