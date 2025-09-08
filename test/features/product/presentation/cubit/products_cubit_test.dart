import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fake_store/core/error/failures.dart';
import 'package:fake_store/features/product/presentation/cubit/products_cubit.dart';
import '../../../../helpers/test_helper.mocks.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  late ProductsCubit productsCubit;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockProductRepository = MockProductRepository();
    productsCubit = ProductsCubit(
      mockGetProductsUseCase,
      mockGetCategoriesUseCase,
      mockProductRepository,
    );
  });

  test('initial state should be ProductsInitial', () {
    expect(productsCubit.state, ProductsInitial());
  });

  group('loadProducts', () {
    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when products are loaded successfully',
      build: () {
        when(mockGetProductsUseCase.call())
            .thenAnswer((_) async => const Right(testProducts));
        when(mockGetCategoriesUseCase.call())
            .thenAnswer((_) async => const Right(testCategories));
        return productsCubit;
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(
          products: testProducts,
          categories: testCategories,
          selectedCategory: null,
        ),
      ],
      verify: (cubit) {
        verify(mockGetProductsUseCase.call());
        verify(mockGetCategoriesUseCase.call());
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsError] when loading products fails',
      build: () {
        const failure = ServerFailure('Server Error');
        when(mockGetProductsUseCase.call())
            .thenAnswer((_) async => const Left(failure));
        when(mockGetCategoriesUseCase.call())
            .thenAnswer((_) async => const Right(testCategories));
        return productsCubit;
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        ProductsLoading(),
        const ProductsError(message: 'Server Error'),
      ],
      verify: (cubit) {
        verify(mockGetProductsUseCase.call());
        verify(mockGetCategoriesUseCase.call());
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when loading categories fails but products succeed',
      build: () {
        const failure = ServerFailure('Categories Error');
        when(mockGetProductsUseCase.call())
            .thenAnswer((_) async => const Right(testProducts));
        when(mockGetCategoriesUseCase.call())
            .thenAnswer((_) async => const Left(failure));
        return productsCubit;
      },
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(
          products: testProducts,
          categories: const [],
          selectedCategory: null,
        ),
      ],
      verify: (cubit) {
        verify(mockGetProductsUseCase.call());
        verify(mockGetCategoriesUseCase.call());
      },
    );
  });

  group('refreshProducts', () {
    blocTest<ProductsCubit, ProductsState>(
      'emits [ProductsLoading, ProductsLoaded] when products are refreshed successfully',
      build: () {
        when(mockGetProductsUseCase.call())
            .thenAnswer((_) async => const Right(testProducts));
        when(mockGetCategoriesUseCase.call())
            .thenAnswer((_) async => const Right(testCategories));
        return productsCubit;
      },
      act: (cubit) => cubit.refreshProducts(),
      expect: () => [
        ProductsLoading(),
        ProductsLoaded(
          products: testProducts,
          categories: testCategories,
          selectedCategory: null,
        ),
      ],
      verify: (cubit) {
        verify(mockGetProductsUseCase.call());
        verify(mockGetCategoriesUseCase.call());
      },
    );
  });

  tearDown(() {
    productsCubit.close();
  });
}