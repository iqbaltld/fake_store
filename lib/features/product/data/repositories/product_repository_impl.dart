import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_repository.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_data_source.dart';
import '../datasources/product_local_data_source.dart';
import '../models/product_model.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl extends BaseRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      const cacheKey = 'cached_products';
      
      // Check if we have internet connection
      if (await networkInfo.isConnected) {
        // Check if cache is still fresh
        final isCacheExpired = await localDataSource.isCacheExpired(cacheKey);
        
        if (!isCacheExpired) {
          // Cache is still fresh, use it
          final cachedProducts = await localDataSource.getCachedProducts();
          if (cachedProducts.isNotEmpty) {
            return Right(cachedProducts as List<Product>);
          }
        }
        
        // Cache expired or doesn't exist, try to get fresh data from remote
        final result = await handleApiCall<List<Product>>(
          call: () => remoteDataSource.getProducts(),
          onSuccess: (data) => data as List<Product>,
          context: 'get products',
        );
        
        return result.fold(
          (failure) async {
            // If remote call fails, try to get cached data as fallback
            final cachedProducts = await localDataSource.getCachedProducts();
            if (cachedProducts.isNotEmpty) {
              return Right(cachedProducts as List<Product>);
            }
            return Left(failure);
          },
          (products) async {
            // Cache the fresh data
            await localDataSource.cacheProducts(products as List<ProductModel>);
            return Right(products);
          },
        );
      } else {
        // No internet, try to get cached data
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts as List<Product>);
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure( 'Failed to get products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      // Check if we have internet connection
      if (await networkInfo.isConnected) {
        // For product details, always try to fetch fresh data when online
        final result = await handleApiCall<Product>(
          call: () => remoteDataSource.getProductById(id),
          onSuccess: (data) => data as Product,
          context: 'get product by id',
        );
        
        return result.fold(
          (failure) async {
            // If remote call fails, try to get cached data as fallback
            final cachedProduct = await localDataSource.getCachedProductById(id);
            if (cachedProduct != null) {
              return Right(cachedProduct as Product);
            }
            return Left(failure);
          },
          (product) async {
            // Cache the fresh data for offline use
            await localDataSource.cacheProduct(product as ProductModel);
            return Right(product);
          },
        );
      } else {
        // No internet, try to get cached data
        final cachedProduct = await localDataSource.getCachedProductById(id);
        if (cachedProduct != null) {
          return Right(cachedProduct as Product);
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure( 'Failed to get product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      const cacheKey = 'cached_categories';
      
      // Check if we have internet connection
      if (await networkInfo.isConnected) {
        // Check if cache is still fresh
        final isCacheExpired = await localDataSource.isCacheExpired(cacheKey);
        
        if (!isCacheExpired) {
          // Cache is still fresh, use it
          final cachedCategories = await localDataSource.getCachedCategories();
          if (cachedCategories.isNotEmpty) {
            return Right(cachedCategories);
          }
        }
        
        // Cache expired or doesn't exist, try to get fresh data from remote
        final result = await handleApiCall<List<String>>(
          call: () => remoteDataSource.getCategories(),
          onSuccess: (data) => data as List<String>,
          context: 'get categories',
        );
        
        return result.fold(
          (failure) async {
            // If remote call fails, try to get cached data as fallback
            final cachedCategories = await localDataSource.getCachedCategories();
            if (cachedCategories.isNotEmpty) {
              return Right(cachedCategories);
            }
            return Left(failure);
          },
          (categories) async {
            // Cache the fresh data
            await localDataSource.cacheCategories(categories);
            return Right(categories);
          },
        );
      } else {
        // No internet, try to get cached data
        final cachedCategories = await localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Right(cachedCategories);
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure( 'Failed to get categories: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    try {
      final cacheKey = 'cached_category_products_$category';
      
      // Check if we have internet connection
      if (await networkInfo.isConnected) {
        // Check if cache is still fresh
        final isCacheExpired = await localDataSource.isCacheExpired(cacheKey);
        
        if (!isCacheExpired) {
          // Cache is still fresh, use it
          final cachedProducts = await localDataSource.getCachedProductsByCategory(category);
          if (cachedProducts.isNotEmpty) {
            return Right(cachedProducts as List<Product>);
          }
        }
        
        // Cache expired or doesn't exist, try to get fresh data from remote
        final result = await handleApiCall<List<Product>>(
          call: () => remoteDataSource.getProductsByCategory(category),
          onSuccess: (data) => data as List<Product>,
          context: 'get products by category',
        );
        
        return result.fold(
          (failure) async {
            // If remote call fails, try to get cached data as fallback
            final cachedProducts = await localDataSource.getCachedProductsByCategory(category);
            if (cachedProducts.isNotEmpty) {
              return Right(cachedProducts as List<Product>);
            }
            return Left(failure);
          },
          (products) async {
            // Cache the fresh data
            await localDataSource.cacheProductsByCategory(category, products as List<ProductModel>);
            return Right(products);
          },
        );
      } else {
        // No internet, try to get cached data
        final cachedProducts = await localDataSource.getCachedProductsByCategory(category);
        if (cachedProducts.isNotEmpty) {
          return Right(cachedProducts as List<Product>);
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      }
    } catch (e) {
      return Left(CacheFailure( 'Failed to get products by category: ${e.toString()}'));
    }
  }
}