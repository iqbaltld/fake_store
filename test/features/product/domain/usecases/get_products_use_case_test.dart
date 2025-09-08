import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_store/core/error/failures.dart';
import 'package:fake_store/features/product/domain/usecases/get_products_use_case.dart';
import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase', () {
    test('should get products from the repository', () async {
      // arrange
      when(mockRepository.getProducts())
          .thenAnswer((_) async => const Right(testProducts));

      // act
      final result = await useCase.call();

      // assert
      expect(result, const Right(testProducts));
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = ServerFailure('Server Error');
      when(mockRepository.getProducts())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase.call();

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}