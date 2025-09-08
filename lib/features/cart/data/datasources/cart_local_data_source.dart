import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> cartItems);
  Future<void> clearCart();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cartKey = 'cart_items';

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(_cartKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: 'Failed to get cart items');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> cartItems) async {
    try {
      final jsonList = cartItems.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(_cartKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save cart items');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(_cartKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cart');
    }
  }
}