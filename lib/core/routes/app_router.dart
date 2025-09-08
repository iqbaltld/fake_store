import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/features/authentication/presentation/screens/login_screen.dart';
import 'package:fake_store/features/cart/presentation/screens/cart_screen.dart';
import 'package:fake_store/features/product/presentation/cubit/product_details_cubit.dart';
import 'package:fake_store/features/product/presentation/screens/products_screen.dart';
import 'package:fake_store/features/product/presentation/screens/product_details_screen.dart';
import 'package:fake_store/features/splash/screens/splash_screen.dart';
import 'package:fake_store/injection_container.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case ProductsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());

      case ProductDetailsScreen.routeName:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProductDetailsCubit>(),
            child: ProductDetailsScreen(productId: productId),
          ),
        );

      case CartScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
