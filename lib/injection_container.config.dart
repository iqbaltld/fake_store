// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/base/base_repository.dart' as _i162;
import 'core/network/api_manager.dart' as _i90;
import 'core/network/network_info.dart' as _i75;
import 'core/theme/cubit/theme_cubit.dart' as _i577;
import 'features/authentication/data/datasources/auth_data_source.dart'
    as _i313;
import 'features/authentication/data/repositories/auth_repository_impl.dart'
    as _i446;
import 'features/authentication/domain/repositories/auth_repository.dart'
    as _i877;
import 'features/authentication/domain/usecases/check_auth_status_use_case.dart'
    as _i593;
import 'features/authentication/domain/usecases/get_user_details_use_case.dart'
    as _i416;
import 'features/authentication/domain/usecases/login_use_case.dart' as _i583;
import 'features/authentication/domain/usecases/logout_use_case.dart' as _i738;
import 'features/authentication/presentation/cubit/auth_cubit.dart' as _i470;
import 'features/cart/data/datasources/cart_local_data_source.dart' as _i725;
import 'features/cart/data/repositories/cart_repository_impl.dart' as _i302;
import 'features/cart/domain/repositories/cart_repository.dart' as _i303;
import 'features/cart/domain/usecases/add_to_cart_use_case.dart' as _i628;
import 'features/cart/domain/usecases/get_cart_items_use_case.dart' as _i289;
import 'features/cart/domain/usecases/get_cart_total_use_case.dart' as _i468;
import 'features/cart/domain/usecases/remove_from_cart_use_case.dart' as _i589;
import 'features/cart/domain/usecases/update_cart_item_use_case.dart' as _i124;
import 'features/cart/presentation/cubit/cart_cubit.dart' as _i233;
import 'features/product/data/datasources/product_data_source.dart' as _i196;
import 'features/product/data/repositories/product_repository_impl.dart'
    as _i531;
import 'features/product/domain/repositories/product_repository.dart' as _i841;
import 'features/product/domain/usecases/get_categories_use_case.dart' as _i246;
import 'features/product/domain/usecases/get_product_by_id_use_case.dart'
    as _i733;
import 'features/product/domain/usecases/get_products_use_case.dart' as _i244;
import 'features/product/presentation/cubit/product_details_cubit.dart' as _i35;
import 'features/product/presentation/cubit/products_cubit.dart' as _i670;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i75.NetworkInfo>(
      () => _i75.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i90.ApiManager>(
      () => _i90.ApiManagerImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i162.BaseRepository>(
      () => _i162.BaseRepositoryImpl(networkInfo: gh<_i75.NetworkInfo>()),
    );
    gh.lazySingleton<_i577.ThemeCubit>(
      () => _i577.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i313.AuthDataSource>(
      () => _i313.AuthDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i196.ProductDataSource>(
      () => _i196.ProductDataSourceImpl(gh<_i90.ApiManager>()),
    );
    gh.lazySingleton<_i725.CartLocalDataSource>(
      () => _i725.CartLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i877.AuthRepository>(
      () => _i446.AuthRepositoryImpl(
        gh<_i313.AuthDataSource>(),
        gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i841.ProductRepository>(
      () => _i531.ProductRepositoryImpl(
        productDataSource: gh<_i196.ProductDataSource>(),
        networkInfo: gh<_i75.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i303.CartRepository>(
      () => _i302.CartRepositoryImpl(gh<_i725.CartLocalDataSource>()),
    );
    gh.lazySingleton<_i246.GetCategoriesUseCase>(
      () => _i246.GetCategoriesUseCase(gh<_i841.ProductRepository>()),
    );
    gh.lazySingleton<_i244.GetProductsUseCase>(
      () => _i244.GetProductsUseCase(gh<_i841.ProductRepository>()),
    );
    gh.lazySingleton<_i733.GetProductByIdUseCase>(
      () => _i733.GetProductByIdUseCase(gh<_i841.ProductRepository>()),
    );
    gh.lazySingleton<_i670.ProductsCubit>(
      () => _i670.ProductsCubit(
        gh<_i244.GetProductsUseCase>(),
        gh<_i246.GetCategoriesUseCase>(),
        gh<_i841.ProductRepository>(),
      ),
    );
    gh.lazySingleton<_i35.ProductDetailsCubit>(
      () => _i35.ProductDetailsCubit(gh<_i733.GetProductByIdUseCase>()),
    );
    gh.lazySingleton<_i738.LogoutUseCase>(
      () => _i738.LogoutUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i593.CheckAuthStatusUseCase>(
      () => _i593.CheckAuthStatusUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i583.LoginUseCase>(
      () => _i583.LoginUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i416.GetUserDetailsUseCase>(
      () => _i416.GetUserDetailsUseCase(gh<_i877.AuthRepository>()),
    );
    gh.lazySingleton<_i468.GetCartTotalUseCase>(
      () => _i468.GetCartTotalUseCase(gh<_i303.CartRepository>()),
    );
    gh.lazySingleton<_i124.UpdateCartItemUseCase>(
      () => _i124.UpdateCartItemUseCase(gh<_i303.CartRepository>()),
    );
    gh.lazySingleton<_i628.AddToCartUseCase>(
      () => _i628.AddToCartUseCase(gh<_i303.CartRepository>()),
    );
    gh.lazySingleton<_i589.RemoveFromCartUseCase>(
      () => _i589.RemoveFromCartUseCase(gh<_i303.CartRepository>()),
    );
    gh.lazySingleton<_i289.GetCartItemsUseCase>(
      () => _i289.GetCartItemsUseCase(gh<_i303.CartRepository>()),
    );
    gh.lazySingleton<_i470.AuthCubit>(
      () => _i470.AuthCubit(
        gh<_i583.LoginUseCase>(),
        gh<_i738.LogoutUseCase>(),
        gh<_i416.GetUserDetailsUseCase>(),
        gh<_i593.CheckAuthStatusUseCase>(),
      ),
    );
    gh.lazySingleton<_i233.CartCubit>(
      () => _i233.CartCubit(
        gh<_i289.GetCartItemsUseCase>(),
        gh<_i628.AddToCartUseCase>(),
        gh<_i124.UpdateCartItemUseCase>(),
        gh<_i589.RemoveFromCartUseCase>(),
        gh<_i468.GetCartTotalUseCase>(),
      ),
    );
    return this;
  }
}
