import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_repository.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_data_source.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl extends BaseRepositoryImpl implements ProductRepository {
  final ProductDataSource productDataSource;

  ProductRepositoryImpl({
    required this.productDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() {
    return handleApiCall<List<Product>>(
      call: () => productDataSource.getProducts(),
      onSuccess: (data) => data as List<Product>,
      context: 'get products',
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) {
    return handleApiCall<Product>(
      call: () => productDataSource.getProductById(id),
      onSuccess: (data) => data as Product,
      context: 'get product by id',
    );
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() {
    return handleApiCall<List<String>>(
      call: () => productDataSource.getCategories(),
      onSuccess: (data) => data as List<String>,
      context: 'get categories',
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) {
    return handleApiCall<List<Product>>(
      call: () => productDataSource.getProductsByCategory(category),
      onSuccess: (data) => data as List<Product>,
      context: 'get products by category',
    );
  }
}