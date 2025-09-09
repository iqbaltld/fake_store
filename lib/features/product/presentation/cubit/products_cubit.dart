import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';
import 'package:fake_store/features/product/domain/usecases/get_categories_use_case.dart';
import 'package:fake_store/features/product/domain/usecases/get_products_use_case.dart';
import 'package:fake_store/features/product/domain/repositories/product_repository.dart';
import 'package:fake_store/core/error/failures.dart';

part 'products_state.dart';

@LazySingleton()
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final ProductRepository productRepository;

  ProductsCubit(
    this.getProductsUseCase,
    this.getCategoriesUseCase,
    this.productRepository,
  ) : super(ProductsInitial());

  Future<void> loadProducts() async {
    emit(ProductsLoading());

    // Load both products and categories
    final productsResult = await getProductsUseCase();
    final categoriesResult = await getCategoriesUseCase();

    productsResult.fold(
      (failure) => _handleFailure(failure),
      (products) {
        categoriesResult.fold(
          (failure) => emit(ProductsLoaded(
            products: products, 
            categories: [],
            isFromCache: failure is NetworkFailure,
          )),
          (categories) => emit(ProductsLoaded(
            products: products,
            categories: categories,
            isFromCache: false,
          )),
        );
      },
    );
  }

  void _handleFailure(Failure failure) {
    String message = failure.message;
    
    // Provide user-friendly messages for different failure types
    if (failure is NetworkFailure) {
      if (failure.message.contains('No internet connection and no cached data')) {
        message = 'No internet connection. Please check your connection and try again.';
      } else if (failure.message.contains('No internet connection')) {
        message = 'No internet connection. Showing cached products.';
      }
    }
    
    emit(ProductsError(message: message));
  }

  Future<void> loadProductsByCategory(String? category) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(ProductsLoading());

      if (category == null || category.isEmpty) {
        final result = await getProductsUseCase();
        result.fold(
          (failure) => _handleFailure(failure),
          (products) => emit(ProductsLoaded(
            products: products,
            categories: currentState.categories,
            selectedCategory: null,
            isFromCache: false,
          )),
        );
      } else {
        final result = await productRepository.getProductsByCategory(category);
        result.fold(
          (failure) => _handleFailure(failure),
          (products) => emit(ProductsLoaded(
            products: products,
            categories: currentState.categories,
            selectedCategory: category,
            isFromCache: false,
          )),
        );
      }
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}