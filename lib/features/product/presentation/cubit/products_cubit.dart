import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';
import 'package:fake_store/features/product/domain/usecases/get_categories_use_case.dart';
import 'package:fake_store/features/product/domain/usecases/get_products_use_case.dart';
import 'package:fake_store/features/product/domain/repositories/product_repository.dart';

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
      (failure) => emit(ProductsError(message: failure.message)),
      (products) {
        categoriesResult.fold(
          (failure) => emit(ProductsLoaded(products: products, categories: [])),
          (categories) => emit(ProductsLoaded(
            products: products,
            categories: categories,
          )),
        );
      },
    );
  }

  Future<void> loadProductsByCategory(String? category) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(ProductsLoading());

      if (category == null || category.isEmpty) {
        final result = await getProductsUseCase();
        result.fold(
          (failure) => emit(ProductsError(message: failure.message)),
          (products) => emit(ProductsLoaded(
            products: products,
            categories: currentState.categories,
            selectedCategory: null,
          )),
        );
      } else {
        final result = await productRepository.getProductsByCategory(category);
        result.fold(
          (failure) => emit(ProductsError(message: failure.message)),
          (products) => emit(ProductsLoaded(
            products: products,
            categories: currentState.categories,
            selectedCategory: category,
          )),
        );
      }
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}