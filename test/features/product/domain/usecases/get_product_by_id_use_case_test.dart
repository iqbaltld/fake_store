import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_store/core/error/failures.dart';
import 'package:fake_store/features/product/domain/usecases/get_product_by_id_use_case.dart';
import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  late GetProductByIdUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductByIdUseCase(mockRepository);
  });

  group('GetProductByIdUseCase', () {
    test('should get product by id from the repository', () async {
      // arrange
      when(mockRepository.getProductById(testProductId))
          .thenAnswer((_) async => const Right(testProduct));

      // act
      final result = await useCase.call(testProductId);

      // assert
      expect(result, const Right(testProduct));
      verify(mockRepository.getProductById(testProductId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure('Server Error');
      when(mockRepository.getProductById(testProductId))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase.call(testProductId);

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.getProductById(testProductId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when product not found', () async {
      // arrange
      const failure = ServerFailure('Product not found');
      const invalidId = 999;
      when(mockRepository.getProductById(invalidId))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase.call(invalidId);

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.getProductById(invalidId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}