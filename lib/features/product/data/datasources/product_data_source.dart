import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/network/api_manager.dart';
import '../models/product_model.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

abstract class ProductRemoteDataSource extends ProductDataSource {}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiManager _apiManager;

  ProductRemoteDataSourceImpl(this._apiManager);

  @override
  Future<List<ProductModel>> getProducts() {
    return _apiManager.get<List<ProductModel>>(
      ApiUrls.products,
      fromJson: (data) {
        final List<dynamic> list = data as List<dynamic>;
        return list.map((json) => ProductModel.fromJson(json)).toList();
      },
    );
  }

  @override
  Future<ProductModel> getProductById(int id) {
    return _apiManager.get<ProductModel>(
      '${ApiUrls.productDetails}/$id',
      fromJson: (data) => ProductModel.fromJson(data),
    );
  }

  @override
  Future<List<String>> getCategories() {
    return _apiManager.get<List<String>>(
      '${ApiUrls.products}/categories',
      fromJson: (data) {
        final List<dynamic> list = data as List<dynamic>;
        return list.map((category) => category.toString()).toList();
      },
    );
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) {
    return _apiManager.get<List<ProductModel>>(
      '${ApiUrls.products}/category/$category',
      fromJson: (data) {
        final List<dynamic> list = data as List<dynamic>;
        return list.map((json) => ProductModel.fromJson(json)).toList();
      },
    );
  }
}