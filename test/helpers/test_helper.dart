import 'package:fake_store/core/network/api_manager.dart';
import 'package:fake_store/core/network/network_info.dart';
import 'package:fake_store/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fake_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:fake_store/features/authentication/domain/usecases/check_auth_status_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/get_user_details_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/login_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/get_cart_items_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/get_cart_total_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:fake_store/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:fake_store/features/product/data/datasources/product_data_source.dart';
import 'package:fake_store/features/product/domain/repositories/product_repository.dart';
import 'package:fake_store/features/product/domain/usecases/get_categories_use_case.dart';
import 'package:fake_store/features/product/domain/usecases/get_product_by_id_use_case.dart';
import 'package:fake_store/features/product/domain/usecases/get_products_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  // Network
  NetworkInfo,
  ApiManager,
  Connectivity,
  SharedPreferences,
  
  // Product
  ProductRepository,
  ProductDataSource,
  GetProductsUseCase,
  GetProductByIdUseCase,
  GetCategoriesUseCase,
  
  // Authentication
  AuthRepository,
  CheckAuthStatusUseCase,
  GetUserDetailsUseCase,
  LoginUseCase,
  LogoutUseCase,
  
  // Cart
  CartRepository,
  AddToCartUseCase,
  RemoveFromCartUseCase,
  UpdateCartItemUseCase,
  GetCartItemsUseCase,
  GetCartTotalUseCase,
], customMocks: [
  MockSpec<Dio>(as: #MockDio),
])
void main() {}