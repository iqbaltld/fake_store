import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel?> getCachedProductById(int id);
  Future<void> cacheProduct(ProductModel product);
  Future<List<String>> getCachedCategories();
  Future<void> cacheCategories(List<String> categories);
  Future<List<ProductModel>> getCachedProductsByCategory(String category);
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products);
  Future<bool> isCacheExpired(String key);
  Future<void> setCacheTimestamp(String key);
  Future<void> clearCache();
  Future<void> clearSpecificCache(String key);
}

@LazySingleton(as: ProductLocalDataSource)
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Cache keys
  static const String _productsKey = 'cached_products';
  static const String _categoriesKey = 'cached_categories';
  static const String _productPrefix = 'cached_product_';
  static const String _categoryProductsPrefix = 'cached_category_products_';
  static const String _timestampSuffix = '_timestamp';
  
  // Cache duration: 1 hour
  static const int _cacheDurationHours = 1;

  ProductLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final jsonString = sharedPreferences.getString(_productsKey);
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonString = json.encode(products.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(_productsKey, jsonString);
      await setCacheTimestamp(_productsKey);
    } catch (e) {
      // Silently fail if caching fails
    }
  }

  @override
  Future<ProductModel?> getCachedProductById(int id) async {
    try {
      final jsonString = sharedPreferences.getString('$_productPrefix$id');
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString);
      return ProductModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final jsonString = json.encode(product.toJson());
      await sharedPreferences.setString('$_productPrefix${product.id}', jsonString);
      await setCacheTimestamp('$_productPrefix${product.id}');
    } catch (e) {
      // Silently fail if caching fails
    }
  }

  @override
  Future<List<String>> getCachedCategories() async {
    try {
      final jsonString = sharedPreferences.getString(_categoriesKey);
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<String>();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheCategories(List<String> categories) async {
    try {
      final jsonString = json.encode(categories);
      await sharedPreferences.setString(_categoriesKey, jsonString);
      await setCacheTimestamp(_categoriesKey);
    } catch (e) {
      // Silently fail if caching fails
    }
  }

  @override
  Future<List<ProductModel>> getCachedProductsByCategory(String category) async {
    try {
      final jsonString = sharedPreferences.getString('$_categoryProductsPrefix$category');
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products) async {
    try {
      final jsonString = json.encode(products.map((p) => p.toJson()).toList());
      await sharedPreferences.setString('$_categoryProductsPrefix$category', jsonString);
      await setCacheTimestamp('$_categoryProductsPrefix$category');
    } catch (e) {
      // Silently fail if caching fails
    }
  }

  @override
  Future<bool> isCacheExpired(String key) async {
    try {
      final timestampKey = '$key$_timestampSuffix';
      final timestamp = sharedPreferences.getInt(timestampKey);
      if (timestamp == null) return true;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);
      
      return difference.inHours >= _cacheDurationHours;
    } catch (e) {
      return true; // If there's any error, consider cache expired
    }
  }

  @override
  Future<void> setCacheTimestamp(String key) async {
    try {
      final timestampKey = '$key$_timestampSuffix';
      await sharedPreferences.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Silently fail if setting timestamp fails
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = sharedPreferences.getKeys().where((key) => 
        key.startsWith(_productsKey) || 
        key.startsWith(_categoriesKey) || 
        key.startsWith(_productPrefix) || 
        key.startsWith(_categoryProductsPrefix)
      ).toList();
      
      for (final key in keys) {
        await sharedPreferences.remove(key);
      }
    } catch (e) {
      // Silently fail if clearing cache fails
    }
  }

  @override
  Future<void> clearSpecificCache(String key) async {
    try {
      await sharedPreferences.remove(key);
      await sharedPreferences.remove('$key$_timestampSuffix');
    } catch (e) {
      // Silently fail if clearing specific cache fails
    }
  }
}