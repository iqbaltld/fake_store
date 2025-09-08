import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_store/core/error/failures.dart';
import 'package:fake_store/features/cart/domain/usecases/add_to_cart_use_case.dart';
import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  late AddToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(mockRepository);
  });

  group('AddToCartUseCase', () {
    test('should add product to cart via repository', () async {
      // arrange
      when(mockRepository.addToCart(testProduct, testQuantity))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase.call(testProduct, quantity: testQuantity);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.addToCart(testProduct, testQuantity));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure('Failed to add to cart');
      when(mockRepository.addToCart(testProduct, testQuantity))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase.call(testProduct, quantity: testQuantity);

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.addToCart(testProduct, testQuantity));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}